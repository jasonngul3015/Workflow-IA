# Genere l'index du suivi local des taches (docs/workflow/tache.md, section Suivi local ; WORKFLOW.md, Suivi local).
# Usage : ./scripts/suivi.ps1 [-Dossier <chemin du suivi local>]
# Sans -Dossier : .suivi/ a la racine du checkout principal, meme lance depuis un worktree.
# Chaque IA n'ecrit que sa fiche (taches/*.md) ; ce script relit leur section Resume et reecrit index.md,
# qu'il ne faut jamais modifier a la main. Une generation concurrente est sans danger : la suivante corrige tout.
# Codes de sortie : 0 index ecrit ; 2 dossier introuvable ou index impossible a ecrire.
# Algorithme : dossier -> fiches -> resume de chaque fiche -> tri -> index
# Compatible PowerShell 5.1 et pwsh. Fichier en ASCII : les lettres accentuees sont construites par leur code.
param([string]$Dossier)

$ErrorActionPreference = 'Stop'
$utf8 = New-Object System.Text.UTF8Encoding($false)
# Decodage strict : leve une erreur sur un fichier qui n'est pas en UTF-8 (fiche ecrite en ANSI)
$utf8Strict = New-Object System.Text.UTF8Encoding($false, $true)
# Noms distincts : PowerShell ne distingue pas la casse des variables
$aGrave = [char]0xE0 ; $eAigu = [char]0xE9 ; $eMajuscule = [char]0xC9 ; $aCirconflexe = [char]0xE2

# Texte sans accents et en minuscules, pour comparer les cles des fiches
function Get-Simple([string]$texte) {
    $decompose = $texte.Normalize([Text.NormalizationForm]::FormD)
    return ($decompose -replace '\p{Mn}', '').ToLowerInvariant().Trim()
}

# Cellule de tableau Markdown : barre verticale echappee, '?' si vide
function Get-Cellule([string]$valeur) {
    if ([string]::IsNullOrWhiteSpace($valeur)) { return '?' }
    return $valeur.Trim().Replace('|', '\|')
}

# Lignes d'une fiche : UTF-8, sinon codage ANSI de la machine (Set-Content de PowerShell 5.1)
function Get-Lignes([string]$chemin) {
    $octets = [IO.File]::ReadAllBytes($chemin)
    try { $texte = $utf8Strict.GetString($octets) } catch { $texte = [Text.Encoding]::Default.GetString($octets) }
    return $texte.TrimStart([char]0xFEFF) -split "\r?\n"
}

# Date de mise a jour en temps universel ; date absente ou illisible : la plus ancienne possible
function Get-Instant([string]$texte) {
    $normal = ([string]$texte).Trim() -replace '([+-]\d{2})(\d{2})$', '$1:$2'
    $instant = [DateTimeOffset]::MinValue
    $formats = [string[]]@('yyyy-MM-dd HH:mm zzz', 'yyyy-MM-dd HH:mm:ss zzz', 'yyyy-MM-dd HH:mm', 'yyyy-MM-dd')
    $styles = [Globalization.DateTimeStyles]::AssumeUniversal
    $culture = [Globalization.CultureInfo]::InvariantCulture
    if ([DateTimeOffset]::TryParseExact($normal, $formats, $culture, $styles, [ref]$instant)) { return $instant.UtcDateTime }
    return [DateTime]::MinValue
}

# 1. Dossier : par defaut .suivi/ du checkout principal ; cree avec taches/ s'il manque
if ([string]::IsNullOrWhiteSpace($Dossier)) {
    # PowerShell 5.1 change la sortie d'erreur de git en erreur fatale sous 'Stop' : appel encadre
    $commun = $null ; $code = 1
    $ErrorActionPreference = 'Continue'
    try { $commun = & git rev-parse --git-common-dir 2>$null ; $code = $LASTEXITCODE } catch { $code = 1 }
    $ErrorActionPreference = 'Stop'
    if ($code -ne 0 -or [string]::IsNullOrWhiteSpace($commun)) {
        Write-Host 'suivi : pas dans un depot git ; preciser -Dossier'
        exit 2
    }
    # Chemin relatif au dossier courant (checkout principal) ou absolu (worktree)
    $commun = [IO.Path]::GetFullPath([IO.Path]::Combine((Get-Location).ProviderPath, $commun.Trim()))
    $Dossier = Join-Path (Split-Path -Parent $commun) '.suivi'
}
$taches = Join-Path $Dossier 'taches'
if (-not (Test-Path -LiteralPath $taches)) { New-Item -ItemType Directory -Path $taches -Force | Out-Null }

