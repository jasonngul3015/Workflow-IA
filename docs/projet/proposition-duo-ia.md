# Décisions : deux IA sur un même chantier

Historique des choix. Les règles applicables sont uniquement dans [WORKFLOW.md](../../WORKFLOW.md),
[chantier.md](../workflow/chantier.md) et [duo.md](../workflow/duo.md) ; ce fichier ne les répète pas.

| Date | Décision | Raison |
| --- | --- | --- |
| 2026-10-22 | Rôles Patrick (créateur, seul interlocuteur de l'utilisateur) et Fanny, indépendants des outils | Un seul point de contact, outils interchangeables |
| 2026-10-22 | Communication par fichiers locaux, réveil manuel par le développeur, sans sous-agents ni relais | Pas de dépendance à un mécanisme propre à un outil |
| 2026-10-22 | Fiche durable par tâche et index du chantier | Reprise possible sans historique de conversation |
| 2026-10-22 | Aucun fichier d'entrée propre à un outil requis ; `WORKFLOW.md` est le point d'entrée | Workflow générique |
| 2026-10-23 | Code en parallèle dans des worktrees distincts ; un rédacteur par fichier de suivi (`de-patrick.txt`, `de-fanny.txt`) au lieu d'un journal partagé à tour de rôle | Réduire le temps d'attente et les tokens de chaque IA |
| 2026-10-23 | Messages courts sur une ligne d'en-tête, détails dans la fiche ; lecture à partir du dernier ID traité | Réduire les tokens lus et écrits à chaque réveil |
