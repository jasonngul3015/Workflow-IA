# Workflow-IA

Workflow de développement assisté par IA (Claude Code) pour un développeur seul : l'IA écrit le code, l'humain
décide **quoi** faire (la fiche) et **quand fusionner**. Entre les deux, l'IA avance seule, tenue par des
garde-fous mécaniques : tests écrits d'abord, script de vérification, hooks Git, revue de code et CI.

## Le cycle

```
/tache <description>
  Fiche ---------------- ARRÊT : l'utilisateur valide
    (niveau, exemples « situation -> résultat », hors sujet, fichiers, stack,
     tâches parallélisables, agents utilisés)
  Tests rouges -> commit test(...)
  [sensible : ARRÊT algorithmes + tests rouges]
  Algorithme -> code qui le suit, sans toucher aux tests
  Casse volontaire (les tests mordent) -> verifier-tache.ps1 -> /code-review
  Commit feat|fix -> push -> PR -> CI verte -> audit court
  Fusion --------------- ARRÊT : l'utilisateur décide
```

Niveaux : **trivial** (fiche en 3 lignes), **standard** (deux arrêts), **sensible** (authentification, droits,
données personnelles, schéma de base, déploiement : un arrêt de plus). Arrêts imprévus : changement de stack, test
commité qui semble faux, algorithme qui ne tient pas, fiche ambiguë, vérifications rouges après deux corrections.

Gros travail : `/chantier` découpe en tâches, puis jusqu'à 5 agents (un worktree chacun) suivent `/tache` en
parallèle. Une session modératrice leur répond, tient les verrous des ressources partagées (numéros de migration,
configuration centrale, énumérations…) et propose les fusions.

## Contenu

| Fichier | Rôle |
| --- | --- |
| [`WORKFLOW.md`](WORKFLOW.md) | Sections à recopier dans le `CLAUDE.md` du projet : règles communes et réglages à remplir |
| [`.claude/skills/tache/SKILL.md`](.claude/skills/tache/SKILL.md) | Commande `/tache` : une tâche, de la fiche à la fusion |
| [`.claude/skills/chantier/SKILL.md`](.claude/skills/chantier/SKILL.md) | Commande `/chantier` : plusieurs tâches en parallèle, un modérateur |
| [`.claude/settings.json`](.claude/settings.json) | Permissions Claude Code : commit, push, PR, fusion soumis à accord ; `git add -A`, `--no-verify`, `--force` interdits |
| [`.githooks/commit-msg`](.githooks/commit-msg) | Format `type(zone): sujet`, 72 caractères, ligne vide, aucune attribution à l'IA |
| [`.githooks/pre-push`](.githooks/pre-push) | Refuse tout envoi direct vers `main` |
| [`scripts/verifier-tache.ps1`](scripts/verifier-tache.ps1) | Règles mécaniques de la branche : tests d'abord, migrations, règles de code, stack, audit |
| [`scripts/verifier-tache.config.psd1`](scripts/verifier-tache.config.psd1) | Réglages du script pour le projet (exemple : backend Java en couches + frontend TypeScript) |
| [`.github/pull_request_template.md`](.github/pull_request_template.md) | Modèle de PR : fiche, tests, algorithmes, audit, liste « terminé » |
| [`docs/projet/audits/README.md`](docs/projet/audits/README.md) | Modèle de l'audit de fin de tâche |

## Installer dans un projet

1. Copier ces fichiers aux mêmes chemins (sauf `README.md`), et les deux sections de `WORKFLOW.md` dans `CLAUDE.md`.
2. Remplir « Workflow : réglages du projet » dans `CLAUDE.md` : commandes, couches, zones sensibles, sections critiques.
3. Adapter `scripts/verifier-tache.config.psd1` : motifs des tests et du code, migrations, règles de code, liste à faire.
4. Activer les hooks, une fois par clone : `git config core.hooksPath .githooks` (sous Linux ou macOS, les rendre
   exécutables : `chmod +x .githooks/*`).
5. Lancer `./scripts/verifier-tache.ps1 -Base origin/main` dans la CI pour chaque PR (PowerShell 5.1 ou `pwsh`).
6. Commencer une tâche par `/tache <description>` dans Claude Code.

Prérequis : Git, GitHub CLI (`gh`), PowerShell, Claude Code.
