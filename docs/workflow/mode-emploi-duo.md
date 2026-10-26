# Mode d'emploi : faire travailler deux IA ensemble

Ce guide explique au développeur comment faire travailler deux IA, de n'importe quels outils, sur un même
chantier. Les règles que suivent les IA sont dans [duo.md](duo.md) et [chantier.md](chantier.md) ; ici, seulement
ce que **toi** tu as à faire.

## En bref

- L'IA à qui tu demandes de créer le chantier devient l'**IA principale** : ta seule interlocutrice.
- L'autre devient l'**IA secondaire** : elle travaille pour la principale et ne te parle jamais.
- Tu peux leur donner des surnoms dans `WORKFLOW.md` (réglage **Rôles d'un chantier**) ; dans ce dépôt :
  Patrick et Fanny.
- Les deux codent **en même temps**, chacune sur sa tâche, dans son propre worktree.
- Elles s'écrivent dans des fichiers texte et **s'attendent toutes seules** (script d'attente) ; tu ne les
  réveilles que si l'une s'est arrêtée.
- Rien n'est fusionné, poussé sur la branche principale ni étiqueté sans ta demande explicite.

## Quand utiliser un chantier

| Situation | Choix |
| --- | --- |
| Une seule tâche, petite | Une tâche seule : « Lis WORKFLOW.md puis suis docs/workflow/tache.md pour cette tâche : … » |
| Au moins 2 tâches indépendantes et longues à coder | Chantier : les deux IA codent en parallèle |
| Tâche sensible où tu veux une relecture par un autre modèle | Chantier : l'une code, l'autre relit |

## Avant de commencer

1. Le projet est installé et ses réglages remplis (voir [adapter.md](adapter.md)).
2. Les deux outils sont ouverts sur le **même dépôt, sur la même machine** : l'IA secondaire doit pouvoir lire et
   écrire le dossier de suivi de la principale.
3. Les hooks sont activés : `git config core.hooksPath .githooks`.
4. Chaque outil est lancé en **session autonome**, sinon il te demandera un clic à chaque commande (réglage
   **Autorisations des outils** de `WORKFLOW.md`). Pour Claude Code :

   ```text
   claude --settings .claude/settings.autonome.json --add-dir "<dossier de suivi>"
   ```

   Pour Codex (projet marqué de confiance dans Codex, pour qu'il lise `.codex/`) :

   ```text
   codex -c 'sandbox_workspace_write.writable_roots=["<dossier de suivi>"]'
   ```

   L'IA principale te donne le chemin du dossier de suivi et celui du worktree de l'IA secondaire ; lance
   l'IA secondaire depuis ce worktree. Codex n'a ni réseau ni Docker : l'IA principale pousse ses branches,
   crée ses PR et lance pour lui les tests d'intégration et de bout en bout.
5. Les IA qui savent lancer des aides dans un worktree séparé (Claude Code) peuvent confier à chacune une tâche
   entière : jusqu'à 5 tâches en même temps sur la machine (3 au premier chantier). Les aides ne te parlent pas.

## Démarrer

**1. Dans l'outil choisi comme principal :**

```text
Crée le chantier « invitations ». Tu es l'IA principale. Suis WORKFLOW.md et docs/workflow/chantier.md.
Objectif : <ce que tu veux obtenir>.
```

Elle crée le dossier de suivi, découpe le travail en tâches et te présente le plan : tâches, ordre, qui fait
quoi. **Valide ou corrige le plan.**

**2. L'IA principale écrit les attributions** et termine par `À réveiller : secondaire`.

**3. Dans l'autre outil :**

```text
Tu es l'IA secondaire. Rejoins le chantier dans <chemin absolu donné par l'IA principale>.
Lis WORKFLOW.md, docs/workflow/duo.md, chantier.md et de-principale.txt, puis traite les demandes autorisées.
```

Elle prépare ses fiches et termine par `Rapport enregistré dans le suivi. À réveiller : principale.`

## Pendant le chantier

Les deux sessions s'attendent l'une l'autre : quand l'une écrit, l'autre repart dans la minute. Toi, tu réponds
seulement à l'IA principale quand elle te présente une décision. Pour lui parler pendant qu'elle attend,
interromps-la (Échap dans Claude Code) : elle reprendra l'attente après t'avoir répondu.

## Si une session s'arrête

Une session s'arrête quand elle attend ta décision, après 2 heures sans message de l'autre, ou en cas d'erreur.
Elle finit alors son tour par une ligne :

```text
À réveiller : principale | secondaire | personne
```

Tu envoies alors, à la session indiquée :

```text
Reprends ton rôle dans <chemin absolu du dossier de suivi> : lis les nouveaux messages et poursuis le travail autorisé.
```

Si les deux sont à réveiller, réveille-les toutes les deux : elles travaillent en parallèle sans se gêner.
« personne » signifie que la décision t'attend, chez l'IA principale. Quand tout est fini, l'IA principale écrit
`FIN-CHANTIER` et les deux sessions s'arrêtent.

## Tes décisions (toujours auprès de l'IA principale)

| Arrêt | Ce qu'elle te présente | Ce que tu réponds |
| --- | --- | --- |
| Plan | Découpage, ordre, répartition | Valider ou corriger |
| Fiches | Toutes les fiches prêtes, en un message | Valider chaque fiche, ou demander des changements |
| Algorithmes (tâche sensible) | Algorithmes et tests rouges | Valider avant le code |
| Arrêt imprévu | Stack qui change, test suspect, blocage | Trancher |
| Fusion | PR, CI, audits, ordre de fusion, ce qu'il faut essayer | « Fusionne » quand tu es prêt |

Chaque décision est consignée (`V001`, `V002`…) dans `chantier.md` et transmise à l'IA secondaire. Une validation
ne vaut que pour ce qu'elle nomme : valider le plan ne valide pas les fiches.

## Ce qu'il y a dans le dossier de suivi

```text
docs/projet/chantiers/<nom>/
  chantier.md         vue d'ensemble : index des tâches, tes validations, réservations
  de-principale.txt   messages de l'IA principale
  de-secondaire.txt   messages de l'IA secondaire
  taches/T001.md      état détaillé d'une tâche : périmètre, preuves, prochaine action
```

Pour savoir où en est le chantier sans demander, ouvre `chantier.md`. Pour une tâche précise, ouvre sa fiche.
Tu n'as pas besoin de lire les messages ; ils servent aux IA.

## Reprendre plus tard

Les sessions n'ont pas besoin de l'historique du chat : tout est dans le dossier de suivi et dans Git. Ouvre une
nouvelle session dans chaque outil et précise le rôle :

```text
Tu es l'IA principale. Reprends ton rôle dans <chemin absolu du dossier de suivi> : lis les nouveaux messages et poursuis le travail autorisé.
```

Sur une autre machine : récupère la branche de documentation où le suivi a été sauvegardé et les branches des
tâches, puis demande à l'IA principale d'ajuster les chemins.

## En cas de problème

| Symptôme | Que faire |
| --- | --- |
| Une session ne finit pas par « À réveiller » | Demande-lui : « Qui faut-il réveiller ? » |
| L'IA secondaire te pose une question directement | Rappelle-lui : « Écris ta question à l'IA principale dans de-secondaire.txt. » |
| L'IA secondaire ne trouve pas le dossier de suivi | Donne-lui le chemin absolu inscrit dans `chantier.md` |
| Une IA semble bloquée ou tourne en rond | Arrête la session, puis dis à l'IA principale que l'ancienne est arrêtée ; elle pourra réattribuer la tâche |
| Tu veux changer qui fait quoi | Dis-le à l'IA principale ; elle réattribue après arrêt confirmé de l'ancienne session |
| Tu veux inverser les outils | Possible au chantier suivant : celui qui crée le chantier est l'IA principale |

## Ce qui ne change pas

Les règles d'une tâche restent les mêmes avec ou sans duo : fiche validée, tests écrits d'abord, algorithme,
casse volontaire, vérificateur, revue, CI, audit, fusion à ta demande. Les rôles et les outils restent dans le
dossier de suivi ; les commits et les PR suivent le réglage **Attribution**.
