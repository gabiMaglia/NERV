---
description: Crea un ticket nuevo en engram/03_backlog.md con plantilla completa. Uso — /nerv-ticket "<descripción>"
argument-hint: "<descripción del ticket>"
---

Crea un ticket nuevo en `engram/03_backlog.md` con la plantilla NERV.

Descripción inicial: $ARGUMENTS

Pasos:

1. **Leé SOLO** `engram/03_backlog.md`. Si no existe → STOP, decímelo.

2. **Calculá el próximo ID** correlativo (T-001, T-002, ...). Si hay tracker externo activo (ADO/Jira), preguntame si querés crear el work item ahí primero (P-7) o creamos el ticket local y lo espejamos después.

3. **Agregá la fila al sprint activo** con:
   ```
   | T-XXX | <ID externo o —> | <título corto> | <agente sugerido> | To Do | <Niv> | <criterios> | <rama propuesta> |
   ```

4. **Preguntame los campos que falten** en UN solo mensaje (P-3 cero suposiciones):
   - Criterios de aceptación (lista numerada, mínimo 1)
   - Agente sugerido (nerv-backend / nerv-mobile / nerv-web / nerv-desktop / nerv-qa)
   - Nivel de revisión (P-11): A=Advisory (default) · S=Strong (auth/seguridad/pagos/migraciones o >400 líneas) · X=Adversarial (architecture-critical). Si no lo indico, default A.
   - Rama propuesta (sugerí formato `feature/T-XXX-slug` o `feature/AB123-slug` si hay ADO)
   - Prioridad / sprint

5. **Si me pasaste tracker externo activo**: ofrecé crearlo en ADO/Jira ahora con CLI o MCP.

6. **Devolveme** el ID asignado + handoff sugerido (`/nerv-handoff <agente> T-XXX` cuando esté listo).

P-3: si la descripción es ambigua, registralo en `engram/01_requirements.md §6` antes de crear el ticket.
