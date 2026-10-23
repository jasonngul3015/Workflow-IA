# Une tâche, deux arrêts

L'IA écrit le code ; le développeur décide du quoi (fiche) et de la fusion. Entre les deux, l'IA avance seule.
Appliquer les principes et les réglages de `WORKFLOW.md` : les noms en gras (**Commits**, **Forge**, **Commandes**…)
renvoient à ces réglages.

## Niveau de la tâche (dans la fiche)

| Niveau | Quand | Arrêts |
| --- | --- | --- |
| **Trivial** | Coquille, doc, correctif d'une ou deux lignes (déclaré par le développeur) | Fiche en 3 lignes -> Fusion |
| **Standard** | Le reste | Fiche -> Fusion |
| **Sensible** | Sécurité, droits, données personnelles, schéma de données, déploiement, **Zones sensibles**, ou à la demande | Fiche -> Algorithmes et tests rouges -> Fusion |

En cas de doute entre standard et sensible : sensible.

## Arrêts imprévus (tous niveaux)

S'arrêter, expliquer en quelques lignes et attendre une réponse quand :

- une dépendance, un outil ou une version change (voir « Étape Stack ») ;
- un test déjà commité semble faux ;
- l'algorithme ne tient pas (cas oublié, contrainte de données, verrou) ;
- la fiche se révèle ambiguë ou la tâche dépasse nettement la **Taille d'une tâche** ;
- le **Vérificateur** ou la CI restent rouges après deux corrections.

## 0. Préparer

- `git status` : préserver les changements en cours ; s'ils gênent, demander un arbitrage sans les effacer.
- Hors chantier : partir de la **Branche principale** à jour et créer une branche selon **Branches de tâche**.
  Dans un chantier : utiliser uniquement le worktree et la branche attribués.
- Lire `WORKFLOW.md`, la liste des choses à faire et le code concerné. Noter l'heure de début (pour l'audit).

## 1. Fiche -> ARRÊT Fiche

Dans la **Langue** du projet, sans code, courte :

- **Niveau** et pourquoi ;
- **Comportements attendus** en exemples « situation -> résultat » : nominaux, puis erreurs avec l'erreur prévue
  selon les **Conventions d'erreur** ;
- **Hors sujet** ;
- **Fichiers probablement touchés** ;
- **Stack** : « inchangée », ou la présentation de l'étape Stack ;
- **Parallélisation** : tâches parallélisables (ensembles d'écriture disjoints, sans dépendance ni section critique
  commune) et participants (1, ou 2 en chantier), chacun avec sa raison en une ligne. Deux tâches
  parallélisables longues ou plus, ou besoin d'une revue indépendante : proposer un [chantier](chantier.md).

Tâche triviale : fiche en 3 lignes, parallélisation en fin de ligne (« 0 parallélisable, 1 participant »).
Une valeur par défaut qui change (adresse, réglage, droit) : ajouter aux exemples les entrées invalides qui
retomberaient en silence sur cette valeur.

Attendre la validation. C'est le seul arrêt avant la fusion d'une tâche standard : mieux vaut une question de plus ici.

## Étape Stack (seulement si la stack change)

Nouvelle dépendance, outil, image, action de CI, ou changement de version (langage, framework, base, gestionnaire
de paquets). Présenter, sans code :

| Rubrique | Contenu |
| --- | --- |
| Besoin | Pourquoi l'existant ne suffit pas ; coût de la solution sans dépendance |
| Proposition | Nom, version exacte, licence, date de publication (au moins 2 semaines), maintenance, vulnérabilités connues |
| Alternatives | 1 ou 2, une ligne chacune avec la raison du rejet |
| Compatibilité | Versions du projet ; dépendances transitives ajoutées |
| Architecture | Derrière quelle interface, dans quel adaptateur (jamais visible du cœur métier) |
| Vie privée | Données envoyées à l'extérieur ? |
| Production | Effet sur le déploiement, les images, la configuration |
| Retour arrière | Comment la retirer |

Après accord : commit séparé `chore(deps): ...` (selon **Commits**) avant le commit des tests.

## Cas exclusivement documentaire

Vérifier les liens, la cohérence des consignes et les scénarios de lecture ou de reprise. Expliquer pourquoi
tests rouges, algorithmes, casse et build sont sans objet ; ne pas inventer de tests. Validation, revue,
vérificateur et audit restent requis.

## 2. Tests rouges

Chaque exemple de la fiche devient au moins un test ; aucun test sans exemple. Au bon niveau :

- règles métier : tests unitaires de l'entité ou de la fonction pure ;
- cas d'utilisation : doubles en mémoire et horloge fixe ; interface modifiée -> double mis à jour ; action
  sensible -> entrée de journal vérifiée (si le projet en tient un) ;
