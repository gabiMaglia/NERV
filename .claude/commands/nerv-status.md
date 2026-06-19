---
description: Resumen vivo del proyecto NERV activo (state.md + último handoff + tickets en curso)
---

Como `nerv-orquestador`, devolveme un status compacto del proyecto activo. Formato fijo:

```
📋 PROYECTO: [alias] · Sprint [n]
📍 RAMA:     [feature/...] → target [dev]
🎯 OBJETIVO: [sprint goal en 1 frase]

EN CURSO:
  - T-XXX [estado] · [agente] · [1 línea de qué falta]
  - T-YYY ...

BLOQUEOS:
  - [ninguno | T-XXX espera respuesta del PO sobre X]

ÚLTIMO HANDOFF: [fecha hora] [de]→[a] T-XXX
  → [1 línea de lo que se entregó]

PRÓXIMO PASO: [1 línea]
```

Lee SOLO: `engram/_state.md` + primera entrada de `engram/05_handoff_log.md`. Nada más. Si falta algo, decímelo en una línea — no inventes.
