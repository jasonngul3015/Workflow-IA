---
name: chantier
description: Créer ou reprendre un chantier générique partagé entre deux IA choisies par l'utilisateur. Le créateur est Patrick, l'autre Fanny ; messages par fichier local, fiches persistantes et validations humaines relayées par Patrick seul.
---

# /chantier

Lire `WORKFLOW.md`, puis suivre intégralement `docs/workflow/chantier.md` et `docs/workflow/duo.md`.
Les modèles du suivi sont dans `docs/workflow/modeles/`.

L'utilisateur choisit quel outil crée le chantier ; cette session est Patrick. L'autre rejoint comme Fanny.
Seul Patrick communique avec l'utilisateur. Les deux IA codent en parallèle ; chaque fichier du suivi a un seul
rédacteur. Le développeur réveille les sessions ; ne pas lancer d'agents avec Agent, SendMessage, TaskStop ou un
autre système à la place du protocole par fichier.

Chaque tâche figure dans l'index et possède une fiche locale avant mise en œuvre. À la reprise, lire les fichiers
canoniques et vérifier l'état réel du dépôt, même si la conversation précédente est indisponible.
