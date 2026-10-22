# Section à recopier dans `CLAUDE.md`

Les skills lisent ces deux sections dans le `CLAUDE.md` du projet. La première est commune ; la seconde se remplit
pour chaque projet.

---

## Workflow (développeur seul, code écrit par l'IA, validé par l'utilisateur)

Procédure complète dans la commande `/tache` (`.claude/skills/tache/SKILL.md`) ; chantiers volumineux (plusieurs
agents en parallèle, coordonnés par un modérateur qui tient les verrous des sections critiques) dans `/chantier`
(`.claude/skills/chantier/SKILL.md`) ; modèle de PR dans `.github/pull_request_template.md`.

- `main` est toujours déployable : jamais de commit direct, une branche courte par tâche (`feat/…`, `fix/…`, `docs/…`,
  `chore/…`) et une PR dont la CI doit être verte. Pas de relecture humaine exigée.
  Le hook `.githooks/pre-push` refuse tout envoi direct vers `main` (utile quand la protection de branche GitHub
  n'est pas disponible, par exemple sur un dépôt privé sans GitHub Pro).
- Tâches petites : un comportement, environ 400 lignes de diff au plus ; une session par tâche.
- **Cycle à deux arrêts** : **fiche validée** (niveau, exemples « situation -> résultat », hors sujet, stack,
  parallélisation) -> sans arrêt : tests écrits d'abord, rouges pour la bonne raison, commit `test(...)` ;
  algorithme (`Algorithme : a -> b -> c` et étapes) ; code qui le suit mot pour mot dans ses commentaires, **sans
  modifier les tests** ; casse volontaire ; `scripts/verifier-tache.ps1` ; `/code-review` ; commit, push, PR, CI verte ;
  audit court (`docs/projet/audits/`) -> **fusion décidée par l'utilisateur**.
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
  Hors `/tache` (travail non cadré par une fiche), chaque commit et chaque push restent soumis à l'accord de l'utilisateur.
- Fusion par *rebase* (`gh pr merge --rebase --delete-branch`) pour garder le commit de tests avant celui du code ;
  fusionner seulement à la demande de l'utilisateur. Livraison : étiquette `vX.Y.Z` sur `main`.

## Workflow : réglages du projet

<!-- À remplir. Les skills /tache et /chantier s'y réfèrent. -->

- **Commandes** : tests ciblés `<...>` ; suite complète `<...>` ; build `<...>` ; tests d'intégration `<...>` ;
  tests de bout en bout `<...>`.
- **Couches et règle de dépendance** : `<domaine, cas d'utilisation, adaptateurs, présentation…>`.
- **Conventions d'erreur** : introuvable `<...>`, droits `<...>`, état `<...>`, entrée invalide `<...>`.
- **Zones sensibles** (tâche sensible d'office) : `<dossiers, fichiers>`.
- **Sections critiques en plus** pour `/chantier` : `<fichiers partagés : routes, configuration, énumérations…>`.
- **Liste des choses à faire** : `docs/projet/a-faire.md` (ou autre chemin, le même que `TodoFile` dans la
  configuration du script).
