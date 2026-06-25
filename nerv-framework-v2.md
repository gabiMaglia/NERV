# NERV — Framework Multi-Agente Multi-Proyecto

> **Versión:** 2.0 · **Entorno:** Claude Code (CLI) · **Nivel:** instalación global de usuario
> **Stack por defecto:** React Native · NestJS + PostgreSQL · Scrum
> **Principios:** (1) El PO solo habla con el Orquestador. (2) Memoria = archivos ("Engrams"). (3) **Economía de tokens**: nadie lee ni escribe más de lo necesario.

> **Fuente de verdad (no se duplica acá):** los system prompts de los agentes viven en
> `.claude/agents/nerv-*.md` y los protocolos en `nerv-protocols.md`. Este documento es el
> **mapa** de la arquitectura: §2 y §4 indexan y apuntan a esos archivos, no los copian.
> Editá el agente o el protocolo en su archivo; acá solo se toca el índice si cambia un rol o se agrega un protocolo.

---

## 0. Arquitectura de instalación

NERV vive en **dos niveles**, cableados por `install.sh` vía symlinks (este repo ES la fuente):

```
~/.claude/                          ← NIVEL GLOBAL (symlinks creados por install.sh)
├── nerv-protocols.md               ← Protocolos NERV (§4). Los agentes lo leen on-demand.
├── agents/                         ← Subagentes disponibles en cualquier directorio
│   ├── nerv-orquestador.md
│   ├── nerv-arquitecto.md
│   ├── nerv-backend.md
│   ├── nerv-mobile.md
│   ├── nerv-web.md
│   ├── nerv-desktop.md
│   ├── nerv-qa.md
│   ├── nerv-devops.md
│   └── nerv-security.md         ← AppSec dedicado, solo por pedido explícito del PO
└── commands/                       ← Slash commands (/nerv-init, /nerv-close, …)

~/.nerv/                            ← MEMORIA GLOBAL DE NERV (copiada, no symlink)
├── registry.md                     ← Registro de proyectos conocidos (la "agenda")
├── playbook.md                     ← Lecciones de proceso cross-proyecto (P-10)
└── archive/                        ← Logs rotados (no se leen en sesiones normales)

<repo-del-proyecto>/                ← NIVEL PROYECTO (uno por repo)
└── engram/
    ├── _state.md                   ← Estado vivo COMPACTO (lo único que se lee al boot)
    ├── 01_requirements.md
    ├── 02_architecture.md          ← ADRs
    ├── 03_backlog.md
    ├── 04_api_contracts.md
    ├── 05_handoff_log.md
    └── 06_retro.md                 ← Retro por sesión (P-10). Lecciones del proyecto.
```

**Por qué así:** los agentes y protocolos a nivel usuario funcionan en cualquier carpeta sin reinstalar nada; el registry da memoria entre proyectos; y el engram viaja con cada repo (versionado en Git). Como son symlinks al repo, editar acá impacta global sin reinstalar (salvo archivos nuevos: ahí corré `install.sh`).

---

## 1. Memoria Global: `~/.nerv/registry.md`

La "agenda" de proyectos del Orquestador. **Una fila por proyecto**, formato compacto:

```markdown
# NERV Registry

> 1 fila = 1 proyecto. El Orquestador lee SOLO este archivo al arrancar.
> "Estado" = una frase. El detalle vive en el engram de cada repo.

| Alias | Path local | Git remoto | Rama objetivo | Tracker (ADO/Jira) | Board | Figma | Última sesión | Estado (1 línea) |
|-------|-----------|------------|---------------|--------------------|-------|-------|---------------|------------------|
| | | | dev | | | | | |

## Notas por proyecto (máx. 3 líneas c/u, solo si son críticas)
### [alias]
-
```

**Alta de proyecto (intake):** cuando el PO dice "proyecto nuevo", el Orquestador pide en UN solo mensaje los campos de la fila (los que falten quedan como `—` y se completan después). Luego: agrega la fila, verifica/clona el repo en el path, y crea `engram/` si no existe.

---

## 2. Roles — índice de agentes

