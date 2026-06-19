---
description: Genera handoff P-1 hacia un agente NERV. Uso — /nerv-handoff <agente> <ticket-id>
argument-hint: <agente> <ticket-id>
---

Ejecutá un handoff P-1 según los protocolos NERV (`~/.claude/nerv-protocols.md`).

Argumentos: $ARGUMENTS  (formato esperado: `<agente> <ticket-id>` — ej. `nerv-backend T-042`)

Pasos (en orden, sin saltos):

1. **Validar precondiciones P-1**:
   - El ticket existe en `engram/03_backlog.md` con ID, criterios de aceptación, rama y **nivel de revisión** (Niv: A/S/X, P-11).
   - Si el nivel no está, asignalo ahora: A=Advisory (default) · S=Strong (auth/seguridad/pagos/migraciones o >400 líneas) · X=Adversarial (architecture-critical).
   - Si falta criterios o rama → STOP, decímelo en 1 línea, no inventes.

2. **Identificar archivos mínimos** que el agente debe leer (solo los que pide su ticket): ticket en backlog, ADRs citados, sección del contrato que toca, su sección en `~/.nerv/playbook.md`. Nunca pegar contenido en la invocación; solo rutas + IDs.

3. **Agregar entrada en `engram/05_handoff_log.md`** ARRIBA de todas las demás, formato:
   ```
   ### [YYYY-MM-DD HH:MM] nerv-orquestador → <agente> <ticket> · Niv <A/S/X>
   - Entrega: <qué se le pide>
   - Archivos a leer: <lista compacta>
   - Se espera (retorno estructurado): estado · archivos tocados · riesgos/caveats · cómo probar
   ```

4. **Invocar al subagente** vía `Agent` tool con un prompt MÍNIMO que contenga solo: ID del ticket + nivel de revisión (P-11) + lista de archivos a leer + referencia a los protocolos en `~/.claude/nerv-protocols.md`.

5. **Esperar el handoff de retorno estructurado** del agente (estado · archivos tocados · riesgos · cómo probar). No cierres por él (P-1: nadie cierra solo).
