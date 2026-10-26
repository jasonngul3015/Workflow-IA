# T001 : <objectif>

<!-- Fiche d'une tâche, dans un chantier (taches/Txxx.md du dossier du chantier) ou seule (Suivi local :
     taches/AAAA-MM-JJ-<branche avec / remplacé par ->.md, ex. feat/invitations -> 2026-10-20-feat-invitations.md ;
     titre sans identifiant). Hors chantier, les lignes marquées « chantier » sont sans objet : les supprimer.
     scripts/suivi.ps1 lit la section Résumé (une ligne « - Clé : valeur » par clé) pour générer l'index :
     garder ces clés et ce format, puis relancer le script après chaque mise à jour. Enregistrer en UTF-8
     (outil d'édition, ou Set-Content -Encoding utf8 ; jamais le codage par défaut de PowerShell 5.1). -->

## Résumé

- État : à cadrer (chantier) | à valider | prête (chantier) | en cours | bloquée | à relire | PR prête | fusionnée | annulée
- Étape : fiche | tests rouges | algorithme | code | vérifications | revue | CI | audit | fusion
- Branche : <branche>
- Worktree : <chemin ou aucun>
- Responsable : <outil et session>
- Prochaine action : <action précise>
- Mise à jour : <AAAA-MM-JJ HH:MM avec fuseau>

## Fiche et périmètre

- Niveau : trivial (déclaré par l'utilisateur) | standard | sensible ; raison : <...>
- Objectif : <un comportement>
- Hors sujet : <...>
- Stack : inchangée | <présentation et validation liées>
- Parallélisation : <n> tâches indépendantes ; participants : <1 ou 2 et rôle>
- Phase (chantier) : socle | parallèle | séquentielle ; dépendances : <IDs et conditions de livraison>
- Responsable : IA principale | IA secondaire | IA seule ; outil et session : <...>
- Branche / worktree : <branche> / <chemin absolu>
- Base et SHA de départ : <référence> / <SHA>
- Écritures autorisées (code) : <fichiers/dossiers>
- Écritures autorisées (suivi) : <cette fiche et, en chantier, son fichier de messages ; l'index est généré>
- Lectures critiques (chantier) : <fichiers et versions>
- Ressources / jetons (chantier) : <attribution par l'IA principale ou aucun>

| Situation | Résultat attendu / erreur | Test ou vérification documentaire |
| --- | --- | --- |
| <exemple> | <résultat> | <preuve prévue> |

## Autorisations

- Plan : <référence ou en attente> (ne valide pas seul la fiche)
- Fiche : <référence de validation humaine, portée et message relais ou en attente>
- Algorithmes et tests rouges si sensible : <référence ou en attente / sans objet>
- Stack ou autres arbitrages : <références ou sans objet>
- Fusion : <demande explicite référencée ou en attente>

## État durable

<!-- État, étape, prochaine action et date de mise à jour : seulement dans la section Résumé (une seule source). -->

- Dernier message de l'autre rôle traité (chantier) : <P... / S... ou aucun>
- Réalisé : <faits>
- Reste à faire : <actions>
- Modifications non commitées : <liste ou aucune, à confirmer par git status>
- Dernier commit : <SHA ou aucun> ; PR : <lien ou aucune>
- Blocages / risques : <faits ou aucun>
- Responsable de la prochaine action : <rôle>

## Algorithmes et décisions

<Algorithme : a -> b -> c ; étapes et correspondance avec les tests. Si documentaire : sans objet et pourquoi.>

| Date | Décision et raison | Validation / message |
| --- | --- | --- |

## Preuves de vérification

<!-- Ne pas déclarer une réussite non exécutée. Indiquer les modifications non commitées testées si le SHA seul ne décrit pas le résultat. -->

| Date | Commande / vérification | Résultat et limites | SHA et état du diff | Preuve / message |
| --- | --- | --- | --- | --- |

## Revue

- Réviseur et session : <...>
- Base et SHA relus : <...>
- Défauts, gravité, fichiers : <faits ou aucun relevé>
- Vérifications effectuées / limites : <...>
- Verdict et corrections à relire : <...>

## Audit et historique

- Audit : <chemin ou à écrire>
- Propositions de documentation centrale : <à transmettre à l'IA principale>

| Date | Responsable sortant / entrant | Arrêt confirmé | État réel vérifié | Message / prochaine action |
| --- | --- | --- | --- | --- |