> Prompts deliberadamente cortos: cada token del system prompt se paga en **cada** invocación.
> El cuerpo completo de cada agente vive en su archivo (fuente de verdad); acá solo el índice.
> La autoridad detallada vive en los protocolos (`nerv-protocols.md`), que se cargan on-demand.

| # | Agente | Archivo (fuente de verdad) | Modelo | Responsabilidad en 1 línea |
|---|--------|-----------------------------|--------|----------------------------|
| 2.1 | nerv-orquestador | `.claude/agents/nerv-orquestador.md` | opus | Único contacto con el PO; registry, backlog, handoffs, git, trackers, retro de cierre. |
| 2.2 | nerv-arquitecto | `.claude/agents/nerv-arquitecto.md` | opus | ADRs, esquema PostgreSQL, contratos entre capas, revisión adversarial (P-11). |
| 2.3 | nerv-backend | `.claude/agents/nerv-backend.md` | sonnet | NestJS + PostgreSQL: módulos, endpoints, migraciones y tests sobre tickets. |
| 2.4 | nerv-mobile | `.claude/agents/nerv-mobile.md` | sonnet | React Native (Expo): pantallas, navegación, estado, consumo de API. |
| 2.5 | nerv-web | `.claude/agents/nerv-web.md` | sonnet | React (Vite) y Next.js (App Router): páginas, routing, estado, consumo de API. |
| 2.6 | nerv-desktop | `.claude/agents/nerv-desktop.md` | sonnet | Python + PySide6 multiplataforma: UI, empaquetado y distribución. |
| 2.7 | nerv-qa | `.claude/agents/nerv-qa.md` | sonnet | Audita contra criterios/ADRs/contratos; único que marca "Done"; aplica niveles (P-11). |
| 2.8 | nerv-devops | `.claude/agents/nerv-devops.md` | opus | DevOps & Seguridad operacional (consultivo): SaaS (multi-tenancy, CI/CD, IaC, observabilidad), secretos/hardening, ADRs de infra; revisión adversarial de seguridad inline (P-11). |
| 2.9 | nerv-security | `.claude/agents/nerv-security.md` | opus | AppSec dedicado — **solo por pedido explícito del PO**. Threat model formal, OWASP/ASVS, cripto, supply chain; informe por severidad, puede bloquear release. |

> Reglas transversales que cumplen todos los Tech Leads: trabajan SOLO sobre el ticket del
> handoff; leen su sección en `~/.nerv/playbook.md` antes de codear (P-1); entregan en estado
> "En revisión QA" (nunca "Done") con handoff de retorno estructurado (≤6 líneas): `estado` ·
> `archivos tocados` · `riesgos/caveats` · `cómo probar`. Cambios de stack/esquema ⇒ ADR (P-9).

---

## 3. Engram por proyecto (plantillas compactas)

### `engram/_state.md` — **la pieza clave de la economía de tokens**

```markdown
# STATE — [alias] · actualizado: [fecha]

**Sprint:** [n] — [objetivo en 1 frase]
**Rama activa:** [feature/...] → target: [dev]
**En curso:** T-XXX ([agente], [estado])  ·  T-YYY (...)
**Bloqueos:** [ninguno | T-XXX espera respuesta del PO sobre ...]
**Próximo paso sugerido:** [1 línea]
**Preguntas abiertas al PO:** [n] (detalle en 01_requirements.md §6)
```

> Máximo ~15 líneas, siempre. Es lo ÚNICO que el Orquestador lee al boot. Los demás archivos se abren solo cuando una tarea lo exige.

### `engram/01_requirements.md`

```markdown
# Requirements — [alias]

## 1. Visión (1 frase)
## 2. Funcionalidades (IN)
| ID | Funcionalidad | MoSCoW | Estado |
|----|---------------|--------|--------|
## 3. Fuera de alcance (OUT)
## 4. Reglas de negocio
| ID | Regla | Origen/fecha |
|----|-------|--------------|
## 5. Enlaces (espejo del registry: tracker, board, Figma)
## 6. Preguntas abiertas al PO
| # | Pregunta | De | Respuesta | Fecha |
|---|----------|----|-----------|-------|
```

