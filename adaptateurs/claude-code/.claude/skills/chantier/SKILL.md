---
name: chantier
description: Créer ou reprendre un chantier partagé entre deux IA choisies par l'utilisateur. Le créateur est l'IA principale, seule à parler à l'utilisateur ; l'autre est l'IA secondaire. Code en parallèle, messages par fichiers à rédacteur unique, fiches persistantes.
---

# /chantier

Raccourci propre à Claude Code : il ne définit aucune règle. Lire `WORKFLOW.md` (principes et réglages), puis
suivre intégralement `docs/workflow/chantier.md` et `docs/workflow/duo.md`. Modèles : `docs/workflow/modeles/`.

Cette session crée le chantier, elle est donc l'IA principale (surnom éventuel : réglage « Rôles d'un chantier »).
Ne pas lancer d'agents avec Agent, SendMessage, TaskStop ou un autre système à la place du protocole par fichier.
