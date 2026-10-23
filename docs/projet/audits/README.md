# Audits de fin de tâche

Un fichier par tâche, écrit à la fin de la procédure de tâche (étape 7) et poussé dans la même PR :
`AAAA-MM-JJ-<branche>.md`, la barre oblique de la branche remplacée par un tiret
(`feat/invitations` → `2026-10-20-feat-invitations.md`). Un chantier ajoute
`AAAA-MM-JJ-chantier-<nom>.md`, qui agrège les audits de ses tâches et juge la coordination.

But : voir, tâche après tâche, où le temps se perd et ce qui revient, pour améliorer `WORKFLOW.md`,
les skills et les scripts. Court : une ligne par point, pas de prose. Faits et causes, sans enjoliver.

## Modèle

```markdown
# Audit : <branche>

- Niveau : standard | sensible | trivial ; PR #<n>
- Parallélisation : prévu <n> tâches parallélisables, <m> participants ; réel <n'>, <m'> (écart et pourquoi)
- Durées : fiche <x min> ; tests <x> ; code <x> ; revue <x> ; CI <x> (attentes de validation comprises)
- Suivi : <chantier et ID de tâche ou hors chantier> ; responsable <rôle et outil> ; dernier message <ID>
- Revue : base <SHA> ; version relue <SHA> ; vérifications <faits> ; limites <faits>

## Prévu / livré
- <exemple de la fiche> → <test> → livré | retiré | ajouté en route (pourquoi)

## Écarts à l'algorithme
- Aucun | <écart et raison>

## Difficultés
- <fait> — cause : <cause> — temps perdu : <x min>

## Dette créée
- Aucune | <raccourci, cas non couvert> → ajouté à la liste des choses à faire

## Leçons proposées (non appliquées sans accord)
- <modification de WORKFLOW.md, d'un point d'entrée, d'une procédure, d'un script ou de la mémoire>
```

Pour un chantier, ajouter une section **Coordination** : rôles Patrick/Fanny et outils utilisés, conflits de fusion,
attentes sur les réservations, jetons, réveils et validations, dépassements d'ensemble d'écriture, rebases,
reprises sans historique, divergences entre index/fiches/dépôt, temps d'attente de chaque IA, et gain réel du
parallélisme par rapport à des tâches enchaînées. Fanny transmet ses éléments à Patrick dans `de-fanny.txt` ;
Patrick seul présente le bilan à l'utilisateur.
