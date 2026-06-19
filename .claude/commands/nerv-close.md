---
description: Ejecuta el cierre P-5 explícito de la sesión NERV — actualiza state, backlog, handoff log y registry
---

Cerrá la sesión NERV aplicando el protocolo P-5.

Pasos (en este orden, sin saltar):

1. **`engram/03_backlog.md`** — actualizá estados de tickets tocados en esta sesión (En progreso / En revisión QA / Done / Bloqueado).

2. **`engram/_state.md`** — sobrescribilo (≤15 líneas) con el estado VIVO actual:
   ```
   # STATE — [alias] · actualizado: YYYY-MM-DD HH:MM
   **Sprint:** [n] — [objetivo]
   **Rama activa:** [feature/...] → target: [dev]
   **En curso:** T-XXX ([agente], [estado])  ·  T-YYY (...)
   **Bloqueos:** [ninguno | T-XXX espera...]
   **Próximo paso sugerido:** [1 línea]
   **Preguntas abiertas al PO:** [n] (detalle en 01_requirements.md §6)
   ```

3. **`engram/05_handoff_log.md`** — entrada nueva ARRIBA con el cierre:
   ```
   ### [YYYY-MM-DD HH:MM] CIERRE DE SESIÓN
   - Hecho hoy: [resumen 1 línea]
   - Próximo paso: [1 línea]
   - Quien retoma: [agente sugerido]
   ```

4. **`~/.nerv/registry.md`** — actualizá la fila del proyecto activo:
   - "Última sesión" → fecha de hoy
   - "Estado (1 línea)" → frase compacta de dónde quedó

5. **Retro (P-10)** — sintetizá la sesión a partir de los handoffs de retorno y los
   veredictos de QA (sin convocar agentes):
   - `engram/06_retro.md` (crealo si no existe) → entrada nueva ARRIBA (≤8 líneas):
     ✅ qué salió bien · ⚠️ qué salió mal · 🎯 acción concreta para la próxima.
   - `~/.nerv/playbook.md` → promové SOLO lecciones de proceso que apliquen a CUALQUIER
     proyecto, en la sección del rol correspondiente (≤10 líneas/rol). Lo específico del
     proyecto NO sube: queda en 06_retro.md.

6. **Resumen al PO** ≤5 líneas con: qué se hizo, qué quedó pendiente, próximo paso.

P-E (economía): no leas archivos que no toques. Diffs sobre lo existente, no regeneración.

**Después de este comando, la sesión NERV se considera cerrada y segura para terminar.**
