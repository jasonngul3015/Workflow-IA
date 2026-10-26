# Adaptateurs d'outils

Le workflow ne dépend d'aucune IA. Un adaptateur sert seulement à brancher un outil : un fichier d'instructions
qui renvoie à `WORKFLOW.md`, ses réglages de permissions et d'éventuels raccourcis. Il ne définit aucune règle.

Pour l'utiliser, copier **le contenu** du dossier de l'outil à la racine du projet. Exemple pour Claude Code :
`adaptateurs/claude-code/CLAUDE.md` et `adaptateurs/claude-code/.claude/` vont à la racine.

| Dossier | Outil(s) | Contenu |
| --- | --- | --- |
| [claude-code/](claude-code/) | Claude Code | `CLAUDE.md`, permissions `.claude/settings.json` (session normale) et `.claude/settings.autonome.json` (session autonome), raccourcis `/tache` et `/chantier` |
| [agents-md/](agents-md/) | Outils qui lisent `AGENTS.md` (Codex et d'autres) | `AGENTS.md` |
| [codex/](codex/) | Codex, en plus de `agents-md/` | `.codex/config.toml` (bac à sable sans réseau) et `.codex/rules/projet.rules` (commandes autorisées ou interdites) |

Les permissions de session autonome ne contiennent que les commandes du workflow (git, `gh`, scripts) : y ajouter
celles de test et de build du projet (réglage **Commandes** de `WORKFLOW.md`). Les règles « demander » visent la
branche `main` : les changer si la **Branche principale** est autre.

Autre outil : voir [docs/workflow/adapter.md](../docs/workflow/adapter.md), section « Brancher une IA ». Un nouvel
adaptateur se range ici dans `adaptateurs/<outil>/`, avec la même structure qu'à la racine d'un projet.
