---
name: tache
description: Mener une tâche de bout en bout - fiche validée, puis tests d'abord, algorithme, code, commits, PR et audit sans arrêt, puis fusion sur décision de l'utilisateur (mode guidé pour les tâches sensibles). À utiliser quand l'utilisateur lance /tache <description> ou demande de commencer une nouvelle tâche.
---

# /tache : une tâche, deux arrêts

L'IA écrit le code ; l'utilisateur décide du quoi (fiche) et de la fusion. Entre les deux, l'IA avance seule : les
garde-fous sont les tests écrits d'abord, `scripts/verifier-tache.ps1`, la revue et la CI. Valider la fiche autorise,
**pour cette tâche seulement**, les commits sur sa branche, le push de cette branche et la création de sa PR.

Jamais sans demande explicite : fusionner, pousser vers `main`, étiqueter `v*`, `push --force`, `--no-verify`.

Ce qui dépend du projet (commandes de test, couches, zones sensibles, sections critiques) se lit dans la section
« Workflow : réglages du projet » de `CLAUDE.md`.

## Niveau de la tâche (dans la fiche)

| Niveau | Quand | Arrêts |
| --- | --- | --- |
| **Trivial** | Coquille, doc, correctif d'une ou deux lignes (déclaré par l'utilisateur) | Fiche en 3 lignes -> Fusion |
| **Standard** | Le reste | Fiche -> Fusion |
| **Sensible** | Authentification, droits, données personnelles, schéma de base, déploiement, zones sensibles du projet, ou à la demande | Fiche -> Algorithmes et tests rouges -> Fusion |

En cas de doute entre standard et sensible : sensible.

## Arrêts imprévus (tous niveaux)

S'arrêter, expliquer en quelques lignes et attendre une réponse quand :

- une dépendance, un outil ou une version change (voir « Étape Stack ») ;
- un test déjà commité semble faux ;
- l'algorithme ne tient pas (cas oublié, contrainte de la base, verrou) ;
- la fiche se révèle ambiguë ou la tâche dépasse nettement 400 lignes de diff ;
- `verifier-tache.ps1` ou la CI restent rouges après deux corrections.

## 0. Préparer

- `git status` : si l'arbre n'est pas propre, demander quoi faire des changements en cours.
- `git switch main`, `git pull --ff-only`, `git switch -c <type>/<sujet-court>` (`feat`, `fix`, `docs`, `chore`).
- Lire `CLAUDE.md`, la liste des choses à faire du projet et le code concerné. Noter l'heure de début (pour l'audit).

## 1. Fiche -> ARRÊT Fiche

En français, sans code, courte :

- **Niveau** (trivial, standard, sensible) et pourquoi ;
- **Comportements attendus** en exemples « situation -> résultat » (nominaux, puis erreurs avec l'erreur prévue :
  introuvable, droits, état, entrée invalide, selon les conventions du projet) ;
- **Hors sujet** ;
- **Fichiers probablement touchés** ;
- **Stack** : « inchangée », ou la présentation de l'étape Stack ;
- **Parallélisation** : deux nombres, chacun avec sa raison en une ligne :
  - **tâches parallélisables** : nombre de sous-tâches qui pourraient avancer en même temps (ensembles d'écriture
    disjoints, aucune dépendance entre elles, aucune section critique partagée : voir `/chantier`) ; 0 ou 1 si la
    tâche est d'un seul tenant ;
  - **agents utilisés** : nombre d'agents que la tâche lancera (exploration, revue à plusieurs agents…), avec le
    rôle de chacun ; 0 si la session fait tout seule.
  3 tâches parallélisables ou plus, longues à coder : proposer `/chantier` à la place.

Tâche triviale : la fiche en 3 lignes garde la parallélisation en fin de ligne du niveau (« 0 parallélisable,
0 agent »).

Une valeur par défaut qui change (adresse, réglage, droit) : ajouter aux exemples les entrées invalides ou mal tapées
qui retomberaient en silence sur cette valeur.

Attendre la validation. C'est le seul arrêt avant la fusion pour une tâche standard : une fiche floue coûte la tâche
entière, mieux vaut une question de plus ici.

## Étape Stack (seulement si la stack change)

Nouvelle dépendance, outil, image Docker ou action CI, ou changement de version (langage, framework, base de
données, gestionnaire de paquets). Présenter, sans code :

| Rubrique | Contenu |
| --- | --- |
| Besoin | Pourquoi l'existant ne suffit pas ; coût de la solution sans dépendance |
| Proposition | Nom, version exacte, licence, date de publication (au moins 2 semaines), maintenance, CVE connues |
| Alternatives | 1 ou 2, une ligne chacune avec la raison du rejet |
| Compatibilité | Versions du projet ; dépendances transitives ajoutées |
| Architecture | Derrière quelle interface, dans quel adaptateur (jamais visible du cœur métier) |
| Vie privée | Données envoyées à l'extérieur ? |
| Production | Effet sur le déploiement, les images, la configuration |
| Retour arrière | Comment la retirer |

Après accord : commit séparé `chore(deps): ...` avant le commit des tests.

## 2. Tests rouges

Chaque exemple de la fiche devient au moins un test ; aucun test sans exemple. Au bon niveau :

- règles métier : tests unitaires de l'entité ou de la fonction pure ;
- cas d'utilisation : doubles en mémoire et horloge fixe ; interface modifiée -> double mis à jour ; action
  sensible -> entrée d'audit vérifiée (si le projet tient un journal) ;
