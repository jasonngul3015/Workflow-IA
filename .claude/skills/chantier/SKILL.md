---
name: chantier
description: Mener un chantier volumineux - découpage en tâches, phase socle, phase parallèle (jusqu'à 5 agents en worktree, chacun suivant /tache) coordonnée par un modérateur qui tient les verrous des sections critiques, puis phase séquentielle et audit du chantier. À utiliser quand l'utilisateur lance /chantier <description> ou demande de paralléliser un gros travail.
---

# /chantier : plusieurs tâches, un modérateur

La session principale est le **modérateur** : seule à parler à l'utilisateur, elle découpe, attribue, tient les
verrous, vérifie et propose les fusions. Elle n'écrit pas le code des tâches. Les **agents** font chacun une tâche
selon `/tache` (section « Agent d'un chantier »), dans leur propre worktree.

Utile seulement si le chantier compte au moins 3 tâches indépendantes et longues à coder ; sinon enchaîner `/tache`.
Le temps de validation de l'utilisateur reste en série : le gain vient des tâches, pas du nombre d'agents.

## Phase 0 : cadrage -> ARRÊT Plan

1. Lire `CLAUDE.md`, la liste des choses à faire et le code concerné.
2. Découper en tâches de `/tache` (un comportement, environ 400 lignes au plus).
3. Pour chaque tâche : fiche courte, niveau, **ensemble d'écriture** (fichiers et dossiers modifiés), **lectures
   critiques** (fichiers dont le contenu conditionne la tâche), ressources réservées (tableau ci-dessous).
4. Classer :
   - **socle** : prérequis commun des autres tâches (migration, interface partagée, énumération) ; souvent vide ;
   - **parallèle** : ensemble d'écriture disjoint de ceux des autres tâches parallèles **et** de leurs lectures
     critiques, aucune dépendance entre elles ;
   - **séquentielle** : tout le reste, dans l'ordre du graphe de dépendances.
5. Écrire le plan dans `docs/projet/chantiers/<nom>.md` (modèle en fin de fichier), le présenter avec le graphe.

Attendre la validation. Le plan peut revenir à l'utilisateur si une tâche change de phase en cours de route.

## Sections critiques

Une ressource critique a un seul détenteur à la fois, attribué dans le plan (registre des verrous). Liste de départ,
à compléter par celle de `CLAUDE.md` (section « Workflow : réglages du projet ») :

| Ressource | Règle |
| --- | --- |
| Numéros de migration | Attribués d'avance par le modérateur ; fusion dans l'ordre croissant |
| Contraintes et triggers d'une table | Un seul agent par table |
| Configuration centrale (sécurité, routes, injection de dépendances) | Verrou ; ou l'agent décrit sa ligne et le modérateur l'intègre |
| Interfaces partagées, leurs doubles de test, données de test communes | Interface modifiée = socle ou séquentiel |
| Énumérations partagées | Verrou |
| Manifestes de dépendances, lock, Dockerfile, CI | Interdit en parallèle (étape Stack) : séquentiel |
| Styles globaux, catalogues de textes | Verrou |
| `CLAUDE.md`, liste des choses à faire | Modérateur seul : les agents lui envoient leurs ajouts |
| Documentation technique | Seulement si le fichier est dans l'ensemble d'écriture de l'agent |
| Tests à ports fixes (bout en bout) | Jeton : un seul à la fois sur la machine |
| Tests sur conteneur et port aléatoires | Libres |

Lire en même temps n'est pas un risque (chaque worktree a sa copie) ; lire une version **périmée** d'un fichier
qu'un autre agent modifie en est un : d'où les lectures critiques du plan.

## Phase socle (si elle existe)

Une tâche à la fois, chacune par un agent frais (phase séquentielle ci-dessous). Fusionnée avant la phase parallèle.

## Phase parallèle

1. **Lancer** au plus 5 agents (3 au premier chantier), un par tâche : outil Agent, `isolation: "worktree"`,
   `run_in_background: true`, avec le gabarit d'instructions ci-dessous.
2. **Barrière Fiche** : attendre que chaque agent ait rendu sa fiche, puis les présenter **en un seul message**
   (une section par tâche, avec le tableau d'avancement). L'utilisateur valide tâche par tâche ; transmettre chaque
   réponse à son agent (`SendMessage`), qui avance alors seul jusqu'à son prochain arrêt.
3. **À chaque retour d'agent** (fin de tour = arrêt) :
   - `git -C <worktree> diff --name-only origin/main` et fichiers non suivis comparés à son ensemble d'écriture :
     tout dépassement arrête l'agent, l'utilisateur est prévenu, la tâche est réattribuée ou repoussée ;
   - arrêt imprévu ou algorithmes (tâches sensibles) : regrouper avec les autres retours proches, présenter en un message ;
   - demande de jeton : l'accorder si libre, sinon mettre en file ; l'agent le rend dès qu'il a fini.
4. **Barrière Fusion** : quand les PR sont prêtes (CI verte, audits écrits), présenter en un message les PR, l'ordre
   de fusion proposé (migrations croissantes d'abord) et les ajouts de documentation reçus. Sur demande de
   l'utilisateur seulement, pour chaque PR dans l'ordre : `gh pr update-branch <n> --rebase`, attendre la CI verte
   (`gh pr checks <n> --watch`), puis `gh pr merge <n> --rebase --delete-branch`. Conflit ou CI rouge après mise à
   jour : renvoyer la tâche à son agent.
5. **Documentation centrale** : une PR `docs` du modérateur avec les ajouts à `CLAUDE.md` et à la liste des choses
   à faire (commits proposés à l'utilisateur, même règle de fusion).

## Phase séquentielle

Une tâche à la fois, dans l'ordre du graphe, chacune par **un** agent frais parti de `main` à jour (pour garder le
contexte du modérateur léger), même protocole que la phase parallèle avec un seul agent.

## Audit du chantier

`docs/projet/audits/AAAA-MM-JJ-chantier-<nom>.md` (modèle : `docs/projet/audits/README.md`) : agrégat des audits des
tâches et section **Coordination** (conflits, attentes sur verrous et jetons, dépassements, rebases, gain réel par
rapport à des tâches enchaînées). Poussé dans la PR `docs` du modérateur avec le plan, puis nettoyage des worktrees
(`git worktree list`, `git worktree prune`).

## Règles du modérateur

- Jamais de code de tâche, jamais de fusion ni d'étiquette sans demande explicite de l'utilisateur.
- Chaque message à l'utilisateur commence par le tableau d'avancement : tâche, agent, étape, verrous tenus, attente.
- Un agent qui ne répond plus ou boucle : l'arrêter (`TaskStop`), garder sa branche, prévenir l'utilisateur.
- Windows, chemins longs : `git config core.longpaths true` si un worktree échoue sur « Filename too long ».
- Un worktree neuf n'a pas les dépendances installées : les installer avant ses tests.

## Gabarit d'instructions d'un agent

```
Tu es l'agent <id> du chantier <nom>. Suis .claude/skills/tache/SKILL.md, section « Agent d'un chantier ».
Tâche : <fiche courte>. Niveau : <niveau>. Branche : <type>/<sujet>, partie de origin/main.
Ensemble d'écriture (rien d'autre) : <liste>. Ressources attribuées : <migrations, verrous>.
Interdits : CLAUDE.md, la liste des choses à faire, toute ressource non attribuée, tests à jeton sans jeton.
À chaque arrêt (fiche, algorithmes si sensible, imprévu, PR prête), termine ton tour par un rapport :
ÉTAPE, CE QUI EST FAIT, QUESTION OU DEMANDE (jeton, verrou), FICHIERS MODIFIÉS, AJOUTS DOC PROPOSÉS.
Après validation de ta fiche : commits, push de ta branche et PR autorisés ; jamais de fusion.
```

## Modèle de plan (`docs/projet/chantiers/<nom>.md`)

```markdown
# Chantier : <nom>

But : <une phrase>. Hors sujet : <...>.
Parallélisation : <n> tâches parallélisables (phase parallèle) ; <m> agents (un par tâche, socle et séquentielles
comprises, au plus 5 en même temps).

| Tâche | Fiche courte | Niveau | Phase | Dépend de | Ensemble d'écriture | Lectures critiques | Ressources |
| --- | --- | --- | --- | --- | --- | --- | --- |

## Registre des verrous

| Ressource | Détenteur | Depuis | File d'attente |
| --- | --- | --- | --- |
```
