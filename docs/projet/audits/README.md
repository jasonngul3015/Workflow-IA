# Audits de fin de tâche

Un fichier par tâche, écrit à la fin de `/tache` (étape 7) et poussé dans la même PR :
`AAAA-MM-JJ-<branche>.md`, la barre oblique de la branche remplacée par un tiret
(`feat/invitations` → `2026-10-20-feat-invitations.md`). Un chantier (`/chantier`) ajoute
`AAAA-MM-JJ-chantier-<nom>.md`, qui agrège les audits de ses tâches et juge la coordination.

But : voir, tâche après tâche, où le temps se perd et ce qui revient, pour améliorer `CLAUDE.md`,
les skills et les scripts. Court : une ligne par point, pas de prose. Faits et causes, sans enjoliver.

## Modèle

```markdown
# Audit : <branche>

- Niveau : standard | sensible | trivial ; PR #<n>
- Parallélisation : prévu <n> tâches parallélisables, <m> agents ; réel <n'>, <m'> (écart et pourquoi)
- Durées : fiche <x min> ; tests <x> ; code <x> ; revue <x> ; CI <x> (attentes de validation comprises)

## Prévu / livré
- <exemple de la fiche> → <test> → livré | retiré | ajouté en route (pourquoi)

## Écarts à l'algorithme
- Aucun | <écart et raison>

## Difficultés
- <fait> — cause : <cause> — temps perdu : <x min>

## Dette créée
- Aucune | <raccourci, cas non couvert> → ajouté à la liste des choses à faire

## Leçons proposées (non appliquées sans accord)
- <modification de CLAUDE.md, d'une skill, d'un script ou de la mémoire>
```

Pour un chantier, ajouter une section **Coordination** : conflits de fusion, attentes sur les verrous et les
jetons, dépassements d'ensemble d'écriture, rebases, et gain réel par rapport à des tâches enchaînées.