# 2. Fiches : chaque fichier Markdown de taches/
$fiches = @(Get-ChildItem -LiteralPath $taches -Filter '*.md' -File | Sort-Object Name)

# 3. Resume de chaque fiche : titre, puis les lignes "- Cle : valeur" de la section Resume seulement,
#    hors blocs de code et commentaires HTML
$lignes = New-Object System.Collections.Generic.List[object]
foreach ($fiche in $fiches) {
    $titre = $null
    $cles = @{}
    $dansResume = $false ; $dansCode = $false ; $dansCommentaire = $false
    foreach ($ligne in (Get-Lignes $fiche.FullName)) {
        if ($dansCommentaire) { if ($ligne.Contains('-->')) { $dansCommentaire = $false } ; continue }
        if ($ligne.TrimStart().StartsWith('```')) { $dansCode = -not $dansCode ; continue }
        if ($dansCode) { continue }
        if ($ligne.TrimStart().StartsWith('<!--')) { if (-not $ligne.Contains('-->')) { $dansCommentaire = $true } ; continue }
        if ($null -eq $titre -and $ligne -match '^# (.+)$') { $titre = $Matches[1].Trim() ; continue }
        if ($ligne -match '^## (.+)$') { $dansResume = ((Get-Simple $Matches[1]) -eq 'resume') ; continue }
        if ($dansResume -and $ligne -match '^- ([^:]+?) : (.*)$') { $cles[(Get-Simple $Matches[1])] = $Matches[2] }
    }
    if ($null -eq $titre) { $titre = $fiche.BaseName }
    $etat = [string]$cles['etat']
    $valeurs = @((Get-Cellule $titre), $fiche.Name, (Get-Cellule $etat), (Get-Cellule $cles['etape']),
        (Get-Cellule $cles['branche']), (Get-Cellule $cles['worktree']), (Get-Cellule $cles['responsable']),
        (Get-Cellule $cles['prochaine action']), (Get-Cellule $cles['mise a jour']))
    $texte = '| [{0}](taches/{1}) | {2} / {3} | {4} | {5} | {6} | {7} | {8} |' -f $valeurs
    $termine = @('fusionnee', 'annulee') -contains (Get-Simple $etat)
    $lignes.Add([pscustomobject]@{ Termine = $termine; Instant = (Get-Instant $cles['mise a jour']); Texte = $texte })
}

# 4. Tri : taches en cours d'abord, puis les plus recemment mises a jour (temps reel)
$triees = @($lignes | Sort-Object -Property @{ Expression = 'Termine'; Descending = $false }, @{ Expression = 'Instant'; Descending = $true })

# 5. Index : ecrit dans un fichier temporaire puis mis en place (jamais un index a moitie ecrit)
$entete = @(
    "# Suivi local des t${aCirconflexe}ches",
    '',
    "Fichier g${eAigu}n${eAigu}r${eAigu} par ``scripts/suivi.ps1`` ${aGrave} partir des fiches de ``taches/`` : ne pas le modifier ${aGrave} la main.",
    "Chaque IA ne met ${aGrave} jour que sa fiche (section R${eAigu}sum${eAigu}), puis relance le script.",
    '',
    "| T${aCirconflexe}che (fiche) | ${eMajuscule}tat / ${eAigu}tape | Branche | Worktree | Responsable | Prochaine action | Mise ${aGrave} jour |",
    '| --- | --- | --- | --- | --- | --- | --- |'
)
$contenu = (($entete + @($triees | ForEach-Object { $_.Texte })) -join "`n") + "`n"
$index = Join-Path $Dossier 'index.md'
$temporaire = "$index.$PID.tmp"
$ecrit = $false
try {
    [IO.File]::WriteAllText($temporaire, $contenu, $utf8)
    # Fichier occupe (autre generation, synchronisation, editeur) : trois essais
    for ($essai = 1; $essai -le 3 -and -not $ecrit; $essai++) {
        try { Move-Item -LiteralPath $temporaire -Destination $index -Force ; $ecrit = $true }
        catch { if ($essai -lt 3) { Start-Sleep -Milliseconds 300 } }
    }
}
finally { if (Test-Path -LiteralPath $temporaire) { Remove-Item -LiteralPath $temporaire -Force -ErrorAction SilentlyContinue } }
if (-not $ecrit) { Write-Host "suivi : index.md occupe, non mis a jour ; relancer le script"; exit 2 }

# Affiche l'index pour la session qui l'a demande
Write-Output $contenu
