# Adaptateurs d'outils

Le workflow ne dépend d'aucune IA. Un adaptateur sert seulement à brancher un outil : un fichier d'instructions
qui renvoie à `WORKFLOW.md`, ses réglages de permissions et d'éventuels raccourcis. Il ne définit aucune règle.

Pour l'utiliser, copier **le contenu** du dossier de l'outil à la racine du projet. Exemple pour Claude Code :
`adaptateurs/claude-code/CLAUDE.md` et `adaptateurs/claude-code/.claude/` vont à la racine.

| Dossier | Outil(s) | Contenu |
| --- | --- | --- |
| [claude-code/](claude-code/) | Claude Code | `CLAUDE.md`, permissions `.claude/settings.json`, raccourcis `/tache` et `/chantier` |
| [agents-md/](agents-md/) | Outils qui lisent `AGENTS.md` (Codex et d'autres) | `AGENTS.md` ; régler les permissions dans l'outil |

Autre outil : voir [docs/workflow/adapter.md](../docs/workflow/adapter.md), section « Brancher une IA ». Un nouvel
adaptateur se range ici dans `adaptateurs/<outil>/`, avec la même structure qu'à la racine d'un projet.
