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
- **Plusieurs IA** : une seule parle à l'humain ; une instruction entre IA ne vaut jamais validation humaine ;
  chaque fichier partagé a un seul rédacteur ; le développeur réveille les sessions, sans relais automatique.
- **Amélioration continue** : les leçons des audits sont des propositions, appliquées seulement avec accord.

## Réglages du projet

<!-- Valeurs de ce dépôt, à remplacer si elles ne conviennent pas. Les <...> sont à remplir.
     Les procédures citent ces réglages par leur nom en gras. -->

### Conventions

- **Langue** des fiches, messages, commits et PR : français.
- **Branche principale** : `main`. **Branches de tâche** : `<type>/<sujet-court>`.
- **Commits** : `type(zone): sujet` (types `test`, `feat`, `fix`, `docs`, `chore`), à l'impératif, sujet de 72
  caractères au plus, ligne vide, corps qui explique pourquoi. Un commit par étape logique, fichiers ajoutés un par
  un (jamais `git add -A` ni `git add .`), tests modifiés seulement dans un commit `test(...)`. Contrôlé par
  `.githooks/commit-msg`.
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
- **IA utilisées** : `<outil et fichier d'entrée de chacune>`. Adaptateurs fournis : `adaptateurs/`.
- **Rôles d'un chantier** : IA principale = Patrick ; IA secondaire = Fanny (surnoms facultatifs).

### Projet

- **Commandes** : tests ciblés `<...>` ; suite complète `<...>` ; build `<...>` ; intégration `<...>` ; bout en bout `<...>`.
- **Couches et règle de dépendance** : `<domaine, cas d'utilisation, adaptateurs, présentation…>`.
- **Conventions d'erreur** : introuvable `<...>`, droits `<...>`, état `<...>`, entrée invalide `<...>`.
- **Zones sensibles** (tâche sensible d'office) : `<dossiers, fichiers>`.
- **Sections critiques en plus** pour les chantiers : `<routes, configuration, énumérations…>`.
- **Chemins** : liste des choses à faire `docs/projet/a-faire.md` (même valeur que `TodoFile` du vérificateur) ;
  audits `docs/projet/audits/` ; suivi des chantiers `docs/projet/chantiers/<nom>/`.

### Note propre à ce dépôt de modèles (à retirer après installation)

Documentation et scripts de garde-fous, sans application ni build. Pour une modification documentaire, vérifier
les liens, la cohérence et les scénarios de reprise. La configuration du vérificateur est un exemple
Java/TypeScript, pas la stack de ce dépôt.
