# Chantier : l'IA principale coordonne, l'IA secondaire contribue

Lire les principes et réglages de `WORKFLOW.md`, la procédure [tache.md](tache.md) et le protocole [duo.md](duo.md).
Un chantier sert à faire avancer des tâches en parallèle, ou à obtenir une revue par l'autre IA.

## 0. Cadrage — ARRÊT Plan

1. Lire les réglages, la liste des choses à faire et le code concerné. Préserver les changements existants.
2. Créer le dossier de suivi à partir des [modèles](modeles/chantier.md) ; inscrire rôles, outils et chemins.
   Ne pas recréer un chantier existant : appliquer la reprise.
3. Découper en tâches selon **Taille d'une tâche**. Une fiche `taches/Txxx.md` et une ligne d'index par tâche,
   documentation du chantier comprise. Une tâche annulée garde son ID.
4. Pour chaque tâche : niveau, exemples, hors sujet, ensemble d'écriture, lectures critiques, ressources,
   dépendances, responsable, branche et worktree.
5. Classer : **socle** (prérequis commun), **parallèle** (écritures disjointes des écritures et lectures critiques
   des autres, aucune dépendance), **séquentielle** (le reste). Répartir les tâches parallèles entre les deux IA
   pour qu'elles codent en même temps ; confier de préférence les plus longues à l'IA secondaire, l'IA principale
   gardant du temps pour coordonner.
6. Présenter le plan, l'ordre et la répartition. Attendre la validation et noter sa portée : elle ne vaut pas
   validation des fiches.

## 1. Attribution et validation des fiches

L'IA principale réserve les ressources et écrit à l'IA secondaire (`de-principale.txt`) ses tâches, avec fiches,
worktrees et SHA de départ, **en un seul message**. L'IA secondaire complète ses fiches, ou pose ses questions, en
un seul message. Pendant ce temps, l'IA principale prépare les siennes.

L'IA principale présente toutes les fiches prêtes en un seul message au développeur, consigne chaque validation
et la relaie. **Pas de code avant validation de la fiche.** Même circuit pour l'arrêt algorithmes d'une tâche
sensible et pour tout arrêt imprévu ; regrouper les demandes en attente plutôt que de les présenter une à une.

La validation autorise les commits sur la branche de la tâche, son push et sa PR, et rien d'autre. Ne pas
redemander une validation dont la portée couvre déjà la demande.

## 2. Exécution en parallèle

Chaque responsable suit [tache.md](tache.md) dans son worktree, sans attendre l'autre, jusqu'à son prochain arrêt.
Les tâches socle sont livrées avant celles qui en dépendent ; les séquentielles suivent l'ordre du graphe.

À chaque réveil, l'IA principale traite les nouveaux messages de l'IA secondaire et :

- vérifie les fichiers touchés par une tâche arrivée à un arrêt, par rapport à son SHA de départ :
  `git -C <worktree> diff --name-only <sha-depart>`, `git -C <worktree> status --short` ; un dépassement de
  l'ensemble d'écriture suspend la tâche et déclenche un arbitrage humain, sans effacer les changements ;
- met à jour l'index et les réservations, attribue ou remet en file les jetons, organise les revues croisées ;
- ne réattribue pas une tâche avant arrêt confirmé de l'ancien responsable (une session silencieuse n'est pas
  réputée arrêtée).

Un rapport tient en quelques lignes : étape, résultat, SHA, blocage, prochaine action. Le détail (commandes,
preuves, fichiers) est dans la fiche.

## Ressources critiques

Un seul détenteur par ressource ; l'IA principale tient le registre dans `chantier.md`. Compléter cette liste
avec **Sections critiques en plus**.

| Ressource | Règle |
| --- | --- |
| Numéros de migration | Réservés à l'avance ; fusion dans l'ordre croissant |
| Contraintes et triggers d'une table | Un responsable par table |
| Configuration centrale : sécurité, routes, injection | Réservation ou intégration séquentielle |
| Interfaces partagées, doubles et données de test communs | Modification en socle ou séquentiel |
| Énumérations, styles globaux, catalogues de textes | Réservation |
| Manifestes, verrous de dépendances, images, CI | Séquentiel et étape Stack validée si changement |
| Règles communes, points d'entrée des outils, liste des choses à faire | IA principale seule ; l'IA secondaire propose |
| Documentation technique | Dans l'ensemble d'écriture de la tâche |
| Tests à ports fixes ou environnement unique | Jeton attribué par l'IA principale, rendu après usage |
| Tests sur conteneurs et ports aléatoires | Libres si pas d'autre ressource partagée |

Une lecture critique périmée peut invalider une tâche même sans conflit de fichiers : revoir dépendances et
preuves après changement de base. Installer les dépendances des tests dans chaque nouveau worktree. Sous Windows,
`git config core.longpaths true` si un worktree échoue sur « Filename too long ».

## 3. PR prêtes — ARRÊT Fusion

Les responsables préparent leurs PR (modèle, audit, CI verte) et le signalent à l'IA principale. Celle-ci
présente en un message : tableau d'avancement, liens, ordre de fusion, algorithmes, limites, audits, ce qu'il faut
essayer. « PR prête » n'est pas « fusionnée ».

Sur demande explicite du développeur, pour chaque PR dans l'ordre : mettre la branche à jour, attendre la CI,
fusionner (**Forge**, **Fusion**). Conflit ou CI rouge : retour au responsable. Jamais de push forcé, de hook
contourné ni d'étiquette de version sans demande.

L'IA principale intègre les propositions de documentation centrale dans sa tâche dédiée et consigne les fusions
dans l'index. Aucun nettoyage de worktree ne supprime du travail non livré ou le seul exemplaire du suivi.

## 4. Audit et archivage

Chaque tâche a son audit ; l'IA principale écrit l'audit du chantier `<audits>/AAAA-MM-JJ-chantier-<nom>.md`
([modèle](modeles/audit.md), section Coordination). Les améliorations de règles restent des propositions sans
accord du développeur. Sauvegarder le suivi dans la branche de documentation ; ne pas effacer messages ni fiches.
