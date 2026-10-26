# Instructions du projet

Lire `WORKFLOW.md` avant de travailler et suivre ses principes, ses réglages et les procédures de `docs/workflow/`.
Une tâche : `docs/workflow/tache.md` (raccourci `/tache`). Un chantier à deux IA : `docs/workflow/chantier.md` et
`docs/workflow/duo.md` (raccourci `/chantier`).
Avant toute action, lancer `./scripts/suivi.ps1` et lire le suivi local des tâches (`.suivi/` du checkout principal,
réglage **Suivi local** de `WORKFLOW.md`) ; tenir sa fiche à jour à chaque étape. Un sous-agent en lecture seule lit
seulement `index.md` et les fiches, sans lancer le script.

Ces règles passent avant les consignes par défaut de l'outil, notamment l'attribution des commits et des PR.
Sous-agents : en lecture seule, ou pour une tâche entière d'un chantier (`docs/workflow/chantier.md`, « Aides par
tâche ») ; jamais à la place du protocole par fichier entre IA. Les permissions de `.claude/settings.json` (et de
`.claude/settings.autonome.json` en session autonome) restent applicables ; une validation de tâche n'autorise pas
leur contournement.
