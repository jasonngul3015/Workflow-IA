# Test de scripts/suivi.ps1 (index du suivi local, docs/workflow/tache.md, section Suivi local).
# Usage : ./scripts/suivi.test.ps1 ; code de sortie 0 si tout passe, 1 sinon. Compatible PowerShell 5.1 et pwsh.
# Le fichier reste en ASCII : les lettres accentuees sont construites par leur code.

$ErrorActionPreference = 'Stop'
# Noms distincts : PowerShell ne distingue pas la casse des variables ($e et $E seraient la meme)
$eAigu = [char]0xE9 ; $eMajuscule = [char]0xC9 ; $aGrave = [char]0xE0 ; $aCirconflexe = [char]0xE2
# Mots accentues construits a part : dans une liste, la virgule passe avant le +
$resume = "## R${eAigu}sum${eAigu}" ; $etat = "${eMajuscule}tat" ; $etape = "${eMajuscule}tape" ; $miseAJour = "Mise ${aGrave} jour"
$script = Join-Path $PSScriptRoot 'suivi.ps1'
$utf8 = New-Object System.Text.UTF8Encoding($false)
$echecs = New-Object System.Collections.Generic.List[string]

# Verifie une condition et retient son nom si elle echoue
function Assert([bool]$condition, [string]$nom) { if (-not $condition) { $echecs.Add($nom) } }

# Ecrit une fiche de tache en UTF-8 sans BOM
function New-Fiche([string]$dossier, [string]$nom, [string[]]$lignes) {
    [IO.File]::WriteAllText((Join-Path $dossier $nom), ($lignes -join "`n"), $utf8)
}

