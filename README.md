# Workflow-IA

Workflow générique pour **deux IA choisies par l'utilisateur**, au service d'un développeur seul. L'utilisateur
décide du travail et de la fusion. Les IA suivent les mêmes règles : fiche validée, tests d'abord, algorithmes,
vérification, revue, CI et audit.

## Patrick et Fanny

L'IA qui crée le chantier devient **Patrick** ; l'autre rejoint comme **Fanny**. Les rôles ne dépendent pas des outils.
**Seul Patrick communique avec l'utilisateur** : il découpe, attribue, recueille les validations et présente les PR.
Les deux IA **codent en parallèle**, chacune dans le worktree de sa tâche, et ne s'arrêtent qu'aux décisions humaines.
Le développeur réveille les sessions ; aucun programme de relais n'est nécessaire.
Pas à pas : [mode d'emploi](docs/workflow/mode-emploi-duo.md).

## Démarrer et reprendre

Dans l'outil choisi comme principal :

```text
Crée le chantier « invitations ». Tu es Patrick. Suis WORKFLOW.md et docs/workflow/chantier.md.
```

Dans l'autre outil, une fois le suivi créé :

```text
Tu es Fanny. Rejoins le chantier dans <chemin absolu du dossier de suivi>.
Lis WORKFLOW.md, docs/workflow/duo.md, chantier.md et de-patrick.txt, puis traite les demandes autorisées.
```

Pour réveiller une session (chacune termine par « À réveiller : … ») :

```text
Reprends ton rôle dans <chemin absolu du dossier de suivi> : lis les nouveaux messages et poursuis le travail autorisé.
```

Pour une tâche seule : « Lis WORKFLOW.md puis suis docs/workflow/tache.md pour cette tâche : <description>. »

## Mémoire du chantier

```text
docs/projet/chantiers/<nom>/
  chantier.md      objectifs, limites, identités, validations, index et réservations (Patrick)
  de-patrick.txt   messages de Patrick à Fanny
  de-fanny.txt     messages de Fanny à Patrick
  taches/T001.md   périmètre, état, preuves, blocages et prochaine action (responsable de la tâche)
```

Chaque fichier a **un seul rédacteur** : les deux IA peuvent donc écrire en même temps sans tour de parole. Les
messages sont courts et ajoutés en fin de fichier ; chacun ne relit que ceux qu'il n'a pas encore traités. Une
session sans historique du chat lit ces fichiers puis vérifie branche, commits et diff avant de reprendre.
Patrick sauvegarde le suivi dans sa branche/PR de documentation ; sur une autre machine, récupérer ce suivi et
les branches, puis ajuster les chemins.

## Le cycle d'une tâche

```text
Fiche ---------------- ARRÊT : l'utilisateur valide, par Patrick dans un chantier
Tests rouges -> commit test(...)
[sensible : ARRÊT algorithmes + tests rouges, par Patrick]
Algorithme -> code sans modifier les tests commités
Casse volontaire -> verifier-tache.ps1 -> revue (par l'autre IA dans un chantier)
Commit feat|fix -> push -> PR -> CI verte -> audit
Fusion --------------- ARRÊT : demande explicite de l'utilisateur
```

Niveaux : trivial (déclaré par l'utilisateur, fiche courte), standard, sensible (authentification, droits,
données personnelles, schéma, déploiement et zones sensibles du projet). Arrêts imprévus : changement de stack,
test commité suspect, algorithme impossible, périmètre ambigu ou trop grand, vérifications rouges après deux
corrections. Une tâche purement documentaire remplace les tests par les vérifications prévues dans sa fiche.

## Contenu

| Fichier | Rôle |
| --- | --- |
| [WORKFLOW.md](WORKFLOW.md) | Règles communes et réglages du projet |
| [Procédure tâche](docs/workflow/tache.md) | Fiche, tests, code, PR, audit et arrêts |
| [Procédure chantier](docs/workflow/chantier.md) | Découpage, répartition parallèle, réservations et livraison |
| [Protocole Patrick/Fanny](docs/workflow/duo.md) | Propriété des fichiers, messages, reprise et revue |
| [Mode d'emploi du duo](docs/workflow/mode-emploi-duo.md) | Ce que fait le développeur : démarrer, réveiller, valider, reprendre |
| [Modèle chantier](docs/workflow/modeles/chantier.md), [tâche](docs/workflow/modeles/tache.md), [messages](docs/workflow/modeles/messages.txt) | Fichiers à copier pour chaque chantier |
| [.claude/settings.json](.claude/settings.json) | Permissions Claude Code : commit, push, PR, fusion soumis à accord ; `git add -A`, `--no-verify`, `--force` interdits |
| [.claude/skills/](.claude/skills/) | Raccourcis `/tache` et `/chantier` facultatifs, qui renvoient aux procédures |
| [.githooks/commit-msg](.githooks/commit-msg), [.githooks/pre-push](.githooks/pre-push) | Format des commits et refus des push directs vers main |
| [Vérificateur](scripts/verifier-tache.ps1), [configuration](scripts/verifier-tache.config.psd1) | Contrôles communs et réglages à adapter |
| [Modèle de PR](.github/pull_request_template.md), [audit](docs/projet/audits/README.md) | Preuves, limites et bilan |

## Installer dans un projet

1. Copier `WORKFLOW.md`, `docs/workflow/`, les hooks, scripts et modèles de PR/audit aux mêmes chemins, sans
   écraser les consignes déjà présentes dans le projet sans les examiner. Avec Claude Code, copier aussi
   `.claude/settings.json` (garde-fous de permissions) et, si souhaité, `.claude/skills/`. Pour un autre outil,
   reproduire ces interdictions dans ses propres réglages de permissions.
2. Remplir « Workflow : réglages du projet » dans `WORKFLOW.md` et remplacer la note propre à ce dépôt de modèles.
3. Adapter `scripts/verifier-tache.config.psd1` : commandes de test dans les règles, motifs, couches, migrations,
   stack et liste des choses à faire. La configuration fournie est un exemple Java/TypeScript.
4. Activer les hooks une fois par clone : `git config core.hooksPath .githooks`. Sous Linux/macOS :
   `chmod +x .githooks/*`. Vérifier leur activation dans chaque environnement utilisé.
5. Dans la CI du projet, exécuter `./scripts/verifier-tache.ps1 -Base origin/main` pour chaque PR avec l'historique
   Git nécessaire. Aucune CI n'est installée automatiquement par ces documents.
6. Choisir Patrick, créer le chantier, puis réveiller Fanny avec le chemin du dossier de suivi.

Prérequis pour le cycle complet : Git, GitHub CLI (`gh`), PowerShell et deux IA capables de lire et modifier les
fichiers du projet. Les garde-fous de l'environnement de chaque outil restent applicables.
