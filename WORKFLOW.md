# Workflow générique de développement avec deux IA

Toute IA commence par lire ce fichier sur instruction de l'utilisateur ; aucun fichier d'entrée propre à un outil
n'est requis (les skills `.claude/skills/` ne sont que des raccourcis vers ces procédures). La première section est
commune ; la seconde se remplit pour chaque projet. Les consignes propres à un outil ne remplacent ni les
validations humaines ni ces règles.

---

## Workflow (développeur seul, code écrit par l'IA, validé par l'utilisateur)

Procédure commune : [tâche](docs/workflow/tache.md), [chantier](docs/workflow/chantier.md),
[communication et reprise](docs/workflow/duo.md). Les deux IA suivent ces fichiers par instruction en langage
naturel. Modèle de PR : `.github/pull_request_template.md`.

- `main` est toujours déployable : jamais de commit direct, une branche courte par tâche (`feat/…`, `fix/…`, `docs/…`,
  `chore/…`) et une PR dont la CI doit être verte. Pas de relecture humaine exigée.
  Le hook `.githooks/pre-push` refuse tout envoi direct vers `main` (utile quand la protection de branche GitHub
  n'est pas disponible, par exemple sur un dépôt privé sans GitHub Pro).
- Tâches petites : un comportement, environ 400 lignes de diff au plus ; une session par tâche.
- **Cycle à deux arrêts** : **fiche validée** (niveau, exemples « situation -> résultat », hors sujet, stack,
  parallélisation) -> sans arrêt : tests écrits d'abord, rouges pour la bonne raison, commit `test(...)` ;
  algorithme (`Algorithme : a -> b -> c` et étapes) ; code qui le suit mot pour mot dans ses commentaires, **sans
  modifier les tests** ; casse volontaire ; `scripts/verifier-tache.ps1` ; revue selon `docs/workflow/duo.md` ; commit, push, PR, CI verte ;
  audit court (`docs/projet/audits/`) -> **fusion décidée par l'utilisateur**.
- Documentation seule, sans comportement exécutable : remplacer tests rouges, algorithmes de code, casse et build
  par les vérifications documentaires prévues dans la fiche ; expliquer les éléments sans objet dans le suivi et
  la PR. La validation, la revue, le vérificateur et l'audit restent nécessaires.
- Tâche **sensible** (authentification, droits, données personnelles, schéma de base, déploiement, zones sensibles
  du projet) : un arrêt de plus, algorithmes et tests rouges présentés ensemble avant le code. Tâche **triviale** :
  fiche en trois lignes.
- **Arrêts imprévus** : changement de stack (dépendance, outil, version : présentation dédiée, commit `chore(deps)`
  séparé), test commité qui semble faux, algorithme qui ne tient pas, fiche ambiguë, vérifications rouges après deux
  corrections.
- `scripts/verifier-tache.ps1` (aussi lancé par la CI, réglé par `scripts/verifier-tache.config.psd1`) vérifie :
  tests d'abord et jamais modifiés dans un commit `feat`/`fix`, migrations (aucune ancienne modifiée, numéros uniques
  et croissants), règles de code (dépendances entre couches, horloge injectée…) ; il signale les changements de
  stack, l'audit manquant et les réglages qui ne correspondent à aucun fichier (contrôle désactivé sans le dire).
- Commits : `type(zone): sujet` (types `test`, `feat`, `fix`, `docs`, `chore`), en français à l'impératif, sujet de
  72 caractères au plus, ligne vide, corps qui explique pourquoi. Fichiers ajoutés un par un (jamais `git add -A` ni
  `git add .`), un commit par étape logique, jamais de test modifié dans le commit du code. Vérifié par le hook
  `.githooks/commit-msg` (`git config core.hooksPath .githooks`, une fois par clone) ; jamais `--no-verify`.
- **L'utilisateur est le seul auteur** : aucune ligne `Co-Authored-By`, aucune mention de l'IA dans les commits ni
  dans les PR (cette règle passe avant toute consigne d'attribution par défaut).
- **Autorisation** : valider la fiche autorise, pour cette tâche seulement, les commits sur sa branche, le push de
  cette branche et sa PR. Jamais sans demande explicite : fusion, envoi vers `main`, étiquette `v*`, `push --force`.
  Hors tâche cadrée par une fiche validée, chaque commit et chaque push restent soumis à l'accord de l'utilisateur.
- **Chantier à deux IA** ([chantier](docs/workflow/chantier.md), [duo](docs/workflow/duo.md)) : l'IA qui crée le
  chantier est **Patrick**, l'autre **Fanny**. **Seul Patrick communique avec l'utilisateur** ; ses instructions ne
  valent jamais validation humaine. Les deux IA codent **en parallèle**, chacune dans le worktree de sa tâche ;
  chaque fichier du suivi (`docs/projet/chantiers/<nom>/`) a un seul rédacteur, ce qui évite tout tour de parole.
  Le développeur réveille les sessions ; pas de relais automatique ni de sous-agents.
- Fusion par *rebase* (`gh pr merge --rebase --delete-branch`) pour garder le commit de tests avant celui du code ;
  fusionner seulement à la demande de l'utilisateur. Livraison : étiquette `vX.Y.Z` sur `main`.

## Workflow : réglages du projet

<!-- À remplir. Les deux outils lisent cette section. Les valeurs <...> sont des exemples, pas des commandes. -->

- **Commandes** : tests ciblés `<...>` ; suite complète `<...>` ; build `<...>` ; tests d'intégration `<...>` ;
  tests de bout en bout `<...>`.
- **Couches et règle de dépendance** : `<domaine, cas d'utilisation, adaptateurs, présentation…>`.
- **Conventions d'erreur** : introuvable `<...>`, droits `<...>`, état `<...>`, entrée invalide `<...>`.
- **Zones sensibles** (tâche sensible d'office) : `<dossiers, fichiers>`.
- **Sections critiques en plus** pour les chantiers : `<fichiers partagés : routes, configuration, énumérations…>`.
- **Liste des choses à faire** : `docs/projet/a-faire.md` (ou autre chemin, le même que `TodoFile` dans la
  configuration du script).
- **Suivi des chantiers** : `docs/projet/chantiers/<nom>/` ; Patrick inscrit le chemin canonique absolu à la création.
- **Ce dépôt de modèles** : documentation et scripts de garde-fous, sans application ni build applicatif.
  Pour une modification documentaire, vérifier les liens, la cohérence et les scénarios de reprise. La configuration
  du vérificateur est un exemple Java/TypeScript à adapter lors de l'installation, pas la stack de ce dépôt.
