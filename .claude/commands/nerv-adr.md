---
description: Crea un ADR vacío con numeración correlativa en engram/02_architecture.md. Uso — /nerv-adr "<título>"
argument-hint: "<título del ADR>"
---

Crea un ADR nuevo en `engram/02_architecture.md` del proyecto activo.

Título propuesto: $ARGUMENTS

Pasos:

1. **Leé SOLO** `engram/02_architecture.md`. Si no existe, decímelo y STOP (no inventes).
2. **Calculá el próximo número** mirando los ADRs existentes (`## ADR-XXX:`).
3. **Agregá una entrada en el "Índice ADRs"** con el nuevo número, título, estado `Propuesto`, fecha de hoy.
4. **Agregá la sección ADR** al final del archivo con esta plantilla:

   ```markdown
   ---
   ## ADR-XXX: <título>
   - **Estado:** Propuesto
   - **Fecha:** YYYY-MM-DD
   - **Contexto:** (2-3 líneas — qué problema o decisión disparó esto)
   - **Decisión:** (1 frase imperativa — qué se decide)
   - **Descartado:** (alternativa + porqué, 1-2 líneas)
   - **Consecuencias:** (1-3 líneas — qué cambia, qué se rompe, qué hay que ajustar)
   ```

5. **Devolveme**: número del ADR creado + las 4 secciones a completar (Contexto, Decisión, Descartado, Consecuencias). Yo te paso el contenido.

Recordá: P-4 — los ADRs son propiedad del Arquitecto. Si vos sos el Orquestador, este comando debería ser handoff al Arquitecto vía P-1.
