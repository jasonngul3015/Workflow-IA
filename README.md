# Workflow-IA

Un workflow de développement assisté par IA pour un développeur seul, **indépendant des outils** : il fonctionne
avec n'importe quelle IA capable de lire et modifier les fichiers d'un projet, seule ou à deux.

L'IA écrit le code ; le développeur décide du **quoi** (la fiche) et de **la fusion**. Entre les deux, l'IA avance
seule, tenue par des garde-fous vérifiables : tests écrits d'abord, vérificateur, hooks Git, revue et CI.

## Comment c'est organisé

| Couche | Où | Qui l'adapte |
| --- | --- | --- |
| **Principes** : ce qui fait le workflow, commun à tous | [WORKFLOW.md](WORKFLOW.md), section « Principes » | Personne, sauf décision explicite |
| **Réglages** : langue, commits, forge, commandes, IA utilisées… | [WORKFLOW.md](WORKFLOW.md), section « Réglages du projet » | Chaque développeur |
| **Procédures** : déroulé pas à pas, qui cite les réglages | [docs/workflow/](docs/workflow/) | Personne en général |
| **Garde-fous** : hooks, vérificateur, modèle de PR | [.githooks/](.githooks/), [scripts/](scripts/), [.github/](.github/) | Réglages en tête de fichier |
| **Adaptateurs d'outils** : fichier d'instructions, permissions, raccourcis | [adaptateurs/](adaptateurs/), un dossier par outil | Chaque développeur copie celui de son outil |

## Démarrer

1. Copier les fichiers et remplir les réglages : [guide d'adaptation](docs/workflow/adapter.md).
2. Une tâche, avec n'importe quelle IA :

   ```text
   Lis WORKFLOW.md puis suis docs/workflow/tache.md pour cette tâche : <description>.
   ```

3. Plusieurs tâches avec deux IA qui codent en parallèle : [mode d'emploi du duo](docs/workflow/mode-emploi-duo.md).

## Le cycle d'une tâche

```text
Fiche ---------------- ARRÊT : le développeur valide
Tests rouges -> commit des tests seuls
[sensible : ARRÊT algorithmes + tests rouges]
Algorithme -> code qui le suit, sans modifier les tests commités
Casse volontaire -> vérificateur -> revue
Commit -> push -> PR -> CI verte -> audit court
Fusion --------------- ARRÊT : le développeur décide
```

Niveaux : trivial (fiche en 3 lignes), standard, sensible (un arrêt de plus). Arrêts imprévus : changement de stack,
test commité suspect, algorithme impossible, périmètre ambigu ou trop grand, vérifications rouges après deux
corrections.

## Deux IA en parallèle

L'IA qui crée le chantier est l'**IA principale** et la seule à parler au développeur ; l'autre est l'**IA
secondaire**. Chacune code sa tâche dans son worktree, en même temps. Elles communiquent par fichiers texte dont
chacun n'a qu'un seul rédacteur et s'attendent l'une l'autre avec un script (`scripts/attendre-message.ps1`) ; le
développeur ne réveille qu'une session arrêtée. Lancées en **session autonome**, elles ne demandent un clic que
pour ce qui reste réservé au développeur (fusion, branche principale, étiquette…). Une IA qui sait lancer des
sous-agents peut confier une tâche entière à une **aide**, avec sa fiche, son worktree et sa PR. Tout l'état est
conservé dans un dossier de suivi : une session neuve reprend sans l'historique du chat.

## Suivi local des tâches

Chaque tâche, seule ou dans un chantier, a une fiche dans `.suivi/taches/` (dossier de la machine, ignoré par
git). `./scripts/suivi.ps1` en génère `.suivi/index.md` : qui travaille sur quoi, sur quelle branche, dans quel
worktree, et la prochaine action. Toute IA le lance et le lit avant d'agir, et ne touche pas à une tâche en cours
d'une autre.

## Contenu

| Fichier | Rôle |
| --- | --- |
| [WORKFLOW.md](WORKFLOW.md) | Principes et réglages : point d'entrée de toute IA |
| [docs/workflow/adapter.md](docs/workflow/adapter.md) | Adapter à son projet, ses IA, sa forge, ses conventions |
| [docs/workflow/tache.md](docs/workflow/tache.md) | Procédure d'une tâche : fiche, tests, code, PR, audit |
| [docs/workflow/chantier.md](docs/workflow/chantier.md) | Chantier à deux IA : découpage, répartition, réservations, livraison |
| [docs/workflow/duo.md](docs/workflow/duo.md) | Communication entre IA : propriété des fichiers, messages, reprise, revue |
| [docs/workflow/mode-emploi-duo.md](docs/workflow/mode-emploi-duo.md) | Ce que fait le développeur pendant un chantier |
| [docs/workflow/modeles/](docs/workflow/modeles/) | Modèles : chantier, fiche de tâche, messages, audit |
| [.githooks/](.githooks/) | Format des commits, attribution, protection de la branche principale (réglages en tête) |
| [scripts/verifier-tache.ps1](scripts/verifier-tache.ps1) | Contrôles mécaniques, réglés par [verifier-tache.config.psd1](scripts/verifier-tache.config.psd1) (exemple Java/TypeScript) |
| [scripts/suivi.ps1](scripts/suivi.ps1) | Index du suivi local des tâches ; test : [suivi.test.ps1](scripts/suivi.test.ps1) |
| [scripts/attendre-message.ps1](scripts/attendre-message.ps1) | Attente d'un message de l'autre IA d'un chantier |
| [.github/pull_request_template.md](.github/pull_request_template.md) | Modèle de PR |
| [adaptateurs/](adaptateurs/) | Branchement des outils : Claude Code, Codex, outils lisant `AGENTS.md` ; à copier à la racine du projet |
| [docs/projet/](docs/projet/) | Suivi propre à ce dépôt (à ne pas copier) |

Prérequis : Git ; pour le cycle complet, une forge avec CLI (GitHub et `gh` par défaut) et PowerShell (5.1 ou
`pwsh`) pour le vérificateur et les scripts. Les garde-fous de chaque outil restent applicables.

**Défaut connu** : sous Windows, quand `scripts/suivi.ps1` est lancé sans `-Dossier` par un autre shell (Git Bash,
cmd : `powershell -File`) dans un projet dont le chemin contient des lettres accentuées, PowerShell 5.1 décode mal
la sortie de `git` (« Système » devient « Syst├¿me ») : le script crée alors un dossier `.suivi/` parasite, vide,
sous ce chemin déformé, et y écrit un index vide. Lancé depuis PowerShell, il trouve le bon dossier. En attendant
le correctif, depuis un autre shell, lui donner le dossier :
`./scripts/suivi.ps1 -Dossier "<chemin absolu du checkout principal>\.suivi"`.