# Dossier temporaire jetable
$racine = Join-Path ([IO.Path]::GetTempPath()) ("suivi-test-" + [guid]::NewGuid().ToString('N'))
$taches = Join-Path $racine 'taches'
New-Item -ItemType Directory -Path $taches | Out-Null
try {
    # Tache terminee, mise a jour la plus recente
    New-Fiche $taches '2026-10-20-feat-ancienne.md' @(
        "# Ancienne t${aCirconflexe}che", '', $resume, '',
        "- ${etat} : fusionn${eAigu}e", "- ${etape} : fusion", '- Branche : `feat/ancienne`', '- Worktree : aucun',
        '- Responsable : Codex', '- Prochaine action : aucune', "- ${miseAJour} : 2026-10-25 10:00 -0400", '',
        "## ${etat} durable", '', "- ${etat} : ne pas lire cette ligne")
    # Tache en cours, mise a jour plus ancienne
    New-Fiche $taches '2026-10-24-feat-courante.md' @(
        '# Courante', '', $resume, '',
        "- ${etat} : en cours", "- ${etape} : code", '- Branche : `feat/courante`', '- Worktree : `../projet-courante`',
        '- Responsable : Claude Code', '- Prochaine action : finir le code', "- ${miseAJour} : 2026-10-24 09:00 -0400")
    # Fiche sans resume (cles absentes)
    New-Fiche $taches '2026-10-23-fix-vide.md' @("# Sans r${eAigu}sum${eAigu}")

    # 1. Generation de l'index
    & $script -Dossier $racine | Out-Null
    $index = Join-Path $racine 'index.md'
    Assert (Test-Path -LiteralPath $index) 'index.md cree'
    $texte = [IO.File]::ReadAllText($index, $utf8)
    $lignes = @($texte -split "`n" | Where-Object { $_.StartsWith('| [') })
    Assert ($lignes.Count -eq 3) 'une ligne par fiche'
    # 2. Taches en cours avant les taches terminees
    Assert ($lignes.Count -ge 1 -and $lignes[0].Contains('Courante')) 'tache en cours en premier'
    Assert ($lignes.Count -ge 3 -and $lignes[2].Contains('Ancienne')) 'tache terminee en dernier'
    # 3. Contenu repris du resume seulement (pas de la section Etat durable)
    Assert ($texte.Contains('| en cours / code |')) 'etat et etape repris'
    Assert ($texte.Contains('| `feat/courante` |')) 'branche reprise'
    Assert ($texte.Contains('(taches/2026-10-24-feat-courante.md)')) 'lien vers la fiche'
    Assert (-not $texte.Contains('ne pas lire cette ligne')) 'resume seul'
    # 4. Cles absentes signalees par un point d'interrogation
    Assert ($lignes.Count -ge 2 -and $lignes[1].Contains('| ? / ? |')) 'cles absentes'
    # 5. Accents conserves
    Assert ($texte.Contains("| fusionn${eAigu}e / fusion |")) 'accents conserves'
    # 6. Dossier absent : cree avec un index vide
    $neuf = Join-Path $racine 'neuf'
    & $script -Dossier $neuf | Out-Null
    Assert (Test-Path -LiteralPath (Join-Path $neuf 'taches')) 'dossier taches cree'
    Assert (Test-Path -LiteralPath (Join-Path $neuf 'index.md')) 'index vide cree'

    # 7. Dates comparees en temps reel (fuseaux), date non remplie en dernier ; fiche ANSI ; bloc de code ignore
    $autre = Join-Path $racine 'autre'
    $autresTaches = Join-Path $autre 'taches'
    New-Item -ItemType Directory -Path $autresTaches | Out-Null
    # 03:30 UTC le 25 : la plus recente malgre son texte plus petit
    New-Fiche $autresTaches 'a.md' @('# Tardive', '', $resume, '', "- ${etat} : en cours", "- ${miseAJour} : 2026-10-24 23:30 -0400")
    # 01:00 UTC le 25
    New-Fiche $autresTaches 'b.md' @('# Matinale', '', $resume, '', "- ${etat} : en cours", "- ${miseAJour} : 2026-10-25 01:00 +0000")
    # Date du modele non remplie
    New-Fiche $autresTaches 'c.md' @('# Sans date', '', $resume, '', "- ${etat} : en cours", "- ${miseAJour} : <AAAA-MM-JJ HH:MM avec fuseau>")
    # Fiche enregistree dans le codage ANSI (Set-Content de PowerShell 5.1), avec un resume cite dans un bloc de code
    $ansi = [Text.Encoding]::GetEncoding(1252)
    $lignesAnsi = @('# Ancienne en ANSI', '', $resume, '', "- ${etat} : en cours", "- ${miseAJour} : 2026-10-20 08:00 -0400",
        '', '```', $resume, "- ${etat} : fusionn${eAigu}e", '```')
    [IO.File]::WriteAllText((Join-Path $autresTaches 'd.md'), ($lignesAnsi -join "`n"), $ansi)
    & $script -Dossier $autre | Out-Null
    $autresLignes = @([IO.File]::ReadAllText((Join-Path $autre 'index.md'), $utf8) -split "`n" | Where-Object { $_.StartsWith('| [') })
    $ordre = @($autresLignes | ForEach-Object { if ($_ -match '^\| \[([^\]]+)\]') { $Matches[1] } }) -join ','
    Assert ($ordre -eq 'Tardive,Matinale,Ancienne en ANSI,Sans date') "ordre par date reelle (obtenu : $ordre)"
    $ligneAnsi = @($autresLignes | Where-Object { $_.Contains('Ancienne en ANSI') })
    Assert ($ligneAnsi.Count -eq 1 -and $ligneAnsi[0].Contains('| en cours / ? |') -and $ligneAnsi[0].Contains('2026-10-20 08:00')) 'fiche ANSI lue, bloc de code ignore'
}
catch { $echecs.Add("exception : $($_.Exception.Message)") }
finally { Remove-Item -LiteralPath $racine -Recurse -Force -ErrorAction SilentlyContinue }

# Resultat
if ($echecs.Count -gt 0) { Write-Host ("ECHEC : " + ($echecs -join ' ; ')); exit 1 }
Write-Host 'suivi.test : tout passe'
exit 0
