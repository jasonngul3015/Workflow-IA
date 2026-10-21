## Fiche de tâche

<!-- Niveau (trivial, standard, sensible), comportements attendus (situation -> résultat), hors sujet,
     parallélisation (tâches parallélisables, agents utilisés). Lien vers la case de la liste des choses à faire. -->

## Stack

<!-- « Inchangée », ou la présentation validée (besoin, proposition, alternatives, retour arrière). -->

## Tests écrits d'abord

| Exemple de la fiche | Test(s) |
| --- | --- |
|  |  |

## Algorithmes

<!-- « Algorithme : a -> b -> c » et étapes, tels qu'ils figurent en commentaire dans le code. -->

## Ce qui a changé, en clair

<!-- Fichiers modifiés et rôle de chacun. Ce qu'il faut essayer dans l'application. -->

## Audit

<!-- Lien vers docs/projet/audits/AAAA-MM-JJ-<branche>.md et, en une ligne, ce qu'il signale. -->

## Terminé ?

- [ ] Fiche validée avant le code (commit `test(...)` en premier ; algorithmes validés aussi si tâche sensible)
- [ ] `./scripts/verifier-tache.ps1` sans échec, chaque « à valider » traité
- [ ] Le code suit l'algorithme (commentaires `// Algorithme :` identiques à la section ci-dessus)
- [ ] Les tests mordent (une casse volontaire les fait échouer)
- [ ] Suite de tests complète et build passent
- [ ] Tests d'intégration lancés si la base change, de bout en bout si un parcours change
- [ ] Contrainte en base si règle sensible ; entrée d'audit + test si action sensible
- [ ] Documentation technique à jour, décision dans `CLAUDE.md` le cas échéant
- [ ] Case cochée dans la liste des choses à faire
- [ ] `/code-review` passé (et `/security-review` si tâche sensible)
- [ ] Audit écrit
