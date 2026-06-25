# NERV — Roadmap de Evolución v3 (decisiones firmes)

> **Contexto verificado:**
> - Operador: solo (vos) + agentes IA. No hay equipo humano.
> - Proyectos: 1+ activo hoy, multi-proyecto futuro confirmado.
> - Stacks reales en uso:
>   - **Backend siempre NestJS** (constante)
>   - **Web frontend:** Next.js / React
>   - **Mobile:** React Native
>   - **Desktop:** Tauri+Rust o PyQt/PySide (Python)
> - Producción: parcial (algunos en prod con flag por proyecto).
> - Madurez de uso: probado poco, funciona bien — el roadmap es ADITIVO, no de rescate.
> - Destino: open source eventual.
>
> **Decisiones lockeadas (sección final eliminada — todas cerradas):**
> 1. Python = stack de **desktop con PyQt/PySide**, no backend web.
> 2. Tracker: **ADO + Jira** ambos soportados (P-7 sin cambios).
> 3. Hooks de Claude Code: **SÍ**, parte del scope.
> 4. Modelos por agente: **Opus** para orquestador + arquitecto · **Sonnet** para backend + frontend + QA.
> 5. CLAUDE.md raíz: **entry point cortísimo** (índice), el detalle vive en otros archivos.
>
> **Engram MCP — modo PARALELO.** Archivos engram/*.md = verdad commitable. Engram MCP = índice + persistencia tras compactación + búsqueda cross-proyecto. No hay forma de tener "versionable + sobrevive compactación + búsqueda semántica" en una sola fuente.

---

## Resumen ejecutivo

```
PRIORIDAD CRÍTICA  →  Fase 0 + Fase 1 + Fase 2  (la base sin la que nada escala)
PRIORIDAD ALTA     →  Fase 3 + Fase 4          (calidad + multistack ya en prod)
PRIORIDAD MEDIA    →  Fase 5 + Fase 6          (especialistas + métricas)
CUANDO PUBLIQUES   →  Fase 7                   (open source readiness)
```

---

## Fase 0 — Foundation del repo NERV (≈ 1 día)

**Por qué primero:** lo vas a evolucionar seguido. Sin esto, cada vez que editás NERV el contexto se reconstruye en tu cabeza.

| # | Entregable | Por qué |
|---|------------|---------|
| 0.1 | `CLAUDE.md` raíz del repo NERV (**entry point cortísimo**) | Solo índice. "Este es el repo NERV, leé `nerv-framework-v2.md` para arquitectura, `nerv-protocols.md` para protocolos, `ROADMAP.md` para evolución". Sin detalle. |
| 0.2 | `CHANGELOG.md` arrancando en v2.0 | Cada cambio futuro es trazable. Crítico antes de open source. |
| 0.3 | `install.sh` que recrea symlinks como hicimos hoy | Reinstalar en otra máquina = 1 comando. |
| 0.4 | Agregar campo `model` al frontmatter de cada agente | `nerv-orquestador.md` y `nerv-arquitecto.md` → `model: opus`. Backend, frontend, QA → `model: sonnet`. |

**No incluye README/LICENSE/CONTRIBUTING todavía** — eso es Fase 7 (open source readiness). Si los hacés ahora se desactualizan antes de tener algo que publicar.

**Done cuando:** clonás el repo limpio, corrés `install.sh`, abrís Claude en cualquier carpeta, `/nerv-init` arranca.

---

## Fase 1 — Slash commands + hooks (≈ 2-3 días)

**Por qué:** hoy todo el flujo es convención conversacional. Eso depende de que el orquestador "se acuerde". Falla. Solo IA + sin equipo humano = sin red de seguridad social, necesitás red mecánica.

| # | Entregable | Detalle |
|---|------------|---------|
| 1.1 | `/nerv-status` | Resumen vivo del proyecto activo (lee state.md + último handoff). Formato fijo. |
| 1.2 | `/nerv-handoff <agente> <ticket>` | Genera entrada en handoff_log con plantilla. Reemplaza convención P-1. |
| 1.3 | `/nerv-adr "<título>"` | Crea ADR vacío con numeración correlativa en 02_architecture.md. |
| 1.4 | `/nerv-new-project` | Intake guiado P-6 con todos los campos del registry. |
| 1.5 | `/nerv-close` | Ejecuta P-5 explícito: update state.md, registry, handoff_log con cierre. |
| 1.6 | Hooks de Claude Code (varios) | Hook `Stop` recuerda `/nerv-close` si la sesión NERV termina sin cierre. Hook `SessionStart` carga el contexto NERV si detecta proyecto del registry. Hook `UserPromptSubmit` advierte si se está pidiendo código sin pasar por el flujo. |
| 1.7 | `/nerv-ticket "<descripción>"` | Crea ticket en backlog con plantilla (criterios + rama + estado). |

**Done cuando:** una sesión NERV completa (boot → handoff → entrega → QA → cierre) usa solo comandos, sin que tengas que recordar nada.

---

## Fase 2 — Engram MCP en paralelo (≈ 4-5 días)

**Modelo:**
```
                  ESCRITURA                LECTURA
state.md          mem_save (mirror)        primaria
backlog.md        mem_save (mirror)        primaria
architecture.md   mem_save (mirror)        primaria
handoff_log.md    -                        primaria (no se mirrorea, es ruido)
Engram MCP        mem_save desde agentes   secundaria (recovery + search)
```

**Por qué este modelo:** archivos son la fuente versionable (criterio #1 tuyo); Engram MCP es el índice que (a) sobrevive compactaciones, (b) habilita búsqueda semántica cross-proyecto (criterios #2 y #3 tuyos).

| # | Entregable | Detalle |
|---|------------|---------|
| 2.1 | Protocolo **P-10: Persistencia híbrida** | Define qué se mirrorea, con qué `topic_key`, cuándo. |
| 2.2 | Orquestador hace `mem_save` con `topic_key: nerv/{alias}/state` en cada `/nerv-close` | Recupera estado post-compactación. |
| 2.3 | Tech Leads hacen `mem_save` tras decisión técnica no obvia (`nerv/{alias}/decisions/T-XXX`) | Aprendizajes cross-sesión y cross-proyecto. |
| 2.4 | Boot del orquestador: `mem_context` ANTES de leer state.md | Sesión arranca con memoria caliente. |
| 2.5 | `/nerv-recall <query>` ejecuta `mem_search` filtrando por `nerv/*` | "¿Cómo resolvimos auth en otro proyecto?" → respuesta real, no inventada. |
| 2.6 | Protocolo de sync inverso: cuando se hace `/nerv-close`, validar que mem_save no contradiga al archivo | Detector de drift entre fuentes. |

**Done cuando:** matás Claude a mitad de sprint, reabrís 2 días después, orquestador recupera estado desde Engram + state.md y sabe exactamente dónde retomar.

---

## Fase 3 — Gates de calidad reales (≈ 4-5 días)

**Recalibrado por contexto:** sos solo + IA. "Peer review humano" no aplica — pero entre agentes IA con perspectivas distintas SÍ sirve como **detector de drift de contratos**. Backend revisa que Mobile/Web esté consumiendo bien el contrato que él publicó. No es ceremonia social, es checksum cruzado.

| # | Entregable | Detalle |
|---|------------|---------|
| 3.1 | **P-11: Testing obligatorio** | Niveles por capa con framework declarado por proyecto en `02_architecture.md`. Coverage mínimo configurable. QA no aprueba sin esto. |
| 3.2 | **P-12: Cross-check de contratos** | Antes de QA: Backend verifica que Mobile/Web consume bien los contratos; Mobile/Web verifica que el shape recibido coincide con lo declarado. |
| 3.3 | **P-13: Hotfix / Emergencia** | Aplica solo a proyectos con flag `en_prod: true` en registry. Carril: rama `hotfix/*` desde main, QA mínimo (smoke + criterio), PR fast-track, ticket retroactivo. |
| 3.4 | **P-14: Spike / Investigación** | Ticket tipo "spike" con timebox. Salida = ADR o documento. No produce código de producción. |
| 3.5 | `engram/06_quality.md` | Coverage actual, tests rotos conocidos, deuda de calidad. Memoria entre tickets para el QA. |

**Done cuando:** ningún Tech Lead pasa a QA sin (a) tests del nivel declarado, (b) cross-check de contratos si tocó interfaces. Hotfix tiene su carril propio en proyectos productivos.

---

## Fase 4 — Multi-stack real (≈ 1-2 semanas) **← SUBE EN PRIORIDAD**

**Por qué sube:** dijiste que ya tenés NestJS + RN + Next.js + Tauri/Rust + Python en proyectos prod. NERV solo cubre NestJS+RN. Ya estás operando fuera del framework para los otros — eso es deuda activa, no premature optimization.

**Arquitectura propuesta (corregida con datos reales):**

```
Rol genérico (constante)              Stack específico (variable)
─────────────────────────             ──────────────────────────
nerv-backend                          → nerv-backend (NestJS — único stack, sin variantes)

nerv-frontend  → SE DESDOBLÓ en:      → nerv-mobile (React Native — ✅ existe)
                                      → nerv-web    (React/Vite · Next.js — ✅ existe)

nerv-desktop  (nuevo rol)             → nerv-desktop (Python + PySide6 — ✅ existe)
                                      → nerv-desktop-tauri (Tauri + Rust — pendiente)
```

**Estado real (actualizado):** el desdoblamiento del frontend YA se hizo, pero con **nombres planos por stack** (`nerv-mobile`, `nerv-web`, `nerv-desktop`) en vez del patrón `rol-variante` (`nerv-frontend-rn`, etc.). Decisión: un agente = un stack, sin rol "thin" intermedio. Más simple hoy; si un mismo rol necesita 2+ variantes reales (ej. desktop Python **y** Tauri/Rust), ahí se evalúa el refactor rol+variante de 4.1/4.2. Items 4.3, 4.5 y 4.6 quedan **entregados** con este naming.

**Nota clave:** backend NO se desdobla porque siempre usás NestJS.

| # | Entregable | Detalle |
|---|------------|---------|
| 4.1 | Refactor: separar autoridad/responsabilidad (rol) de implementación (stack) | El rol queda en un agente "thin"; el stack en variantes. |
| 4.2 | Campo `stack: { backend, frontend?, desktop? }` en registry | Orquestador delega al agente correcto según el proyecto. |
| 4.3 | ✅ `nerv-web` (React/Vite · Next.js) | Entregado. Reemplaza el `nerv-frontend-web` planeado. |
| 4.4 | `nerv-desktop-tauri` (Tauri + Rust) | Pendiente. Reglas de bundling, IPC, security en Rust. |
| 4.5 | ✅ `nerv-desktop` (PySide6) | Entregado como `nerv-desktop` (sin sufijo). Packaging PyInstaller/Briefcase/Nuitka, firma/notarización. |
| 4.6 | ✅ Renombrar `nerv-frontend` → `nerv-mobile` | Entregado. Variante mobile explícita (nombre plano, no `-rn`). |
| 4.7 | Plantillas de engram parametrizadas | Ej. `04_api_contracts.md` cambia formato entre REST y GraphQL si corresponde. |

**Por ahora NO se agregan:** Go, .NET, PHP, FastAPI/Django, Vue. Si aparecen, el patrón rol+variante ya está listo.

**Done cuando:** alta de proyecto con cualquier combo de los stacks listados invoca a los agentes correctos sin que vos lo digas.

---

## Fase 5 — Especialistas (≈ 1-2 semanas cada uno, NO simultáneos)

**Regla:** no agregués todos a la vez. Cada agente nuevo que no se invoca seguido es ruido en la cabeza del orquestador.

| Agente | Cuándo lo necesitás | Esfuerzo |
|--------|---------------------|----------|
| ✅ `nerv-devops` | **Entregado.** DevOps **&amp; Seguridad** fusionados (`model: opus`, consultivo): SaaS/multi-tenancy, CI/CD, IaC, observabilidad + postura de seguridad y revisión adversarial (P-11). Absorbe el `nerv-security` que estaba planeado aparte. | M |
| `nerv-data` | Cuando tengas queries pesadas o migraciones complejas en NestJS+PG. Hoy el arquitecto improvisa. | S |

**P-15: Reglas de invocación de especialistas** | XS pero crítica — sin esto los agentes nuevos se vuelven cargo cult.

**Recomendación de orden:** DevOps+Seguridad ya está; Data al final (es el menos urgente).

---

## Fase 6 — Observabilidad cross-proyecto (≈ 1 semana)

**Por qué tiene sentido en tu caso:** vas a tener múltiples proyectos. Sin observabilidad cross, vas a olvidarte de proyectos que tienen bloqueos viejos.

| # | Entregable | Detalle |
|---|------------|---------|
| 6.1 | `/nerv-metrics` | Por proyecto: cycle time, % rechazos QA, tiempo en bloqueo, edad promedio del backlog. Lee de engram. |
| 6.2 | `/nerv-health` | Semáforo cross-proyecto: verde/amarillo/rojo por proyecto (activo, bloqueos viejos, última sesión hace cuánto). |
| 6.3 | `engram/07_metrics.md` actualizado al cierre de sprint | Tendencias por sprint. |
| 6.4 | Reporte semanal automático | Hook `SessionStart` que dice "proyectos con bloqueos > 5 días: X, Y". |

**Done cuando:** cada lunes sabés en qué proyecto enfocarte sin abrir ninguno.

---

## Fase 7 — Open source readiness (cuando publiques)

**No hacer antes de tiempo.** Si las docs se escriben antes que el framework se estabilice, se desactualizan y das mala imagen.

| # | Entregable | Detalle |
|---|------------|---------|
| 7.1 | `README.md` público con value prop, instalación, quickstart | El que vendés. |
| 7.2 | `LICENSE` (recomiendo MIT o Apache 2.0) | Sin esto nadie puede usarlo legalmente. |
| 7.3 | `CONTRIBUTING.md` | Cómo proponer cambios, convenciones de PR. |
| 7.4 | Sitio de docs (Docusaurus / Vitepress / similar) | Para framework con varios protocolos y agentes, una página README no alcanza. |
| 7.5 | Versionado semántico + releases en GitHub | Para que los usuarios elijan versión. |
| 7.6 | Tests del framework (?) | Discutible: ¿cómo testeás un framework de IA? Probablemente regression cases manuales. |

**Done cuando:** un desarrollador random clona NERV, sigue el README y arranca a usarlo sin preguntarte nada.

---

## Continuo (no es fase, es disciplina)

- **Rotación automática del archive** (P-E.4): hook que mueve handoffs > 30 o sprints cerrados > 5 a `~/.nerv/archive/`.
- **Templates evolutivos**: cuando algo se repite en 3+ proyectos, sube al template oficial.
- **MCP integrations**: Figma MCP (frontend), GitHub MCP (PR review), ADO MCP (cuando lo uses).
- **CHANGELOG.md** actualizado con cada cambio relevante.

---

## Priorización recomendada (basada en TU contexto)

```
1.  Fase 0           ← ya, antes que nada (1 día)
2.  Fase 1           ← inmediato después (lo más impacto/esfuerzo)
3.  Fase 2           ← cuando 1 esté estable (memoria es tu temor declarado)
4.  USAR NERV en 2-3 sesiones reales para validar las fases 0-2
5.  Fase 3           ← gates de calidad antes de meter más proyectos
6.  Fase 4           ← cuando aparezca tu próximo proyecto no-NestJS+RN
7.  Fase 5 (DevOps)  ← cuando empieces a deployar seguido
8.  Fase 6           ← cuando tengas 3+ proyectos activos
9.  Fase 7           ← cuando sientas que está sólido y querés publicar
```

**Regla de oro:** después de cada fase, USAR. Si construís 4 fases sin usarlas, estás optimizando un framework para nadie.

---

## Decisiones cerradas

Todas las decisiones del v2 quedaron lockeadas (ver header del documento). El roadmap está firme y listo para ejecución por fases.

**Próximo paso natural:** arrancar Fase 0 (1 día de trabajo) o directamente arrancar Fase 0 + Fase 1 juntas si tenés tiempo de dedicación.
