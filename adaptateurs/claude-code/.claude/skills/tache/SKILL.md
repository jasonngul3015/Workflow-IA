---
name: tache
description: Suivre la procédure commune de tâche, de la fiche validée à la PR prête, avec tests d'abord et fusion sur décision humaine. Dans un chantier, respecter les rôles d'IA principale et secondaire et le suivi partagé.
---

# /tache

Raccourci propre à Claude Code : il ne définit aucune règle. Lire `WORKFLOW.md` (principes et réglages) et le suivi
local (`./scripts/suivi.ps1`, réglage **Suivi local**), puis suivre intégralement `docs/workflow/tache.md`. Dans un
chantier, lire aussi `docs/workflow/chantier.md`, `docs/workflow/duo.md` et le dossier de suivi, et attendre l'autre
rôle avec `scripts/attendre-message.ps1` (`duo.md`, section « Attente »). Sous-agents en lecture seule (exploration,
relecture) ; une aide lancée pour une tâche entière suit « Aides par tâche » de `docs/workflow/chantier.md` et ne
lance pas d'aide à son tour.
