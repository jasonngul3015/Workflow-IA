## Fiche de tâche

<!-- Niveau (trivial, standard, sensible), comportements attendus (situation -> résultat), hors sujet,
     parallélisation (tâches parallélisables, participants). Lien vers la case de la liste des choses à faire. -->

## Stack

<!-- « Inchangée », ou la présentation validée (besoin, proposition, alternatives, retour arrière). -->

## Suivi et revue

<!-- Si chantier : lien vers chantier.md et taches/Txxx.md dans le dernier suivi sauvegardé.
     Rapporter les décisions, la base et le SHA relus, les défauts corrigés, les vérifications et leurs limites.
     Attribution selon le réglage du projet (par défaut : rôles et outils dans le suivi, pas dans la PR). -->

## Tests écrits d'abord

| Exemple de la fiche | Test(s) |
| --- | --- |
|  |  |

## Algorithmes

<!-- « Algorithme : a -> b -> c » et étapes, tels qu'ils figurent en commentaire dans le code. -->

## Ce qui a changé, en clair

<!-- Fichiers modifiés et rôle de chacun. Ce qu'il faut essayer dans l'application. -->

## Audit

<!-- Lien vers <audits>/AAAA-MM-JJ-<branche>.md et, en une ligne, ce qu'il signale. -->

## Terminé ?

- [ ] Fiche validée avant le code (commit `test(...)` en premier ; algorithmes validés aussi si tâche sensible ; documentation seule : vérifications adaptées et éléments sans objet expliqués)
- [ ] Vérificateur sans échec, chaque « à valider » traité
- [ ] Le code suit l'algorithme (commentaires `Algorithme :` identiques à la section ci-dessus)
- [ ] Les tests mordent (une casse volontaire les fait échouer)
- [ ] Suite de tests complète et build passent
- [ ] Tests d'intégration lancés si la base change, de bout en bout si un parcours change
- [ ] Contrainte en base si règle sensible ; entrée d'audit + test si action sensible
- [ ] Documentation technique à jour, décision validée dans `WORKFLOW.md` le cas échéant
- [ ] Case cochée dans la liste des choses à faire
- [ ] Revue effectuée selon `docs/workflow/duo.md` (sécurité aussi si sensible), base et SHA relus indiqués
- [ ] Audit écrit
- [ ] Si chantier : fiche locale à jour, limites et prochaine action explicites, index synchronisé
