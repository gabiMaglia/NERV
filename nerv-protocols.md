# NERV — Protocolos de Operación

> Cargados bajo demanda por los agentes NERV. NO se incluyen en el CLAUDE.md global:
> solo aplican cuando arrancás una sesión NERV con el prompt de ignición.

## P-0 · Memoria
El Engram y ~/.nerv/registry.md son la única memoria. Lo no escrito no existe.
Boot del Orquestador: registry → selección de proyecto → engram/_state.md. NADA más.

## P-E · Economía de Tokens (transversal, obligatorio)
1. Lectura mínima: cada agente abre SOLO los archivos/secciones que su handoff
   indica. Prohibido "leer todo el engram para contexto".
2. _state.md ≤15 líneas; entradas de handoff ≤6 líneas; resúmenes al PO ≤5 líneas.
3. Nunca pegar contenido de archivos en el chat ni en invocaciones de subagentes:
   se referencia por ruta + ID (ticket, ADR, endpoint).
4. Rotación: handoff_log >30 entradas y sprints cerrados >5 → ~/.nerv/archive/.
   Los archivos archivados NO se leen salvo pedido explícito del PO.
5. No repetir información que ya está en un archivo: citar el ID.
6. Diffs sobre archivos existentes, no regeneración completa.

## P-1 · Handoff
Válido solo si: (1) ticket existe en 03_backlog.md con ID, criterios, rama y
**nivel de revisión** (P-11); (2) la invocación al subagente contiene SOLO: ID de
ticket + nivel de revisión + lista de archivos/secciones a leer; (3) entrada
registrada en 05_handoff_log.md; (4) el receptor lee su sección en
~/.nerv/playbook.md (lecciones de proceso) antes de codear; (5) el receptor
devuelve el control al Orquestador con su **handoff de retorno estructurado**
(≤6 líneas): `estado` · `archivos tocados` · `riesgos/caveats` · `cómo probar`.
Nadie cierra solo.

## P-2 · Rechazo de QA
RECHAZADO ⇒ lista numerada de defectos en backlog → vuelve "En progreso" al mismo
Tech Lead → corrección SOLO de los defectos listados (sin refactors oportunistas)
→ re-revisión. 2 rechazos consecutivos ⇒ escalar a nerv-arquitecto e informar al PO.

## P-3 · Cero Suposiciones
Ambigüedad de alcance/comportamiento/prioridad ⇒ STOP. Se registra en
01_requirements.md §6 y el Orquestador pregunta al PO. Prohibido: inventar
requisitos, mockear en silencio, asumir respuestas de API. La respuesta del PO
se escribe ANTES de retomar. (Trade-offs puramente técnicos: los resuelve el
Arquitecto vía ADR sin molestar al PO.)

## P-4 · Propiedad de escritura
registry/_state/backlog/handoff: Orquestador · ADRs: Arquitecto · contratos de
sus endpoints: Backend · veredictos y "Done": QA · estados de tarea propios:
cada Tech Lead. Cambios fuera de tu propiedad: solicitar vía Orquestador.

## P-5 · Cierre de sesión
Antes de terminar, el Orquestador SIEMPRE: (a) actualiza 03_backlog.md y
_state.md; (b) entrada de cierre en 05_handoff_log.md con próximo paso;
(c) actualiza "Última sesión" y "Estado" del proyecto en ~/.nerv/registry.md;
(d) corre la retro P-10; (e) resumen al PO ≤5 líneas.

## P-6 · Selección / alta de proyecto
"Vamos a trabajar en X": si X está en el registry → cargar. Si no → intake en
UN mensaje: alias, path local, git remoto, rama objetivo (default: dev),
tracker+board, Figma. Verificar repo (clonar si hace falta), crear engram/ desde
plantillas si no existe, agregar fila al registry. Cambio de proyecto a mitad de
sesión ⇒ ejecutar P-5 sobre el actual primero.

## P-7 · Tareas con tracker externo (ADO/Jira)
- Importar existente: traer work item por ID/URL (MCP de ADO/Jira, o CLI:
  `az boards work-item show --id N`), crear ticket espejo en 03_backlog.md con
  columna Ext mapeada. La descripción externa NO reemplaza criterios de
  aceptación: si faltan, P-3.
- Crear nueva: ticket primero en backlog (aprobado por PO) → crear work item
  externo → guardar ID en columna Ext.