### `engram/02_architecture.md`

```markdown
# Architecture — [alias]

## Stack
| Capa | Tech | Versión | ADR |
|------|------|---------|-----|

## DB (resumen vivo: tablas y relaciones clave)

## Índice ADRs
| # | Título | Estado | Fecha |
|---|--------|--------|-------|

---
## ADR-001: [título]
- **Estado:** Propuesto | Aceptado | Reemplazado por ADR-XXX
- **Contexto:** (2-3 líneas)
- **Decisión:** (1 frase imperativa)
- **Descartado:** (alternativa + porqué, 1-2 líneas)
- **Consecuencias:** (1-3 líneas)
```

### `engram/03_backlog.md`

```markdown
# Backlog — [alias]

> Estados: Backlog → To Do → En progreso → En revisión QA → Done | Bloqueado
> Solo nerv-qa escribe "Done". Mapear SIEMPRE el ID externo si existe.
> Niv (P-11, nivel de revisión QA): A=Advisory (default) · S=Strong · X=Adversarial.

## Sprint [n] — [objetivo]
| ID | Ext (ADO/Jira) | Tarea | Asignado | Estado | Niv | Criterios de aceptación | Rama |
|----|----------------|-------|----------|--------|-----|--------------------------|------|

## Veredictos QA
| Tarea | Veredicto | Defectos (si rechazo) | Fecha |
|-------|-----------|------------------------|-------|

## Deuda técnica
| ID | Descripción | Origen | Prioridad |
|----|-------------|--------|-----------|

## Histórico (sprints cerrados: 3 líneas c/u, máx. 5 sprints; el resto a ~/.nerv/archive/)
```

### `engram/04_api_contracts.md`

```markdown
# API Contracts — [alias]

## Convenciones
- Base URL: · JSON · fechas ISO 8601 UTC · Auth: [..]
- Error estándar: `{ "statusCode": 0, "message": "", "error": "" }`

## Índice
| Método | Ruta | Estado | Últ. cambio |
|--------|------|--------|-------------|

---
## [MÉTODO] /ruta
- **Auth:** Sí/No · **Ticket:** T-XXX
- **Request:** ```json {} ```
- **Response 200:** ```json {} ```
- **Errores:** (código + condición)
- **Notas FE:** (nulos posibles, paginación, casos límite)
```

### `engram/05_handoff_log.md`

```markdown
# Handoff Log — [alias]

> Entradas nuevas ARRIBA. Máx. 6 líneas por entrada. Al superar 30 entradas,
> el Orquestador mueve las más viejas a ~/.nerv/archive/[alias]-handoffs-[fecha].md

### [fecha hora] [de]→[a] T-XXX
- Entrega: ...
- Se espera: ...
- Pendientes: ...
```

### `engram/06_retro.md`

```markdown
# Retro — [alias]

> Entradas nuevas ARRIBA. Una por sesión, ≤8 líneas. La escribe el Orquestador en el
> cierre (P-10). Las lecciones de proceso que aplican a CUALQUIER proyecto se promueven
> a ~/.nerv/playbook.md; lo específico de este proyecto queda acá.

### [YYYY-MM-DD] Sprint [n]
- ✅ Salió bien: ...
- ⚠️ Salió mal: ...
- 🎯 Acción (qué cambia la próxima): ...
- ↗️ Promovido al playbook: [rol → lección | ninguno]
```

### `~/.nerv/playbook.md` — memoria de proceso global (cross-proyecto)

Vive del lado del usuario (como el registry), lo crea `install.sh` desde plantilla.
Lo nutren las retros (P-10); cada agente lee SOLO su sección antes de codear (P-1).

```markdown
# NERV Playbook — Lecciones de proceso (global)

> Cómo trabaja MEJOR el equipo, aprendido con el tiempo. Lo nutren las retros (P-10).
> Cada agente lee SOLO su sección antes de codear. Máx ~10 líneas por rol.
> Una lección entra solo si aplica a CUALQUIER proyecto. Obsoleta → se borra.

## Orquestador
## Arquitecto
## Backend
## Mobile
## Web
## Desktop
## QA
## Transversal
```

