---
name: chantier
description: Créer ou reprendre un chantier partagé entre deux IA choisies par l'utilisateur. Le créateur est l'IA principale, seule à parler à l'utilisateur ; l'autre est l'IA secondaire. Code en parallèle dans des worktrees, messages par fichiers à rédacteur unique, fiches persistantes.
---

# /chantier

Raccourci propre à Claude Code : il ne définit aucune règle. Lire `WORKFLOW.md` (principes et réglages), puis
suivre intégralement `docs/workflow/chantier.md` et `docs/workflow/duo.md`. Modèles : `docs/workflow/modeles/`.

Cette session crée le chantier, elle est donc l'IA principale (surnom éventuel : réglage « Rôles d'un chantier »).
Ne jamais remplacer le protocole par fichier entre les deux IA par Agent ou SendMessage ; attendre l'IA secondaire
avec `scripts/attendre-message.ps1` (`duo.md`, section « Attente »). Pour faire avancer plusieurs de ses tâches
parallèles, lancer une aide par tâche entière (outil Agent, `isolation: "worktree"`, `run_in_background: true`),
selon « Aides par tâche » de `docs/workflow/chantier.md` ; la relancer avec SendMessage après chaque arrêt. Au
cadrage, donner au développeur la commande de lancement autonome de chaque session (réglage « Autorisations des
outils »).
