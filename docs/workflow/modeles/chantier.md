# Chantier : <nom>

État : à valider | actif | bloqué | terminé | annulé
Créé : <date avec fuseau> ; dernière mise à jour : <date avec fuseau>

## Objectif et limites

- But : <résultat attendu>
- Inclus : <périmètre>
- Hors sujet : <limites>
- Règles : `WORKFLOW.md`, `docs/workflow/tache.md`, `docs/workflow/chantier.md`, `docs/workflow/duo.md`
- Liste des choses à faire : <chemin>
- Parallélisation : <n> tâches indépendantes ; 2 participants codant en parallèle (répartition : <IDs par rôle>)
- Ordre/graphe des dépendances : <IDs et ordre>

## Rôles et chemins

- IA principale (surnom : <...>) : <outil>, session <identifiant>
- IA secondaire (surnom : <...>) : <outil>, session <identifiant ou à rejoindre>
- Dossier canonique du suivi : <chemin absolu sur cette machine>
- Checkout et branche de suivi (IA principale) : <chemin et branche>
- Dépôt et base : <dépôt>, <référence et SHA>
- Messages : `de-principale.txt` et `de-secondaire.txt`, un seul rédacteur chacun (voir `docs/workflow/duo.md`).
- Aucun changement de rôle sans décision humaine et arrêt confirmé de l'ancien responsable.

## Index des tâches

<!-- L'IA principale seule met cet index à jour à partir des fiches. Ajouter aussi la tâche de documentation du chantier. -->

| ID | Objectif | Niveau | Phase | Responsable | État / étape | Dépend de | Fiche |
| --- | --- | --- | --- | --- | --- | --- | --- |
| T001 | <comportement> | standard | socle / parallèle / séquentielle | principale / secondaire | à cadrer | aucune | [T001](taches/T001.md) |

## Validations et décisions humaines

<!-- L'IA principale consigne les réponses exactes ou un résumé fidèle, sans élargir leur portée. -->

| Référence (V001…) | Date | Type (plan, fiche, algorithmes, stack, fusion, autre) | Tâches | Décision et portée | Message relais |
| --- | --- | --- | --- | --- | --- |

## Réservations et jetons

| Ressource ou fichier | Tâche / détenteur | Depuis | Libéré le | File d'attente |
| --- | --- | --- | --- | --- |

## Blocages et prochaine action

- Blocages : <aucun ou faits>
- Prochaine action : <action>, par <IA principale / IA secondaire / développeur>
- Dernier message de l'IA secondaire traité : <S... ou aucun>
- Dernière sauvegarde du suivi : <commit / PR ou non sauvegardé>

## Historique des reprises

| Date | Session entrante / rôle | Session précédente arrêtée (preuve) | Vérification de l'état réel | Décision |
| --- | --- | --- | --- | --- |
