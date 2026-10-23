# Audit : docs/duo-patrick-fanny

- Niveau : standard, documentation et modèles ; PR : non créée, livraison locale.
- Autorisation : proposition corrigée selon les choix de l'utilisateur, puis instruction « Implémente ».
- Parallélisation : prévu 0 tâche indépendante et 0 agent supplémentaire ; réel identique ; aucune autre session lancée.
- Durées : non mesurées ; aucune durée estimée présentée comme observée.
- Stack : inchangée ; aucun transport, dépendance ou programme de relais ajouté.

## Prévu / livré

- Règles génériques pour les deux IA → `WORKFLOW.md` comme seul point d'entrée commun et procédures indépendantes des fournisseurs → livré ; fichiers d'entrée spécifiques retirés après précision de l'utilisateur.
- Créateur principal, noms indépendants des outils → rôles Patrick/Fanny dans les procédures et modèles → livré.
- Seul Patrick parle à l'utilisateur → circuit des questions, validations et rapports de Fanny → livré.
- Réveil manuel et messages locaux → journal `.txt`, ajout en fin et tour de passation explicite → livré.
- État lisible sans historique → index et fiche par tâche avec périmètre, preuves et prochaine action → livré.
- Reprise sur une autre machine → sauvegarde du suivi et des branches, adaptation des chemins et vérification réelle → documenté ; aucune synchronisation automatique promise.

## Vérifications

- Liens locaux Markdown : 30 cibles existantes vérifiées après retrait des points d'entrée spécifiques ; lien fictif de la tâche du modèle exclu explicitement.
- UTF-8 sans BOM, espaces finaux et `git diff --check` : contrôlés sur les modifications documentaires.
- Vérificateur existant : sortie 0 avec `-Base origin/main`, sur les changements locaux non commités ; aucun contrôle d'historique nouveau ne peut être démontré à ce stade.
- Avertissements de configuration : motifs Java/TypeScript et couches absents, attendus pour ce dépôt de modèles ; configuration d'exemple conservée et nécessité d'adaptation précisée dans l'installation.
- Revue documentaire : rôles inversables entre outils, création/reprise, validations sensibles, blocage de Fanny via Patrick, instruction déjà traitée, passation interrompue, worktrees distincts et PR prête sans fusion examinés dans les consignes.
- Revue : relecture dans la session réalisatrice, non indépendante ; pas de revue par une seconde IA ni d'échange réel entre deux IA exécuté.
- Tests rouges, casse volontaire et build : sans objet, aucun comportement exécutable modifié ; les règles de ces étapes restent conservées pour le code applicatif.

## Difficultés et limites

- Écriture simultanée du journal → tour d'écriture explicite ; convention manuelle, sans verrou technique.
- Copies du suivi dans les worktrees → chemin canonique commun obligatoire ; pas de communication entre copies isolées.
- Exécution PowerShell désactivée par défaut → vérification lancée avec une politique limitée au processus enfant ; aucune configuration système modifiée.
- Essai avec deux sessions réelles → reste à faire par le développeur ; inscrit dans `docs/projet/a-faire.md`.

## Écarts et dette

- Ancien chantier lié à un mécanisme spécifique de sous-agents → remplacé par le duo manuel demandé ; aucune communication automatique conservée.
- Précision utilisateur sur le caractère générique → aucun fournisseur ni fichier d'entrée spécifique requis dans les règles, procédures, modèles et instructions d'installation ; raccourcis historiques facultatifs.
- Aucun script exécutable, hook ni réglage de permissions modifié.

## Leçons proposées

- Observer un chantier réel avant d'ajouter un mécanisme de verrouillage ou d'automatisation ; aucune nouvelle règle proposée appliquée implicitement.