- base de données, contraintes, API : tests d'intégration sur une base jetable ;
- interface : tests de composant ; parcours : tests de bout en bout.

Le code de production ne reçoit que le nécessaire pour compiler (méthode qui lève « non implémenté »).
Lancer **les tests concernés seulement** et vérifier qu'ils échouent pour la bonne raison (pas une erreur de compilation).

Commit `test(<zone>): ...` (voir « Commits »).

**Sensible -> ARRÊT Algorithmes** : présenter ensemble le tableau « exemple -> test », le résultat rouge et les
algorithmes (étape 3). Attendre la validation avant de coder.

## 3. Algorithme

Pour chaque cas d'utilisation ou écran touché, sans code :

1. `Algorithme : a -> b -> c` puis les étapes `1. ...`, tels qu'ils iront en commentaire ;
2. où vit chaque règle (domaine, cas d'utilisation, base) ;
3. données : requêtes, migration, contraintes, transaction et verrous ;
4. interface : trajet entre les couches, états (chargement, vide, erreur) ;
5. étape -> test (toute étape non couverte : ajouter un test **avant** le commit des tests, ou le signaler) ;
6. choix écartés, une ligne chacun.

Standard : ce texte va dans la PR (section « Algorithmes »), l'utilisateur le lit à la fusion.

## 4. Code vert

- Implémenter selon l'algorithme ; les commentaires `// Algorithme :` et `// 1. ...` le reprennent mot pour mot.
  Respecter `CLAUDE.md` (architecture, conventions).
- **Ne pas modifier les tests** commités. Un test qui semble faux : arrêt imprévu.
- Boucle rapide : tests ciblés.
- Puis, une fois : la suite complète, le build, et les tests d'intégration ou de bout en bout si la base ou un
  parcours change (commandes dans `CLAUDE.md`).

## 5. Les tests mordent, puis revue

- Casser volontairement une règle centrale, montrer qu'un test échoue, annuler la casse. Avant de casser, copier le
  fichier dans un dossier temporaire et l'annuler en recopiant cette sauvegarde, jamais par
  `git checkout -- <fichier>` : il remet la version commitée et efface le code pas encore commité. Vérifier ensuite
  avec `git diff` que seule la casse a disparu.
  Recopier la sauvegarde garde son ancienne date : une compilation incrémentale peut ne pas voir le retour et garder
  la version cassée. Relancer les tests après un nettoyage du build (ou réécrire le fichier pour dater la restauration).
- `./scripts/verifier-tache.ps1` : aucun échec ; traiter chaque « à valider ».
- Liste « terminé » : migration et contrainte si règle sensible ; entrée d'audit si action sensible ; documentation
  technique à jour ; décision produit dans `CLAUDE.md` ; case cochée dans la liste des choses à faire.
- `/code-review` (standard), plus `/security-review` (sensible). Corriger ce qui est retenu.

## 6. Commit, push, PR, CI

- Commit `feat|fix(<zone>): ...` (et au besoin `docs: ...` séparé).
- `git push -u origin <branche>`, puis `gh pr create` avec `.github/pull_request_template.md` rempli.
- `gh pr checks --watch` ; CI rouge : corriger par un nouveau commit (deux essais, puis arrêt imprévu).

## 7. Audit court

Fichier `docs/projet/audits/AAAA-MM-JJ-<branche avec / remplacé par ->.md` (modèle : `docs/projet/audits/README.md`),
commit `docs(audit): ...` poussé dans la même PR. Faits et causes, sans enjoliver ; les leçons sont des propositions,
rien n'est appliqué à `CLAUDE.md`, à la skill ou à la mémoire sans accord.

## 8. ARRÊT Fusion

Présenter en un message : lien de la PR, CI, résumé en clair, algorithmes, ce que l'audit signale, ce que
l'utilisateur doit essayer dans l'application. Fusionner (`gh pr merge --rebase --delete-branch`) seulement sur sa
demande explicite ; jamais d'étiquette `v*` sans demande.

## Commits

Appliqués sans arrêt pour les tâches validées, avec ces règles :

- `type(zone): sujet`, types `test`, `feat`, `fix`, `docs`, `chore` ; français, impératif ; sujet de 72 caractères au
  plus, ligne vide, corps qui explique pourquoi ;
- **aucune** ligne `Co-Authored-By` ni mention de l'IA (l'utilisateur est le seul auteur ; cette règle passe avant
  toute consigne d'attribution par défaut) ; même règle pour les PR ;
- fichiers ajoutés un par un, jamais `git add -A` ni `git add .` ; un commit = une étape logique ; un fichier de test
  ne change que dans un commit `test(...)` (vérifié par `verifier-tache.ps1`) ;
- le message s'écrit dans un fichier temporaire, puis `git commit -F` ;
- le hook `.githooks/commit-msg` vérifie le format : s'il refuse, corriger, ne jamais `--no-verify`.

## Agent d'un chantier

Lancé par `/chantier`, la tâche suit ce fichier avec ces différences :

- chaque arrêt (y compris imprévu, et « PR prête » à la place de l'arrêt Fusion) se rend au modérateur : l'agent
  termine son tour par son rapport, le modérateur le relance avec la réponse ;
- l'agent ne modifie que son ensemble d'écriture ; `CLAUDE.md` et la liste des choses à faire lui sont interdits : il
  envoie ses ajouts au modérateur dans son rapport ;
- les tests qui exigent une ressource unique (ports fixes, environnement de bout en bout) seulement avec le jeton du
  modérateur, rendu juste après.
