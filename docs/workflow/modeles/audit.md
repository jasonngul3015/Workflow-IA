# Audit : <branche>

<!-- Un fichier par tâche, dans le dossier des audits (réglage Chemins) :
     AAAA-MM-JJ-<branche>.md, la barre oblique remplacée par un tiret (feat/invitations -> 2026-10-20-feat-invitations.md).
     Un chantier ajoute AAAA-MM-JJ-chantier-<nom>.md, qui agrège les audits de ses tâches.
     But : voir où le temps se perd et ce qui revient, pour améliorer le workflow. Une ligne par point, faits et causes. -->

- Niveau : standard | sensible | trivial ; PR <lien ou numéro>
- Parallélisation : prévu <n> tâches parallélisables, <m> participants ; réel <n'>, <m'> (écart et pourquoi)
- Durées : fiche <x min> ; tests <x> ; code <x> ; revue <x> ; CI <x> (attentes de validation comprises)
- Suivi : <chantier et ID de tâche, ou hors chantier> ; responsable <rôle et outil> ; dernier message <ID>
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
- <modification de WORKFLOW.md, d'une procédure, d'un script ou d'un point d'entrée d'outil>

## Coordination (audit de chantier seulement)
- Rôles et outils : <IA principale = ..., IA secondaire = ...>
- Conflits de fusion, rebases : <faits>
- Attentes : réservations, jetons, réveils, validations ; temps d'attente de chaque IA : <faits>
- Dépassements d'ensemble d'écriture, reprises sans historique, divergences index/fiches/dépôt : <faits>
- Gain réel du parallélisme par rapport à des tâches enchaînées : <estimation et base>
