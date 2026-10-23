# Mode d'emploi : travailler avec Patrick et Fanny

Ce guide explique au développeur comment faire travailler deux IA (par exemple Claude Code et Codex) sur un même
chantier. Les règles détaillées que suivent les IA sont dans [duo.md](duo.md) et [chantier.md](chantier.md) ;
ici, seulement ce que **toi** tu as à faire.

## En bref

- L'IA à qui tu demandes de créer le chantier devient **Patrick** : c'est ta seule interlocutrice.
- L'autre IA devient **Fanny** : elle travaille pour Patrick et ne te parle jamais.
- Les deux codent **en même temps**, chacune sur sa tâche, dans son propre worktree.
- Elles s'écrivent dans des fichiers texte ; **tu les réveilles** quand l'une a écrit à l'autre.
- Rien n'est fusionné, poussé sur `main` ni étiqueté sans ta demande explicite.

## Quand utiliser un chantier

| Situation | Choix |
| --- | --- |
| Une seule tâche, petite | Une tâche seule : « Lis WORKFLOW.md puis suis docs/workflow/tache.md pour cette tâche : … » |
| Au moins 2 tâches indépendantes et longues à coder | Chantier : les deux IA codent en parallèle |
| Tâche sensible où tu veux une relecture par un autre modèle | Chantier : l'une code, l'autre relit |

## Avant de commencer

1. Le projet contient `WORKFLOW.md` et `docs/workflow/` (voir « Installer dans un projet » du [README](../../README.md)).
2. Les deux outils sont ouverts sur le **même dépôt, sur la même machine** : Fanny doit pouvoir lire et écrire
   le dossier de suivi de Patrick.
3. Les hooks sont activés : `git config core.hooksPath .githooks`.

## Démarrer

**1. Dans l'outil choisi comme principal :**

```text
Crée le chantier « invitations ». Tu es Patrick. Suis WORKFLOW.md et docs/workflow/chantier.md.
Objectif : <ce que tu veux obtenir>.
```

Patrick crée `docs/projet/chantiers/invitations/`, découpe le travail en tâches et te présente le plan :
tâches, ordre, qui fait quoi. **Valide ou corrige le plan.**

**2. Patrick écrit les attributions à Fanny** et termine par `À réveiller : Fanny`.

**3. Dans l'autre outil :**

```text
Tu es Fanny. Rejoins le chantier dans <chemin absolu donné par Patrick>.
Lis WORKFLOW.md, docs/workflow/duo.md, chantier.md et de-patrick.txt, puis traite les demandes autorisées.
```

Fanny prépare ses fiches et termine par `Rapport enregistré dans le suivi. À réveiller : Patrick.`

## Le geste à répéter

Chaque session finit son tour par une ligne :

```text
À réveiller : Patrick | Fanny | personne
```

Tu envoies alors, à la session indiquée :

```text
Reprends ton rôle dans <chemin absolu du dossier de suivi> : lis les nouveaux messages et poursuis le travail autorisé.
```

Si les deux sont à réveiller, réveille-les toutes les deux : elles travaillent en parallèle sans se gêner.
« personne » signifie que la décision t'attend, chez Patrick.

## Tes décisions (toujours chez Patrick)

| Arrêt | Ce que Patrick te présente | Ce que tu réponds |
| --- | --- | --- |
| Plan | Découpage, ordre, répartition | Valider ou corriger |
| Fiches | Toutes les fiches prêtes, en un message | Valider chaque fiche, ou demander des changements |
| Algorithmes (tâche sensible) | Algorithmes et tests rouges | Valider avant le code |
| Arrêt imprévu | Stack qui change, test suspect, blocage | Trancher |
| Fusion | PR, CI, audits, ordre de fusion, ce qu'il faut essayer | « Fusionne » quand tu es prêt |

Patrick consigne chaque décision (`V001`, `V002`…) dans `chantier.md` et la transmet à Fanny. Une validation ne
vaut que pour ce qu'elle nomme : valider le plan ne valide pas les fiches.

## Ce qu'il y a dans le dossier de suivi

```text
docs/projet/chantiers/<nom>/
  chantier.md      vue d'ensemble : index des tâches, tes validations, réservations
  de-patrick.txt   messages de Patrick à Fanny
  de-fanny.txt     messages de Fanny à Patrick
  taches/T001.md   état détaillé d'une tâche : périmètre, preuves, prochaine action
```

Pour savoir où en est le chantier sans demander, ouvre `chantier.md`. Pour une tâche précise, ouvre sa fiche.
Tu n'as pas besoin de lire les messages ; ils servent aux IA.

## Reprendre plus tard

Les sessions n'ont pas besoin de l'historique du chat : tout est dans le dossier de suivi et dans Git. Ouvre une
nouvelle session dans chaque outil et envoie le message de réveil en précisant le rôle :

```text
Tu es Patrick. Reprends ton rôle dans <chemin absolu du dossier de suivi> : lis les nouveaux messages et poursuis le travail autorisé.
```

Sur une autre machine : récupère la branche de documentation où Patrick a sauvegardé le suivi, ainsi que les
branches des tâches, puis demande à Patrick d'ajuster les chemins.

## En cas de problème

| Symptôme | Que faire |
| --- | --- |
| Une session ne finit pas par « À réveiller » | Demande-lui : « Qui faut-il réveiller ? » |
| Fanny te pose une question directement | Rappelle-lui : « Écris ta question à Patrick dans de-fanny.txt. » |
| Fanny ne trouve pas le dossier de suivi | Donne-lui le chemin absolu écrit dans `chantier.md` par Patrick |
| Une IA semble bloquée ou tourne en rond | Arrête la session, puis dis à Patrick que l'ancienne est arrêtée ; il pourra réattribuer la tâche |
| Tu veux changer qui fait quoi | Dis-le à Patrick ; il réattribue après arrêt confirmé de l'ancienne session |
| Tu veux inverser les rôles des outils | Possible au chantier suivant : celui qui crée le chantier est Patrick |

## Ce qui ne change pas

Les règles d'une tâche restent les mêmes avec ou sans duo : fiche validée, tests écrits d'abord, algorithme,
casse volontaire, `verifier-tache.ps1`, revue, CI, audit, fusion à ta demande. Les commits et les PR ne mentionnent
pas les IA ; leurs noms restent dans le dossier de suivi.
