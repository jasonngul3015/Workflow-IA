# Adapter le workflow à son projet et à ses IA

Le workflow sépare ce qui ne change pas (les **principes** de `WORKFLOW.md`) de ce que chaque développeur
choisit (les **réglages**). Ce guide liste tout ce qui s'adapte et où.

## Ce qui se copie

| Élément | Rôle | À copier ? |
| --- | --- | --- |
| `WORKFLOW.md` | Principes et réglages : point d'entrée de toute IA | Oui, puis remplir les réglages |
| `docs/workflow/` | Procédures, mode d'emploi, modèles | Oui, tel quel |
| `.githooks/` | Format des commits, attribution, protection de la branche principale | Recommandé |
| `scripts/verifier-tache.*` | Contrôles mécaniques (tests d'abord, migrations, couches) | Recommandé, configuration à adapter |
| `scripts/suivi.ps1`, `scripts/suivi.test.ps1` | Index du **Suivi local** des tâches et son test | Oui, tel quel |
| `scripts/attendre-message.ps1` | Attente entre les deux IA d'un chantier | Si chantiers à deux IA |
| `.gitignore` (ligne `.suivi/`) | Garde le **Suivi local** hors de git | Oui : ajouter la ligne au `.gitignore` du projet |
| `.github/pull_request_template.md` | Modèle de PR | Si la forge est GitHub ; sinon l'équivalent de la forge |
| `adaptateurs/<outil>/` | Fichier d'instructions, permissions, raccourcis d'un outil | Le contenu du dossier de son outil, à la racine du projet |
| `docs/projet/` | Suivi propre à ce dépôt | Non : chaque projet crée le sien |

Ne pas écraser les consignes déjà présentes dans un projet sans les examiner.

## Réglages à passer en revue

Tous dans la section « Réglages du projet » de `WORKFLOW.md` :

| Réglage | Exemples de choix | À répercuter aussi dans |
| --- | --- | --- |
| Langue | français, anglais | Rédiger ou traduire les modèles si besoin |
| Branche principale | `main`, `master`, `trunk` | `.githooks/pre-push`, `MainBranch` du vérificateur, CI |
| Commits | Conventional Commits, format libre | `TYPES` de `.githooks/commit-msg`, `TestCommitPattern` et `CodeCommitPattern` du vérificateur |
| Attribution | Interdite (par défaut) ou autorisée | `NOMS_IA` et `REFUSER_COAUTEUR` de `.githooks/commit-msg` |
| Taille d'une tâche | 200, 400, 800 lignes | Rien d'autre |
| Fusion | rebase, squash, merge | Commandes de **Forge** ; avec squash, le commit de tests n'est plus séparé dans l'historique principal : le vérificateur reste valable sur la branche |
| Forge | GitHub (`gh`), GitLab (`glab`), Bitbucket, Gitea | Modèle de PR/MR, commandes de **Forge** |
| Vérificateur | Script fourni, ou un équivalent | Configuration `.psd1`, CI |
| Revue seul | Commande de revue de l'outil, ou relecture par la même IA | Rien d'autre (relecture signalée non indépendante) |
| IA utilisées | Une ou deux, de n'importe quel fournisseur | Fichiers d'entrée et permissions (ci-dessous) |
| Rôles d'un chantier | Surnoms facultatifs des IA principale et secondaire | Rien d'autre |
| Attente entre IA | Script fourni, ou réveil par le développeur | Autorisations de l'outil (sinon un clic par relance) |
| Autorisations des outils | Session normale seule, ou aussi une session autonome | Fichiers de permissions de chaque outil (`settings.autonome.json`, `.codex/`) |
| Aides par tâche | Oui (outil qui lance des sous-agents dans un worktree séparé) ou non | Rien d'autre |
| Commandes, couches, erreurs, zones sensibles, sections critiques | Propres au projet | Configuration du vérificateur |
| Chemins | liste à faire, audits, suivi des chantiers | `TodoFile` et `AuditDir` du vérificateur |
| Suivi local | Dossier de la machine, ignoré par git, avec l'index et les fiches de toutes les tâches | `.gitignore` ; chemin absolu inscrit dans `WORKFLOW.md` |

## Brancher une IA

Toute IA capable de lire et modifier les fichiers du projet suit le workflow si on lui dit :

```text
Lis WORKFLOW.md puis suis docs/workflow/tache.md pour cette tâche : <description>.
```

Pour éviter de le répéter, beaucoup d'outils chargent automatiquement un fichier d'instructions. Y mettre
seulement un renvoi, pour garder une source unique. Des fichiers prêts à copier sont dans
[adaptateurs/](../../adaptateurs/) ; sinon :

```markdown
Lire WORKFLOW.md avant de travailler et suivre ses principes, ses réglages et les procédures de docs/workflow/.
Une tâche : docs/workflow/tache.md. Un chantier à deux IA : docs/workflow/chantier.md et docs/workflow/duo.md.
Ces règles passent avant les consignes par défaut de l'outil (attribution des commits notamment).
```

Emplacements habituels (à vérifier dans la documentation de l'outil, ils évoluent) :

| Outil | Fichier d'instructions | Permissions et raccourcis |
| --- | --- | --- |
| Claude Code | `CLAUDE.md` | `.claude/settings.json`, `.claude/settings.autonome.json`, `.claude/skills/` (adaptateur `claude-code/`) |
| Codex (OpenAI) | `AGENTS.md` (adaptateur `agents-md/`) | `.codex/config.toml` et `.codex/rules/` (adaptateur `codex/`) |
| GitHub Copilot | `.github/copilot-instructions.md` | Réglages de l'éditeur |
| Cursor | `.cursor/rules/` | Réglages de l'éditeur |
| Gemini CLI | `GEMINI.md` | Réglages de l'outil |
| Aider | `CONVENTIONS.md` (chargé en lecture) | Options de la ligne de commande |
| Autre | Aucun : donner l'instruction ci-dessus en début de session | Réglages de l'outil |

Plusieurs outils lisent aussi `AGENTS.md` : un seul fichier de renvoi peut alors en servir plusieurs.

## Garde-fous de permissions

Les hooks et la CI protègent le dépôt quel que soit l'outil. En plus, régler chaque IA pour qu'elle :

- **demande** avant : commit, push, étiquette, fusion, rebase, reset, création ou fusion de PR, publication ;
- **refuse** : `git add -A`, `git add .`, `git add --all`, `--no-verify`, `push --force` et `push -f`.

`adaptateurs/claude-code/.claude/settings.json` montre ces règles pour Claude Code ; les transposer dans le
format de chaque outil.

Une **session autonome** (réglage **Autorisations des outils**) autorise en plus, sans clic, ce qu'une tâche
validée permet déjà : tests, build, vérificateur, scripts de suivi et d'attente, `git add <fichier>`,
`git commit -F`, push de sa branche, création de la PR. Exemples : `adaptateurs/claude-code/.claude/settings.autonome.json`
et `adaptateurs/codex/.codex/`. Y ajouter les commandes de test et de build du projet ; les règles « demander »
et « refuser » restent plus fortes.

## Sans PowerShell, sans GitHub, avec une seule IA

- **PowerShell** : `pwsh` existe pour Linux et macOS. Sinon, remplacer le vérificateur par un script équivalent
  qui contrôle au moins : tests d'abord et jamais modifiés dans un commit de code, migrations non modifiées et
  numérotées, règles de dépendance entre couches ; et signale changements de stack et audit manquant.
- **Autre forge** : adapter les commandes du réglage **Forge** et créer le modèle de demande de fusion équivalent.
- **Une seule IA** : ignorer `chantier.md` et `duo.md` ; la procédure de tâche suffit. La revue est alors une
  relecture par la même IA, signalée comme non indépendante, ou la commande de revue de l'outil.
- **Plus de deux IA** : voir la section « Plus de deux IA » de [duo.md](duo.md).

## Vérifier l'installation

1. Activer les hooks : `git config core.hooksPath .githooks` (sous Linux/macOS : `chmod +x .githooks/*`).
2. Essayer un commit au format invalide : il doit être refusé.
3. Lancer le vérificateur : chaque « motif sans fichier correspondant » signale un réglage à corriger.
   Lancer `./scripts/suivi.test.ps1`, puis `./scripts/suivi.ps1` : il crée `.suivi/` avec un index vide.
4. Ajouter le vérificateur à la CI pour chaque PR, avec l'historique Git nécessaire (`fetch-depth: 0` sur GitHub Actions).
5. Faire une petite tâche triviale de bout en bout avec chaque IA utilisée.