- base de données, contraintes, API : tests d'intégration sur une base jetable ;
- interface : tests de composant ; parcours : tests de bout en bout.

Le code de production ne reçoit que le nécessaire pour compiler (fonction qui signale « non implémenté »).
Lancer **les tests concernés seulement** et vérifier qu'ils échouent pour la bonne raison, pas à la compilation.
Commit `test(<zone>): ...`.

**Sensible -> ARRÊT Algorithmes** : présenter ensemble le tableau « exemple -> test », le résultat rouge et les
algorithmes (étape 3). Attendre la validation avant de coder.

## 3. Algorithme

Pour chaque cas d'utilisation ou écran touché, sans code :

1. `Algorithme : a -> b -> c` puis les étapes `1. ...`, tels qu'ils iront en commentaire ;
2. où vit chaque règle (domaine, cas d'utilisation, base) ;
3. données : requêtes, migration, contraintes, transaction et verrous ;
4. interface : trajet entre les couches, états (chargement, vide, erreur) ;
5. étape -> test (étape non couverte : ajouter un test **avant** le commit des tests, ou le signaler) ;
6. choix écartés, une ligne chacun.

Standard : ce texte va dans la PR (section « Algorithmes »), le développeur le lit à la fusion.

## 4. Code vert

- Implémenter selon l'algorithme ; les commentaires `Algorithme :` et `1. ...`, dans la syntaxe du langage, le
  reprennent mot pour mot. Respecter **Couches et règle de dépendance**.
- **Ne pas modifier les tests** commités. Un test qui semble faux : arrêt imprévu.
- Boucle rapide : tests ciblés. Puis une fois : suite complète, build, et intégration ou bout en bout si les
  données ou un parcours changent (**Commandes**).

## 5. Les tests mordent, puis revue

- Casser volontairement une règle centrale, montrer qu'un test échoue, annuler la casse. Sauvegarder le fichier
  dans un dossier temporaire avant de casser et restaurer depuis cette copie, jamais par `git checkout -- <fichier>`
  (qui efface le code non commité) ; vérifier avec `git diff` que seule la casse a disparu. Une compilation
  incrémentale peut ignorer un fichier restauré avec son ancienne date : relancer après un nettoyage du build.
- **Vérificateur** : aucun échec ; traiter chaque « à valider ».
- Liste « terminé » : contrainte de données si règle sensible ; entrée de journal si action sensible ;
  documentation technique à jour ; décision produit dans `WORKFLOW.md` après accord ; case cochée dans la liste
  des choses à faire.
- Revue décrite dans [duo.md](duo.md#revue), plus sécurité si sensible. Seul, l'outil peut utiliser sa propre
  commande de revue ; la relecture est alors signalée comme non indépendante. Corriger ce qui est retenu.

## 6. Commit, push, PR, CI

- Commit `feat|fix(<zone>): ...` (et au besoin `docs: ...` séparé), message écrit dans un fichier temporaire puis
  `git commit -F`. Hook refusé : corriger le message, jamais contourner.
- Pousser la branche, créer la PR avec `.github/pull_request_template.md` rempli et suivre la CI (**Forge**).
  CI rouge : corriger par un nouveau commit (deux essais, puis arrêt imprévu).

## 7. Audit court

Fichier `<audits>/AAAA-MM-JJ-<branche avec / remplacé par ->.md` (**Chemins**), selon
[le modèle](modeles/audit.md), commit `docs(audit): ...` dans la même PR. Faits et causes, sans enjoliver ; les
leçons sont des propositions.

## 8. ARRÊT Fusion

Présenter en un message : lien de la PR, CI, résumé en clair, algorithmes, ce que l'audit signale, ce qu'il faut
essayer dans l'application. Fusionner selon **Fusion** et **Forge** seulement sur demande explicite ; jamais
d'étiquette de version sans demande.

## Participant d'un chantier

Lire aussi [chantier.md](chantier.md) et [duo.md](duo.md). Différences :

- Travailler dans le worktree attribué, en parallèle de l'autre IA, sans attendre hors des arrêts.
- Chaque arrêt de l'IA secondaire (fiche, algorithmes sensibles, imprévu, PR prête) est inscrit dans sa fiche puis
  signalé à l'IA principale dans `de-secondaire.txt`. L'IA principale seule présente les demandes au développeur.
- Mettre à jour `taches/Txxx.md` à chaque arrêt (état, preuves, reste à faire, blocage, prochaine action).
- Ne modifier que son ensemble d'écriture et ses propres fichiers de suivi ; règles communes, points d'entrée et
  liste des choses à faire sont réservés à l'IA principale.
- Ressource unique (ports fixes, environnement partagé) : uniquement avec le jeton attribué, rendu juste après.
- PR prête signifie arrêt avant fusion.
