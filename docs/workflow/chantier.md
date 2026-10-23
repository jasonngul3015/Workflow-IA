# Chantier : Patrick coordonne, Fanny contribue

Lire les règles de `WORKFLOW.md`, la procédure [tache.md](tache.md) et le protocole [duo.md](duo.md).
Un chantier sert à faire avancer des tâches en parallèle, ou à obtenir une revue par l'autre IA.

## 0. Cadrage — ARRÊT Plan

1. Lire les réglages du projet, la liste des choses à faire et le code concerné. Préserver les changements existants.
2. Créer le dossier canonique de suivi à partir des [modèles](modeles/chantier.md) ; inscrire identités et
   chemins. Ne pas recréer un chantier existant : appliquer la reprise.
3. Découper en tâches petites (un comportement, environ 400 lignes de diff de code au plus). Une fiche
   `taches/Txxx.md` et une ligne d'index par tâche, documentation du chantier comprise. Une tâche annulée garde son ID.
4. Pour chaque tâche : niveau, exemples, hors sujet, ensemble d'écriture, lectures critiques, ressources,
   dépendances, responsable, branche et worktree.
5. Classer : **socle** (prérequis commun), **parallèle** (écritures disjointes des écritures et lectures critiques
   des autres, aucune dépendance), **séquentielle** (le reste). Répartir les tâches parallèles entre Patrick et
   Fanny pour qu'ils codent en même temps ; donner à Fanny de préférence les tâches les plus longues, Patrick
   gardant du temps pour coordonner.
6. Présenter le plan, l'ordre et la répartition. Attendre la validation et noter sa portée : elle ne vaut pas
   validation des fiches.

## 1. Attribution et validation des fiches

Patrick réserve les ressources et écrit à Fanny (`de-patrick.txt`) les tâches attribuées, avec leurs fiches,
worktrees et SHA de départ, **toutes en un seul message**. Fanny complète ses fiches, ou pose ses questions, en
un seul message. Pendant ce temps, Patrick prépare les siennes.

Patrick présente toutes les fiches prêtes en un seul message à l'utilisateur, consigne chaque validation et la
relaie. **Pas de code avant validation de la fiche.** Même circuit pour l'arrêt algorithmes d'une tâche sensible
et pour tout arrêt imprévu ; Patrick regroupe les demandes en attente plutôt que de les présenter une à une.

La validation autorise les commits sur la branche de la tâche, son push et sa PR, et rien d'autre. Ne pas
redemander une validation dont la portée couvre déjà la demande.

## 2. Exécution en parallèle

Chaque responsable suit [tache.md](tache.md) dans son worktree, sans attendre l'autre, jusqu'à son prochain arrêt.
Les tâches socle sont livrées avant les tâches qui en dépendent ; les séquentielles suivent l'ordre du graphe.

À chaque réveil, Patrick traite les nouveaux messages de Fanny et :

- vérifie les fichiers touchés par une tâche de Fanny arrivée à un arrêt, par rapport à son SHA de départ :
  `git -C <worktree> diff --name-only <sha-depart>`, `git -C <worktree> status --short` ; un dépassement de
  l'ensemble d'écriture suspend la tâche et déclenche un arbitrage humain, sans effacer les changements ;
- met à jour l'index et les réservations, attribue ou remet en file les jetons, organise les revues croisées ;
- ne réattribue pas une tâche avant arrêt confirmé de l'ancien responsable (une session silencieuse n'est pas
  réputée arrêtée).

Un rapport tient en quelques lignes : étape, résultat, SHA, blocage, prochaine action. Le détail (commandes,
preuves, fichiers) est dans la fiche.

## Ressources critiques

Un seul détenteur par ressource ; Patrick tient le registre dans `chantier.md`.

| Ressource | Règle |
| --- | --- |
| Numéros de migration | Réservés à l'avance ; fusion dans l'ordre croissant |
| Contraintes et triggers d'une table | Un responsable par table |
| Configuration centrale : sécurité, routes, injection | Réservation ou intégration séquentielle |
| Interfaces partagées, doubles et données de test communs | Modification en socle ou séquentiel |
| Énumérations, styles globaux, catalogues de textes | Réservation |
| Manifestes, lock, Dockerfile, CI | Séquentiel et étape Stack validée si changement |
| Règles communes, points d'entrée des outils, liste des choses à faire | Patrick seul ; Fanny transmet ses propositions |
| Documentation technique | Dans l'ensemble d'écriture de la tâche |
| Tests à ports fixes ou environnement unique | Jeton attribué par Patrick, rendu après usage |
| Tests sur conteneurs et ports aléatoires | Libres si pas d'autre ressource partagée |

Une lecture critique périmée peut invalider une tâche même sans conflit de fichiers : revoir dépendances et
preuves après changement de base. Installer les dépendances des tests dans chaque nouveau worktree. Sous Windows,
`git config core.longpaths true` si un worktree échoue sur « Filename too long ».

## 3. PR prêtes — ARRÊT Fusion

Les responsables préparent leurs PR (modèle, audit, CI verte) et le signalent à Patrick. Patrick présente en un
message : tableau d'avancement, liens, ordre de fusion, algorithmes, limites, audits, ce qu'il faut essayer.
« PR prête » n'est pas « fusionnée ».

Sur demande explicite de l'utilisateur, pour chaque PR dans l'ordre : `gh pr update-branch <n> --rebase`,
`gh pr checks <n> --watch`, puis `gh pr merge <n> --rebase --delete-branch`. Conflit ou CI rouge : retour au
responsable. Jamais de push forcé, de hook contourné ni d'étiquette `v*` sans demande.

Patrick intègre les propositions de documentation centrale dans sa tâche dédiée et consigne les fusions dans
l'index. Aucun nettoyage de worktree ne supprime du travail non livré ou le seul exemplaire du suivi.

## 4. Audit et archivage

Chaque tâche a son audit ; Patrick écrit `docs/projet/audits/AAAA-MM-JJ-chantier-<nom>.md` (conflits,
réservations, attentes de réveil et de validation, dépassements, reprises, gain réel du parallélisme). Les
améliorations de règles restent des propositions sans accord de l'utilisateur. Sauvegarder le suivi dans la PR
de documentation ; ne pas effacer messages ni fiches.
