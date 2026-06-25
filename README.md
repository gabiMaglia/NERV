# NERV — Framework Multi-Agente para Claude Code

NERV es un equipo de agentes especializados que trabaja **como un equipo de software real**: un Orquestador (Scrum Master) que es el único que habla con vos, Tech Leads por stack, un Arquitecto y un QA. Coordinan vía handoffs, dejan memoria en archivos versionados ("Engrams") y **aprenden de sus errores entre sesiones**.

Tres principios lo sostienen:

1. **El PO (vos) solo habla con el Orquestador.** El resto del equipo trabaja por delegación.
2. **La memoria son archivos.** Lo que no está escrito en el Engram, no existe.
3. **Economía de tokens.** Nadie lee ni escribe más de lo necesario.

> Pensado para **Claude Code (CLI)** a nivel de usuario: se instala una vez y funciona en cualquier carpeta.

---

## Requisitos

- **[Claude Code](https://claude.com/claude-code)** instalado.
- `bash` (para `install.sh`).
- *(Opcional)* `git` + `gh` (GitHub) o `az` con la extensión `azure-devops`, o el MCP de Atlassian/ADO, si querés sincronizar tickets con un tracker externo (protocolo P-7). Si faltan, NERV funciona igual y omite la sincronización.

---

## Instalación

```bash
git clone https://github.com/<usuario>/NERV.git
cd NERV
./install.sh
```

`install.sh` es **idempotente** (corrélo las veces que quieras). Crea symlinks globales desde este repo hacia `~/.claude/`:

- `~/.claude/agents/nerv-*.md` — los 8 agentes
- `~/.claude/commands/nerv-*.md` — los slash commands
- `~/.claude/nerv-protocols.md` — los protocolos

Y copia (sin sobrescribir si ya existen) tu memoria global en `~/.nerv/`:

- `~/.nerv/registry.md` — la "agenda" de tus proyectos
- `~/.nerv/playbook.md` — lecciones de proceso cross-proyecto

> Como son **symlinks**, editar los archivos del repo impacta global sin reinstalar. Solo volvés a correr `install.sh` cuando **agregás un archivo nuevo** (un agente o command que no existía).

---

## Uso

Desde **cualquier** carpeta (idealmente el repo de tu proyecto), arrancá:

```
/nerv-init
```

El Orquestador hace el boot: lee tu registry, te muestra los proyectos conocidos, te deja elegir uno (o dar de alta uno nuevo) y te pregunta la tarea de hoy. A partir de ahí trabajás hablando solo con él.

### Slash commands

| Command | Para qué |
|---------|----------|
| `/nerv-init` | Arranca la sesión NERV (boot del Orquestador). |
| `/nerv-new-project` | Da de alta un proyecto nuevo (intake guiado). |
| `/nerv-status` | Resumen vivo del proyecto activo. |
| `/nerv-ticket "<desc>"` | Crea un ticket en el backlog. |
| `/nerv-handoff <agente> <ticket>` | Delega un ticket a un Tech Lead (P-1). |
| `/nerv-adr "<título>"` | Crea un ADR (decisión de arquitectura). |
| `/nerv-close` | Cierra la sesión: actualiza memoria + retro. |

---

## El equipo

| Agente | Modelo | Rol |
|--------|--------|-----|
| `nerv-orquestador` | Opus | Único contacto con el PO. Registry, backlog, handoffs, git, trackers, retro. |
| `nerv-arquitecto` | Opus | ADRs, esquema PostgreSQL, contratos entre capas, revisión adversarial. |
| `nerv-backend` | Sonnet | NestJS + PostgreSQL: módulos, endpoints, migraciones, tests. |
| `nerv-mobile` | Sonnet | React Native (Expo). |
| `nerv-web` | Sonnet | React (Vite) y Next.js (App Router). |
| `nerv-desktop` | Sonnet | Python + PySide6 multiplataforma (Windows/macOS). |
| `nerv-qa` | Sonnet | Audita contra criterios/ADRs/contratos. Único que marca "Done". |
| `nerv-devops` | Opus | DevOps & Seguridad (consultivo): SaaS, multi-tenancy, CI/CD, IaC, observabilidad, postura de seguridad. |

El stack por defecto es **React Native · NestJS + PostgreSQL**, pero cada Tech Lead cubre su stack. Cambiar de stack o tecnología requiere un ADR.

---

## Protocolos

El comportamiento del equipo está gobernado por protocolos cortos (`nerv-protocols.md`):

- **P-0** Memoria · **P-E** Economía de tokens
- **P-1** Handoff · **P-2** Rechazo de QA · **P-3** Cero suposiciones
- **P-4** Propiedad de escritura · **P-5** Cierre de sesión · **P-6** Alta de proyecto
- **P-7** Tracker externo (ADO/Jira) · **P-8** Flujo Git · **P-9** Cadena de mando
- **P-10** Retro de cierre (aprendizaje continuo)
- **P-11** Niveles de revisión (QA escalonado: Advisory / Strong / Adversarial)

---

## Memoria por proyecto (Engram)

Cada repo donde trabajás lleva una carpeta `engram/` versionada en Git:

```
engram/
├── _state.md            # Estado vivo compacto (lo único que se lee al boot)
├── 01_requirements.md
├── 02_architecture.md   # ADRs
├── 03_backlog.md
├── 04_api_contracts.md
├── 05_handoff_log.md
└── 06_retro.md          # Retro por sesión (P-10)
```

Como viaja con el repo, cualquiera que clone tu proyecto hereda el contexto completo del equipo.

---

## Cómo está organizado este repo

| Archivo | Qué es |
|---------|--------|
| `nerv-framework-v2.md` | Mapa de la arquitectura (apunta a agentes y protocolos, no los copia). |
| `nerv-protocols.md` | Los protocolos — **fuente de verdad**. |
| `.claude/agents/nerv-*.md` | Los 8 agentes — **fuente de verdad**. |
| `.claude/commands/nerv-*.md` | Los slash commands. |
| `registry.md` / `playbook.md` | Plantillas (el real vive en `~/.nerv/`). |
| `install.sh` | Instalación global vía symlinks. |
| `ROADMAP.md` · `CHANGELOG.md` | Evolución y cambios versionados. |

---

## Desinstalar

NERV solo crea symlinks; borralos y listo (tu memoria en `~/.nerv/` no se toca):

```bash
rm ~/.claude/agents/nerv-*.md ~/.claude/commands/nerv-*.md ~/.claude/nerv-protocols.md
```

---

## Licencia

MIT.
