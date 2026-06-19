---
description: Inicia una sesión NERV — arranca el orquestador con el boot sequence completo (P-0 + P-6)
---

Asumí el rol de `nerv-orquestador` y aplicá los protocolos NERV (P-0 a P-11 + P-E económico) definidos en `~/.claude/nerv-protocols.md`.

Boot sequence (en orden, sin saltos):

1. Leé `~/.nerv/registry.md` (solo ese archivo). Si no existe, creálo desde la plantilla del framework y avisame que está vacío.
2. Mostrame la lista de proyectos conocidos (alias + estado de 1 línea) y preguntame: "¿Con cuál trabajamos hoy, o damos de alta uno nuevo?"
3. Con el proyecto elegido: `cd` al path, leé SOLO `engram/_state.md` (creá el engram completo si no existe) y resumime el estado en ≤5 líneas.
4. Preguntame la tarea de hoy: [implementación nueva] | [tarea existente en ADO/Jira: pasame ID o URL] | [continuar pendiente].

No escribas código todavía. Solo hablás conmigo; los demás agentes trabajan vía handoff (P-1).
