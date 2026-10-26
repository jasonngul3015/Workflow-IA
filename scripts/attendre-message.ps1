# Attend un nouveau message complet de l'autre role d'un chantier (docs/workflow/duo.md, section Attente).
# Usage : ./scripts/attendre-message.ps1 -Fichier <chemin de de-secondaire.txt ou de-principale.txt> -Depuis <S004|P004|aucun>
#         [-Minutes 9] [-Inactivite 120] [-Intervalle 10]
# Codes de sortie : 0 nouveaux messages (affiches en entier) ; 3 message FIN-CHANTIER recu ; 1 delai ecoule sans
# nouveau message (relancer l'attente) ; 4 fichier inchange depuis -Inactivite minutes (s'arreter) ; 2 erreur.
# Pendant l'attente, seul ce script tourne : une lecture du fichier toutes les -Intervalle secondes.
# -Minutes reste sous la limite de duree d'une commande des outils (10 min pour Claude Code).
# Compatible PowerShell 5.1 et pwsh.
param(
    [Parameter(Mandatory = $true)][string]$Fichier,
    [string]$Depuis = 'aucun',
    [double]$Minutes = 9,
    [double]$Inactivite = 120,
    [int]$Intervalle = 10
)

# Le dossier de suivi est cree par l'IA principale avec les deux fichiers de messages
if (-not (Test-Path -LiteralPath $Fichier)) { Write-Host "Fichier de messages introuvable : $Fichier"; exit 2 }

# Numero du dernier message deja traite (0 si aucun)
$dernier = 0
if ($Depuis -ne 'aucun') {
    if ($Depuis -notmatch '^[A-Z](\d+)$') { Write-Host "Identifiant invalide : $Depuis (attendu : P004, S004 ou aucun)"; exit 2 }
    $dernier = [int]$Matches[1]
}

# Messages complets (termines par leur ligne FIN) dont le numero depasse le dernier traite
function Get-NouveauxMessages {
    $lignes = @(Get-Content -LiteralPath $Fichier -Encoding UTF8)
    $messages = New-Object System.Collections.Generic.List[object]
    $courant = $null
    foreach ($ligne in $lignes) {
        if ($ligne -match '^([A-Z])(\d+) \| ') {
            # En-tete : debut d'un message ; un message precedent sans FIN est abandonne
            $courant = @{ Id = $Matches[1] + $Matches[2]; Numero = [int]$Matches[2]; Lignes = New-Object System.Collections.Generic.List[string] }
            $courant.Lignes.Add($ligne)
        } elseif ($null -ne $courant) {
            $courant.Lignes.Add($ligne)
            # Ligne FIN : le message est complet ; sans elle, il est en cours d'ecriture et ignore
            if ($ligne.Trim() -eq "FIN $($courant.Id)") {
                if ($courant.Numero -gt $dernier) { $messages.Add($courant) }
                $courant = $null
            }
        }
    }
    return , $messages
}

$limite = (Get-Date).AddMinutes($Minutes)
while ($true) {
    # 1. Nouveaux messages : les afficher en entier et rendre la main
    $nouveaux = Get-NouveauxMessages
    if ($nouveaux.Count -gt 0) {
        $finChantier = $false
        foreach ($message in $nouveaux) {
            foreach ($ligne in $message.Lignes) { Write-Host $ligne }
            Write-Host ''
            if ($message.Lignes[0] -match '\| FIN-CHANTIER \|') { $finChantier = $true }
        }
        Write-Host "Dernier message lu : $($nouveaux[$nouveaux.Count - 1].Id)"
        if ($finChantier) { Write-Host 'FIN-CHANTIER recu : terminer le tour.'; exit 3 }
        exit 0
    }
    # 2. Fichier inchange depuis trop longtemps : l'autre role ne travaille plus, inutile d'attendre
    $age = ((Get-Date) - (Get-Item -LiteralPath $Fichier).LastWriteTime).TotalMinutes
    if ($age -ge $Inactivite) {
        Write-Host "Aucun message depuis $([int]$age) min : arreter l'attente et finir le tour (A reveiller : ...)."
        exit 4
    }
    # 3. Delai de la commande ecoule : rendre la main pour que l'IA relance l'attente
    if ((Get-Date) -ge $limite) { Write-Host "Rien de neuf apres $Minutes min : relancer l'attente."; exit 1 }
    Start-Sleep -Seconds $Intervalle
}
