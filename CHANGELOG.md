# Changelog

Formato basado en [Keep a Changelog](https://keepachangelog.com/), versionado con [SemVer](https://semver.org/).

## [Unreleased]

### Added
- **Protocolo P-11 (Niveles de revisión / QA escalonado):** QA gradúa el rigor según riesgo del ticket — Advisory (cambio acotado), Strong (paths sensibles auth/seguridad/pagos/migraciones o diff >400 líneas, 4 lentes: riesgo/resiliencia/legibilidad/fiabilidad), Adversarial (architecture-critical o 2º intento, pasada hostil). Inspirado en el modelo de costo escalonado de gentle-ai, traducido a protocolo NERV. El Orquestador marca el nivel al delegar (P-1).
- **Handoff de retorno estructurado (P-1):** el contrato de retorno pasa de prosa libre a campos fijos (≤6 líneas): `estado` · `archivos tocados` · `riesgos/caveats` · `cómo probar`. Alineadas las líneas "Entrega =" de los 4 Tech Leads.
- **P-8 ampliado:** commit = unidad de trabajo (comportamiento + tests/docs juntos, rollback aislado, mensaje outcome-focused) y chained PRs cuando el forecast supera 400 líneas. Inspirado en las skills `work-unit-commits`/`chained-pr` de gentle-ai.
- Agente `nerv-desktop` (Tech Lead Desktop, `model: sonnet`): Python multiplataforma Windows/macOS con PySide6 por defecto, empaquetado y distribución (PyInstaller/Briefcase/Nuitka, firma/notarización). Sigue el flujo de tickets/handoffs como el resto del equipo (P-1/P-3/P-4/P-8); registrado en `install.sh`.
- Agente `nerv-web` (Tech Lead Web, `model: sonnet`): React (SPA/Vite) y Next.js (App Router). Separado del frontend móvil para mantener un stack por agente; registrado en `install.sh`.
- **Protocolo P-10 (Retro de cierre / aprendizaje continuo):** al cerrar sesión el Orquestador sintetiza handoffs + veredictos de QA en una retro (qué salió bien / mal / acción).
- `engram/06_retro.md` — log de retro por proyecto (entrada por sesión, ≤8 líneas). Sumado al bootstrap de `/nerv-new-project` (ahora 7 archivos).
- `~/.nerv/playbook.md` — memoria de proceso **global cross-proyecto**: las retros promueven ahí solo lecciones que aplican a cualquier proyecto, en la sección de cada rol. Plantilla `playbook.md` + wiring en `install.sh` (copia si no existe, como el registry).
- P-1 ahora exige que el receptor lea su sección del playbook antes de codear; los 6 agentes leen su sección. Así el equipo aprende de sus errores entre sesiones y proyectos.
- `CLAUDE.md` raíz (entry point para edición del framework — índice corto).
- `CHANGELOG.md` (este archivo).
- `ROADMAP.md` con plan de evolución hasta Fase 7.
- `install.sh` para reinstalación global vía symlinks (idempotente).
- Campo `model:` en frontmatter de los 5 agentes:
  - `nerv-orquestador`, `nerv-arquitecto` → `opus`
  - `nerv-backend`, `nerv-frontend`, `nerv-qa` → `sonnet`
- Slash commands en `.claude/commands/`:
  - `/nerv-init` — arranca sesión NERV (movido al repo, antes vivía solo en global)
  - `/nerv-status` — resumen vivo del proyecto activo
  - `/nerv-handoff <agente> <ticket>` — entrada en handoff_log + invocación P-1
  - `/nerv-adr "<título>"` — crea ADR con numeración correlativa
  - `/nerv-new-project` — intake guiado P-6 (alta de proyecto)
  - `/nerv-close` — ejecuta cierre P-5 explícito
  - `/nerv-ticket "<descripción>"` — crea ticket en backlog
- Hooks de Claude Code (`~/.claude/settings.json`):
  - `SessionStart` — inyecta contenido de `engram/_state.md` si existe en CWD
  - `Stop` — recuerda `/nerv-close` si la sesión tocó un engram

### Changed
- **`nerv-framework-v2.md` deja de duplicar contenido (fin del drift):** §2 (7 agentes embebidos) y §4 (protocolos embebidos) se colapsan a **índices con punteros** a la fuente de verdad (`.claude/agents/nerv-*.md` y `nerv-protocols.md`). §6 reescrito al flujo real de `install.sh` (symlinks), §0 y el prompt de ignición apuntan a `~/.claude/nerv-protocols.md`. Las plantillas de engram (§3) y registry (§1) quedan, son su hogar canónico. Un cambio de agente/protocolo ya no obliga a editar en dos lados.
- `nerv-qa` ahora **gradúa el rigor por nivel de revisión (P-11)** en vez de aplicar siempre el mismo esfuerzo; las verificaciones (a–d) se reordenan en 4 lentes (riesgo/resiliencia/legibilidad/fiabilidad). Veredicto binario y flujo P-2 intactos.
- `nerv-arquitecto` corre la revisión adversarial (P-11) en cambios architecture-critical y como árbitro tras 2 rechazos.
- Tech Leads (backend/mobile/web/desktop) emiten **handoff de retorno estructurado**; el Orquestador marca el nivel de revisión al delegar.
- `nerv-frontend` queda acotado a **React Native** (un stack por agente). El trabajo web/Next.js migra al nuevo `nerv-web`.
- `nerv-frontend` **renombrado a `nerv-mobile`** (más representativo ahora que es RN-only). Actualizado en `install.sh`, `nerv-framework-v2.md` y referencias del equipo.

### Fixed
- **Incongruencias de naming/conteo en el entry-point `CLAUDE.md`** (se inyecta cada sesión): "5 agentes/frontend" → 7 agentes (mobile/web/desktop); "P-0 a P-9" → "P-0 a P-11"; lista de modelos Sonnet actualizada; la fila "variante de stack" deja de recomendar el patrón rol+variante (rechazado) y refleja naming plano.
- `nerv-ticket.md` y `nerv-new-project.md` sugerían agentes/stacks inexistentes (`nerv-frontend`, `nerv-desktop-*`, `tauri`, `pyqt`) → actualizados a los agentes reales (mobile/web/desktop-PySide6).
- **Loop P-11 cerrado:** P-1 y QA referían un "nivel de revisión" del ticket que no tenía dónde vivir. Agregada columna **Niv** (A/S/X) al template de backlog (§3), al `/nerv-ticket` y al `/nerv-handoff` (lo porta en el log y en la invocación). Ahora QA puede leer el nivel del ticket.

### Removed
- Carpeta huérfana `agents/` en la raíz del repo (duplicado obsoleto previo a la mudanza a `.claude/agents/`; no estaba cableada a `install.sh`).

---

## [2.0.0] — 2026-06-11

### Added
- Arquitectura v2 documentada en `nerv-framework-v2.md`.
- 5 agentes especializados: orquestador, arquitecto, backend, frontend, qa.
- 10 protocolos: P-0 (memoria), P-E (economía de tokens), P-1 (handoff), P-2 (rechazo QA), P-3 (cero suposiciones), P-4 (propiedad de escritura), P-5 (cierre), P-6 (alta de proyecto), P-7 (tracker externo), P-8 (flujo git), P-9 (cadena de mando).
- Registry global en `~/.nerv/registry.md`.
- Engram por proyecto (6 archivos: state, requirements, architecture, backlog, contracts, handoff_log).
- Instalación global vía `~/.claude/agents/` + `~/.claude/nerv-protocols.md`.
