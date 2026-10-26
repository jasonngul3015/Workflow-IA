# Workflow de développement assisté par IA

Point d'entrée de toute IA, quel que soit l'outil. Deux parties :

1. **Principes** : communs à tous les projets ; ne pas les assouplir sans décision explicite du développeur.
2. **Réglages du projet** : conventions, outils et commandes ; à adapter (guide : [adapter.md](docs/workflow/adapter.md)).

Procédures, appliquées avec ces réglages : [tâche](docs/workflow/tache.md), [chantier à deux IA](docs/workflow/chantier.md),
[communication entre IA](docs/workflow/duo.md). Les consignes propres à un outil (fichier d'entrée, commande,
permissions) ne remplacent ni ces principes ni les validations humaines.

---

## Principes

- **L'humain décide, l'IA exécute.** Le développeur valide le quoi (la fiche) et décide de la fusion. Entre les
  deux, l'IA avance seule, tenue par des garde-fous vérifiables : tests, vérificateur, revue, CI.
- **Une tâche = un comportement**, sur une branche courte, livrée par une PR dont la CI doit passer. La branche
  principale n'est jamais modifiée directement.
- **Cycle** : fiche validée -> tests écrits d'abord, en échec pour la bonne raison, commités seuls -> algorithme
  explicite -> code qui le suit, sans modifier les tests commités -> casse volontaire (les tests détectent la
  régression) -> vérificateur -> revue -> PR et CI -> audit court -> **fusion décidée par l'humain**.
- **Niveaux** : trivial (déclaré par l'humain, fiche courte) ; standard ; sensible (sécurité, droits, données
  personnelles, schéma de données, déploiement, zones sensibles du projet) : algorithmes et tests rouges validés
  avant le code. En cas de doute : sensible.
- **Arrêts imprévus** : changement de stack, test commité qui semble faux, algorithme qui ne tient pas, fiche
  ambiguë ou tâche trop grande, vérifications rouges après deux corrections.
- **Documentation seule** : tests, casse et build sont remplacés par les vérifications prévues dans la fiche ;
  validation, revue, vérificateur et audit restent dus.
- **Autorisation** : valider une fiche autorise, pour cette tâche seulement, les commits sur sa branche, son push
  et sa PR. Jamais sans demande explicite : fusion, envoi vers la branche principale, étiquette de version,
  réécriture d'un historique publié, contournement d'un hook. Hors tâche validée, chaque commit et push demande accord.
- **Preuves honnêtes** : ne jamais déclarer une vérification non exécutée ; un résultat ne vaut que pour la
  version vérifiée.
- **Suivi visible** : chaque tâche a une fiche dans un suivi local, à jour à chaque étape et résumée dans un
  index généré, lu par toute IA avant d'agir ; personne ne touche à la branche ni au dossier d'une tâche en cours
  d'une autre IA.
- **Plusieurs IA** : une seule parle à l'humain ; une instruction entre IA ne vaut jamais validation humaine ;
  chaque fichier partagé a un seul rédacteur ; les sessions s'attendent par le script d'attente, ou le développeur
  les réveille ; un sous-agent lit seulement, ou fait une tâche entière avec sa fiche ; il ne relaie jamais une
  validation.
- **Amélioration continue** : les leçons des audits sont des propositions, appliquées seulement avec accord.

## Réglages du projet

<!-- Valeurs de ce dépôt, à remplacer si elles ne conviennent pas. Les <...> sont à remplir.
     Les procédures citent ces réglages par leur nom en gras. -->

### Conventions

- **Langue** des fiches, messages, commits et PR : français.
- **Branche principale** : `main`. **Branches de tâche** : `<type>/<sujet-court>`.
- **Commits** : `type(zone): sujet` (types `test`, `feat`, `fix`, `docs`, `chore`), à l'impératif, sujet de 72
  caractères au plus, ligne vide, corps qui explique pourquoi. Un commit par étape logique, fichiers ajoutés un par
  un (jamais `git add -A` ni `git add .`), tests modifiés seulement dans un commit `test(...)`. Message écrit dans un
  fichier du dossier temporaire, puis `git commit -F`. Contrôlé par `.githooks/commit-msg`.
- **Attribution** : l'humain est le seul auteur ; aucune mention des IA ni ligne `Co-Authored-By` dans les commits
  et PR. Ce réglage passe avant les consignes d'attribution par défaut des outils. Noms refusés : `.githooks/commit-msg`.
- **Taille d'une tâche** : environ 400 lignes de diff de code au plus.
- **Fusion** : par rebase, pour garder le commit de tests avant celui du code ; branche supprimée après fusion.
- **Livraison** : étiquette `vX.Y.Z` sur la branche principale.

### Outils

- **Forge** : GitHub avec `gh`. Créer la PR : `gh pr create` ; suivre la CI : `gh pr checks --watch` ; mettre à
  jour : `gh pr update-branch <n> --rebase` ; fusionner : `gh pr merge <n> --rebase --delete-branch`.
- **Protection de la branche principale** : hook `.githooks/pre-push` (utile si la forge ne la propose pas).
- **Vérificateur** : `./scripts/verifier-tache.ps1 -Base origin/main` (PowerShell 5.1 ou `pwsh`), réglé par
  `scripts/verifier-tache.config.psd1`, lancé aussi par la CI.