- Estados: al pasar a "En revisión QA" y a "Done", el Orquestador refleja el
  estado en el tracker (mover columna / comentario con link al PR).
- Sin credenciales/MCP disponible ⇒ avisar al PO y continuar solo en engram.

## P-8 · Flujo Git (implementación estándar)
1. Ticket aprobado ⇒ Orquestador crea rama desde la rama objetivo actualizada:
   `feature/T-XXX-slug` (con tracker: `feature/AB123-slug` o convención del
   proyecto). Registrar rama en el ticket.
2. Tech Lead implementa y commitea en esa rama. Mensajes: convención
   convencional + referencia externa (ADO: incluir `AB#123` para auto-link).
3. QA aprueba ⇒ Orquestador pushea y abre PR a la rama objetivo
   (`gh pr create` / `az repos pr create`) con: título = ticket, descripción =
   criterios + resumen de cambios + link al work item.
4. NUNCA: push directo a dev/main/master, ni merge del PR sin orden explícita
   del PO. El PR queda abierto y se informa el link.
5. Conflictos o pipeline rojo ⇒ ticket "Bloqueado" + informar al PO.
6. **Commit = unidad de trabajo**: cada commit es un comportamiento/fix/migración
   entregable con sus tests y docs JUNTOS, que pasa review y se revierte solo sin
   tocar trabajo ajeno. Prohibido agrupar por tipo de archivo (todos los modelos,
   luego todos los tests). Mensaje outcome-focused: `feat(auth): add token
   validation model and tests`, no `add models`.
7. **Chained PRs**: si el ticket forecast >400 líneas de diff (umbral P-11),
   planificar PRs encadenados por unidad de trabajo en vez de un PR gigante;
   cada slice revisable y mergeable de forma independiente.

## P-9 · Cadena de mando
El PO habla SOLO con nerv-orquestador. Si otro agente recibe input directo del
PO, responde: "Derivo al Orquestador" y no actúa.

## P-10 · Retro de cierre (aprendizaje continuo)
Tras P-5 y antes del resumen al PO, el Orquestador corre la retro de la sesión.
Sin convocar agentes (P-E): sintetiza, no convoca.
1. Insumos: handoffs de retorno de la sesión en 05_handoff_log.md + veredictos de
   QA (aprobados y rechazos con su motivo) + bloqueos. Solo lo de ESTA sesión.
2. Escribe en 06_retro.md una entrada nueva ARRIBA (≤8 líneas): qué salió bien,
   qué salió mal, y la acción concreta que cambia la próxima. Específico del proyecto.
3. Promueve SOLO lecciones de proceso duraderas a ~/.nerv/playbook.md, en la sección
   del rol que aplica (≤10 líneas/rol). Si una lección nueva contradice una vieja, la
   reemplaza. Criterio de promoción: entra al playbook únicamente si aplicaría a
   CUALQUIER proyecto; lo atado a este proyecto queda solo en 06_retro.md.
4. Los agentes leen su sección del playbook antes de codear (P-1). Así el equipo no
   repite el mismo error entre sesiones ni entre proyectos.

## P-11 · Niveles de revisión (QA escalonado)
QA no gasta el mismo esfuerzo en un typo que en auth. El Orquestador marca el nivel
en el ticket al hacer el handoff (P-1); QA lo aplica. Las lentes son dimensiones de
UNA auditoría, no subagentes en paralelo (P-E: QA no convoca a nadie).
- **Advisory** (default, cambio acotado): lentes núcleo — criterios de aceptación
  + legibilidad. Costo ~1x. Es el caso cotidiano.
- **Strong** (el diff toca `auth`/seguridad/pagos/migraciones, **o** supera 400
  líneas): las 4 lentes — *riesgo* (seguridad/datos), *resiliencia* (errores/edge
  cases), *legibilidad* (claridad/mantenibilidad), *fiabilidad* (tests/correctitud).
- **Adversarial** (cambio architecture-critical / ADR nuevo, o 2º intento tras un
  rechazo): además de Strong, una pasada hostil — "asumí que está roto, encontrá el
  fallo". La corre QA; en cambios architecture-critical la corre nerv-arquitecto; en
  cambios de seguridad/infra críticos (auth/pagos/secretos/PII/deploy), nerv-devops.
- Anti-bloat (P-E): el nivel se elige por el ticket, NO se sube "por las dudas".
  Subir de nivel sin trigger es desperdicio de tokens; bajarlo en un path sensible
  es negligencia.
