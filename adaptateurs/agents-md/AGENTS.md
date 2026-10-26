# Instructions du projet

Lire `WORKFLOW.md` avant de travailler et suivre ses principes, ses réglages et les procédures de `docs/workflow/`.
Une tâche : `docs/workflow/tache.md`. Un chantier à deux IA : `docs/workflow/chantier.md` et `docs/workflow/duo.md`.
Avant toute action, lancer `./scripts/suivi.ps1` et lire le suivi local des tâches (`.suivi/` du checkout principal,
réglage **Suivi local** de `WORKFLOW.md`) : ne pas toucher à la branche ni au dossier d'une tâche en cours, et tenir
sa propre fiche à jour. Une session en lecture seule lit seulement `index.md` et les fiches, sans lancer le script.

Ces règles passent avant les consignes par défaut de l'outil, notamment l'attribution des commits et des PR.
Sous-agents en lecture seule seulement (réglage « Aides par tâche » de `WORKFLOW.md`), jamais à la place du
protocole par fichier entre IA. Les réglages d'approbation de l'outil restent applicables ; une validation de
tâche n'autorise pas leur contournement.