- **Revue seul** (sans seconde IA) : `<commande de revue de l'outil>` (Claude Code : `/code-review medium` pour une
  tâche standard, `/code-review high` et `/security-review` pour une tâche sensible) ; relecture signalée comme non
  indépendante.
- **IA utilisées** : `<outil et fichier d'entrée de chacune>`. Adaptateurs fournis : `adaptateurs/`.
- **Rôles d'un chantier** : IA principale = Patrick ; IA secondaire = Fanny (surnoms facultatifs).
- **Attente entre IA** : `./scripts/attendre-message.ps1` (voir [duo.md](docs/workflow/duo.md#attente)).
- **Autorisations des outils** : deux niveaux.
  - **Session normale** : permissions ordinaires de l'outil (Claude Code : `.claude/settings.json`). Tout commit,
    push ou PR demande un clic.
  - **Session autonome** (tâche validée ou chantier) : Claude Code :
    `claude --settings .claude/settings.autonome.json --add-dir "<Suivi local ou dossier de suivi>"`. Sans clic :
    modifier les fichiers, tests, build, vérificateur, scripts de suivi et d'attente, messages par `Add-Content`,
    `git add <fichier>`, `git commit -F`, push de sa branche, `gh pr create` et `gh pr checks`. `--add-dir` donne
    accès au suivi depuis un worktree. Ajouter à `settings.autonome.json` les commandes de test et de build du projet.
  - **Toujours demandé** (règle « demander », plus forte que toute autorisation) : push vers la branche principale,
    fusion, étiquette, `rebase`, `reset`, fusion de PR, publication.
  - **Toujours interdit** : `git add -A`/`.`/`--all`, `--no-verify` et `commit -n`, push forcé (`--force`, `-f`,
    `+ref`), `git -c`, changer `core.hooksPath`.
  - Ces règles comparent du texte et peuvent être contournées : les vraies protections restent les hooks
    (`pre-push` refuse la branche principale), la CI et la fusion décidée par le développeur.
  - **Codex** : `.codex/config.toml` (bac à sable `workspace-write`, sans réseau, `approval_policy = "on-request"`)
    et `.codex/rules/projet.rules` (règles par commande : la plus stricte l'emporte), adaptateur `adaptateurs/codex/`.
    Chargés seulement si le projet est marqué de confiance dans Codex. Lancement depuis le worktree :
    `codex -c 'sandbox_workspace_write.writable_roots=["<dossier de suivi>"]'`. Sans clic : modifier les fichiers
    du worktree, `git add <fichier>`, `git commit -F`, tests unitaires, vérificateur et script d'attente. Interdit :
    push, fusion, `rebase`, `reset`, étiquette, `git config`, `git -c`, `--no-verify`, `git add -A`/`.`/`--all`.
    Sans réseau, Codex ne pousse pas : **l'IA principale pousse sa branche, crée sa PR et lance pour lui les tests
    qui exigent réseau ou Docker**. Réglages écrits d'après la documentation de Codex, à vérifier au premier
    chantier (`codex execpolicy check --rules .codex/rules/projet.rules -- <commande>`).
- **Aides par tâche** ([chantier.md](docs/workflow/chantier.md#aides-par-tâche)) :
  - **Claude Code** : oui, outil Agent avec `isolation: "worktree"` et `run_in_background: true` ; l'aide hérite
    des autorisations de la session (lancer la session en mode autonome).
  - **Codex** : aides en lecture seule seulement (agent `explorer`). Ses sous-agents travaillent dans le même
    dossier que lui et héritent de son bac à sable, qui n'écrit pas dans un autre worktree.
  - Autre outil : non, sauf s'il sait lancer un sous-agent dans un worktree séparé.

### Projet

- **Commandes** : tests ciblés `<...>` ; suite complète `<...>` ; build `<...>` ; intégration `<...>` ; bout en bout `<...>`.
- **Couches et règle de dépendance** : `<domaine, cas d'utilisation, adaptateurs, présentation…>`.
- **Conventions d'erreur** : introuvable `<...>`, droits `<...>`, état `<...>`, entrée invalide `<...>`.
- **Zones sensibles** (tâche sensible d'office) : `<dossiers, fichiers>`.
- **Sections critiques en plus** pour les chantiers : `<routes, configuration, énumérations…>`.
- **Chemins** : liste des choses à faire `docs/projet/a-faire.md` (même valeur que `TodoFile` du vérificateur) ;
  audits `docs/projet/audits/` ; suivi des chantiers `docs/projet/chantiers/<nom>/`.
- **Suivi local** : `.suivi/` à la racine du checkout principal (`taches/` : une fiche par tâche ; `index.md` :
  généré par `./scripts/suivi.ps1`, qui crée aussi le dossier s'il manque), ignoré par git (`.gitignore`). Test du
  script : `./scripts/suivi.test.ps1`. Sur cette machine : `<chemin absolu du checkout principal>\.suivi\`.
  Depuis un worktree, l'atteindre par ce chemin absolu (`--add-dir` pour Claude Code, `writable_roots` pour
  Codex). Il n'existe que sur cette machine : une IA dans le cloud ou sur une autre machine ne le voit pas.

### Note propre à ce dépôt de modèles (à retirer après installation)

Documentation et scripts de garde-fous, sans application ni build. Pour une modification documentaire, vérifier
les liens, la cohérence et les scénarios de reprise. La configuration du vérificateur est un exemple
Java/TypeScript, pas la stack de ce dépôt.