---

## 4. Protocolos NERV — índice

> **Fuente de verdad: `nerv-protocols.md`** (symlinkeado a `~/.claude/nerv-protocols.md`).
> Los agentes lo leen on-demand. Acá va SOLO el índice de una línea por protocolo; el cuerpo
> completo (reglas, pasos, excepciones) vive en ese archivo. Para editar un protocolo, tocá
> `nerv-protocols.md`, no este índice.

| Protocolo | Qué garantiza (1 línea) |
|-----------|--------------------------|
| **P-0** Memoria | Engram + registry son la única memoria; lo no escrito no existe. |
| **P-E** Economía de tokens | Lectura/escritura mínima; nada de pegar archivos; diffs, no regeneración. |
| **P-1** Handoff | Delegación válida = ticket con ID/criterios/rama/nivel + retorno estructurado. |
| **P-2** Rechazo de QA | Rechazo = lista de defectos; 2 rechazos ⇒ escalar al Arquitecto. |
| **P-3** Cero suposiciones | Ambigüedad ⇒ STOP y preguntar al PO; nada se inventa. |
| **P-4** Propiedad de escritura | Cada archivo tiene un dueño; cambios ajenos vía Orquestador. |
| **P-5** Cierre de sesión | Actualizar backlog/state/registry + retro + resumen al PO. |
| **P-6** Alta de proyecto | Intake en un mensaje; verificar repo; crear engram. |
| **P-7** Tracker externo | Espejar ADO/Jira; la descripción externa no reemplaza criterios. |
| **P-8** Flujo Git | Rama por ticket, PR sin merge sin orden; work-unit commits; chained PRs >400 líneas. |
| **P-9** Cadena de mando | El PO solo habla con el Orquestador. |
| **P-10** Retro de cierre | El Orquestador sintetiza lecciones; promueve las duraderas al playbook. |
| **P-11** Niveles de revisión | QA gradúa el rigor: Advisory / Strong / Adversarial según riesgo del ticket. |

---

## 5. Prompt de Ignición NERV

```text
NERV: inicia.

Asume el rol de nerv-orquestador y aplica los protocolos NERV (P-0 a P-11,
con P-E de economía de tokens) definidos en ~/.claude/nerv-protocols.md.

Boot:
1. Lee ~/.nerv/registry.md (si no existe, créalo desde la plantilla oficial
   y avísame que el registry está vacío).
2. Muéstrame la lista de proyectos conocidos (alias + estado de 1 línea) y
   pregúntame: "¿Con cuál trabajamos hoy, o damos de alta uno nuevo?"
3. Con el proyecto elegido: cd al path, lee SOLO engram/_state.md (créalo
   junto al resto del engram si no existe) y resume el estado en ≤5 líneas.
4. Pregúntame la tarea de hoy: [implementación nueva] | [tarea existente en
   ADO/Jira: pásame ID o URL] | [continuar pendiente].

No escribas código todavía. Recuerda: solo hablas conmigo tú; los demás
agentes trabajan vía handoff.
```

> Atajo: el slash command `/nerv-init` hace exactamente este boot.

---

## 6. Instalación (una sola vez)

```bash
./install.sh
```

Idempotente. Crea los symlinks globales desde este repo (agentes, slash commands y
`nerv-protocols.md` a `~/.claude/`) y copia `registry.md` + `playbook.md` a `~/.nerv/` si no
existen. **Editar los archivos del repo impacta global sin reinstalar** (son symlinks); solo
volvés a correr `install.sh` cuando agregás un archivo nuevo (agente o command).

Desde cualquier carpeta arrancás con `/nerv-init` (o el prompt de ignición de §5).

> **Requisitos opcionales según proyecto:** `git` + `gh` (GitHub) o `az` con extensión `azure-devops` (ADO), o el MCP de Atlassian/ADO conectado en Claude Code para P-7. Si faltan, NERV funciona igual y solo omite la sincronización externa avisándote.
