# Verifie les regles mecaniques d'une tache (/tache) sur la branche courante.
# Usage : ./scripts/verifier-tache.ps1 [-Base origin/main] [-Config scripts/verifier-tache.config.psd1]
# Sortie 1 si une regle est violee ; les points « a valider » sont affiches sans bloquer.
# Ce qui depend du projet (chemins, motifs) est dans le fichier de configuration.
# A lancer aussi dans la CI : compatible PowerShell 5.1 et pwsh.
param(
    [string]$Base = 'origin/main',
    [string]$Config = 'scripts/verifier-tache.config.psd1'
)

# Les commandes git ecrivent parfois sur stderr sans echouer : on lit leur code de sortie
$ErrorActionPreference = 'Continue'
# Racine du depot, quel que soit le dossier courant
$root = (& git rev-parse --show-toplevel).Trim()
Set-Location $root

# Reglages du projet
if (-not (Test-Path $Config)) { Write-Host "Configuration introuvable : $Config"; exit 2 }
$cfg = Import-PowerShellDataFile $Config

# Regles violees (bloquantes) et points a valider (informatifs)
$failures = New-Object System.Collections.Generic.List[string]
$notices = New-Object System.Collections.Generic.List[string]

# Point de depart de la branche
$mergeBase = (& git merge-base $Base HEAD)
if ($LASTEXITCODE -ne 0) { Write-Host "Base introuvable : $Base"; exit 2 }
$mergeBase = $mergeBase.Trim()

# Vrai si le chemin correspond a l'un des motifs
function Test-AnyMatch([string]$path, $patterns) {
    foreach ($p in @($patterns)) { if ($path -match $p) { return $true } }
    return $false
}

# Fichier de test, selon les motifs du projet
function Test-IsTestFile([string]$path) { return (Test-AnyMatch $path $cfg.TestPatterns) }

# Code de production qui exige un test d'abord
function Test-IsProductionCode([string]$path) {
    if (Test-IsTestFile $path) { return $false }
    return (Test-AnyMatch $path $cfg.ProductionPatterns)
}

# 1. Commits de la branche : tests d'abord, jamais de test dans un commit feat ou fix
$seenTestCommit = $false
$commits = @(& git log --reverse --format='%H %s' "$mergeBase..HEAD")
foreach ($line in $commits) {
    if ([string]::IsNullOrWhiteSpace($line)) { continue }
    $hash = $line.Substring(0, 40)
    $subject = $line.Substring(41)
    $files = @(& git diff-tree --no-commit-id --name-only -r $hash)
    if ($subject -match '^test(\(|:)') { $seenTestCommit = $true; continue }
    if ($subject -match '^(feat|fix)(\(|:)') {
        foreach ($f in $files) {
            if (Test-IsTestFile $f) { $failures.Add("Test modifie dans un commit de code : $f ($subject)") }
        }
        $code = @($files | Where-Object { Test-IsProductionCode $_ })
        if ($code.Count -gt 0 -and -not $seenTestCommit) {
            $failures.Add("Commit de code sans commit test(...) avant lui : $subject")
        }
    }
}

# 2. Arbre de travail : aucun test modifie apres le commit test(...)
if ($seenTestCommit) {
    foreach ($entry in @(& git status --porcelain)) {
        $path = $entry.Substring(3).Trim('"')
        if (Test-IsTestFile $path) { $failures.Add("Test modifie apres le commit test(...) (non commite) : $path") }
    }
}

# 3. Migrations (si le projet en a) : jamais d'ancienne modifiee, numeros uniques et plus grands que ceux de main
if ($cfg.Migrations -and (Test-Path $cfg.Migrations.Dir)) {
    $migrationDir = $cfg.Migrations.Dir
    $namePattern = $cfg.Migrations.NamePattern
    foreach ($entry in @(& git diff --name-status $mergeBase -- $migrationDir)) {
        if ([string]::IsNullOrWhiteSpace($entry)) { continue }
        $status = $entry.Substring(0, 1)
        if ($status -ne 'A') { $failures.Add("Migration existante modifiee ou supprimee : $entry") }
    }
    # Numeros deja presents sur main
    $baseVersions = @(& git ls-tree --name-only $mergeBase "$migrationDir/" | ForEach-Object {
        $name = Split-Path $_ -Leaf
        if ($name -match $namePattern) { [int]$Matches[1] } })
    $maxBase = 0
    if ($baseVersions.Count -gt 0) { $maxBase = ($baseVersions | Measure-Object -Maximum).Maximum }
    # Numeros presents dans l'arbre de travail
    $seenVersions = @{}
    foreach ($file in Get-ChildItem $migrationDir -File) {
        if ($file.Name -notmatch $namePattern) { $failures.Add("Nom de migration invalide : $($file.Name)"); continue }
        $version = [int]$Matches[1]
        if ($seenVersions.ContainsKey($version)) { $failures.Add("Numero de migration en double : $version") }
        $seenVersions[$version] = $true
        if ($baseVersions -notcontains $version -and $version -le $maxBase) {
            $failures.Add("Nouvelle migration $version inferieure ou egale a la derniere de main ($maxBase)")
        }
    }
}

# 4. Regles de code : motifs interdits par dossier (dependances entre couches, horloge injectee...)
foreach ($rule in @($cfg.CodeRules)) {
    if (-not $rule -or -not (Test-Path $rule.Path)) { continue }
    foreach ($hit in Get-ChildItem $rule.Path -Recurse -File -Filter $rule.Filter | Select-String -Pattern $rule.Pattern) {
        # Lignes ou fichiers autorises malgre le motif
        if ($rule.AllowLine -and $hit.Line -match $rule.AllowLine) { continue }
        if ($rule.AllowPath -and $hit.Path -match $rule.AllowPath) { continue }
        $failures.Add("$($rule.Message) : $($hit.Path | Resolve-Path -Relative):$($hit.LineNumber) : $($hit.Line.Trim())")
    }
}

# 5. Points a valider : changement de stack, liste a faire, audit
$changed = @(& git diff --name-only $mergeBase) + @(& git ls-files --others --exclude-standard)
$stack = @($changed | Where-Object { Test-AnyMatch $_ $cfg.StackPatterns })
foreach ($f in $stack) { $notices.Add("Stack modifiee (etape Stack validee ?) : $f") }
if ($cfg.TodoFile -and $commits.Count -gt 0 -and -not ($changed -contains $cfg.TodoFile)) {
    $notices.Add("$($cfg.TodoFile) non modifie (case a cocher ?)")
}
$branch = (& git rev-parse --abbrev-ref HEAD).Trim()
$auditName = ($branch -replace '/', '-') + '.md'
if ($branch -ne 'HEAD' -and $branch -ne 'main' -and -not (Test-Path "$($cfg.AuditDir)/*-$auditName")) {
    $notices.Add("Audit absent : $($cfg.AuditDir)/AAAA-MM-JJ-$auditName")
}

# Bilan
Write-Host "verifier-tache : $($commits.Count) commit(s) depuis $Base"
foreach ($n in $notices) { Write-Host "  A valider : $n" }
foreach ($f in $failures) { Write-Host "  ECHEC : $f" }
if ($failures.Count -gt 0) { Write-Host "$($failures.Count) regle(s) violee(s)"; exit 1 }
Write-Host 'Regles mecaniques respectees'
exit 0
