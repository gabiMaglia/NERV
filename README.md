# NERV — Multi-Agent Framework for Claude Code

**English** · [Español](#nerv--framework-multiagente-para-claude-code)

NERV is a team of specialized agents that works **like a real software team**: an Orchestrator (Scrum Master) who is the only one that talks to you, Tech Leads per stack, an Architect, a DevOps/Security engineer and a QA. They coordinate via handoffs, leave memory in versioned files ("Engrams") and **learn from their mistakes across sessions**.

Three principles hold it together:

1. **The PO (you) only talks to the Orchestrator.** The rest of the team works by delegation.
2. **Memory is files.** What isn't written in the Engram doesn't exist.
3. **Token economy.** Nobody reads or writes more than necessary.

> Built for **Claude Code (CLI)** at user level: install once, works in any folder.

## Requirements

- **[Claude Code](https://claude.com/claude-code)** installed.
- `bash` (for `install.sh`).
- *(Optional)* `git` + `gh` (GitHub) or `az` with the `azure-devops` extension, or the Atlassian/ADO MCP, if you want to sync tickets with an external tracker (protocol P-7). Without them NERV still works and just skips the sync.

## Install

```bash
git clone https://github.com/gabiMaglia/NERV.git
cd NERV
./install.sh
```

`install.sh` is **idempotent** (run it as many times as you want). It creates global symlinks from this repo into `~/.claude/`:

- `~/.claude/agents/nerv-*.md` — the 10 agents
- `~/.claude/commands/nerv-*.md` — the slash commands
- `~/.claude/nerv-protocols.md` — the protocols

And it copies (without overwriting if they already exist) your global memory into `~/.nerv/`:

- `~/.nerv/registry.md` — the "address book" of your projects
- `~/.nerv/playbook.md` — cross-project process lessons

> Since they are **symlinks**, editing the repo files takes effect globally without reinstalling. You only re-run `install.sh` when you **add a new file** (an agent or command that didn't exist).

## Usage

From **any** folder (ideally your project repo), start with:

```
/nerv-init
```

The Orchestrator boots: reads your registry, shows the known projects, lets you pick one (or onboard a new one) and asks for today's task. From there you work talking only to it.

### Slash commands

| Command | Purpose |
|---------|---------|
| `/nerv-init` | Start the NERV session (Orchestrator boot). |
| `/nerv-new-project` | Onboard a new project (guided intake). |
| `/nerv-status` | Live summary of the active project. |
| `/nerv-ticket "<desc>"` | Create a backlog ticket. |
| `/nerv-handoff <agent> <ticket>` | Delegate a ticket to a Tech Lead (P-1). |
| `/nerv-adr "<title>"` | Create an ADR (architecture decision). |
| `/nerv-close` | Close the session: update memory + retro. |

## The team

| Agent | Model | Role |
|-------|-------|------|
| `nerv-orquestador` | Opus | Sole contact with the PO. Registry, backlog, handoffs, git, trackers, retro. |
| `nerv-arquitecto` | Opus | ADRs, PostgreSQL schema, cross-layer contracts, adversarial review. |
| `nerv-backend` | Sonnet | NestJS + PostgreSQL: modules, endpoints, migrations, tests. |
| `nerv-mobile` | Sonnet | React Native (Expo). |
| `nerv-web` | Sonnet | React (Vite) and Next.js (App Router). |
| `nerv-desktop` | Sonnet | Cross-platform Python + PySide6 (Windows/macOS). |
| `nerv-qa` | Sonnet | Audits against criteria/ADRs/contracts. Sole authority to mark "Done". |
| `nerv-devops` | Opus | DevOps & operational security (advisory): SaaS, multi-tenancy, CI/CD, IaC, observability, secrets/hardening. |
| `nerv-security` | Opus | Dedicated AppSec — **explicit request only**. Formal threat model, OWASP/ASVS, crypto, supply chain. |
| `nerv-ai` | Sonnet | AI/multi-agent Tech Lead (product): prompt engineering, RAG, evals, agent loops/harness, orchestration, cost/latency, guardrails. |

The default stack is **React Native · NestJS + PostgreSQL**, but each Tech Lead covers its stack. Changing stack or technology requires an ADR.

## Protocols

The team's behavior is governed by short protocols (`nerv-protocols.md`):

- **P-0** Memory · **P-E** Token economy
- **P-1** Handoff · **P-2** QA rejection · **P-3** Zero assumptions
- **P-4** Write ownership · **P-5** Session close · **P-6** Project onboarding
- **P-7** External tracker (ADO/Jira) · **P-8** Git flow · **P-9** Chain of command
- **P-10** Closing retro (continuous learning)
- **P-11** Review levels (tiered QA: Advisory / Strong / Adversarial)

## Per-project memory (Engram)

Every repo you work in carries a versioned `engram/` folder:

```
engram/
├── _state.md            # Compact live state (the only thing read at boot)
├── 01_requirements.md
├── 02_architecture.md   # ADRs
├── 03_backlog.md
├── 04_api_contracts.md
├── 05_handoff_log.md
└── 06_retro.md          # Per-session retro (P-10)
```

Since it travels with the repo, anyone who clones your project inherits the team's full context.

## Uninstall

NERV only creates symlinks; delete them and you're done (your memory in `~/.nerv/` is untouched):

```bash
rm ~/.claude/agents/nerv-*.md ~/.claude/commands/nerv-*.md ~/.claude/nerv-protocols.md
```

## License

MIT.

---

# NERV — Framework Multiagente para Claude Code

[English](#nerv--multi-agent-framework-for-claude-code) · **Español**

NERV es un equipo de agentes especializados que trabaja **como un equipo de software real**: un Orquestador (Scrum Master) que es el único que habla con vos, Tech Leads por stack, un Arquitecto, un DevOps/Seguridad y un QA. Coordinan vía handoffs, dejan memoria en archivos versionados ("Engrams") y **aprenden de sus errores entre sesiones**.

Tres principios lo sostienen:

1. **El PO (vos) solo habla con el Orquestador.** El resto del equipo trabaja por delegación.
2. **La memoria son archivos.** Lo que no está escrito en el Engram, no existe.
3. **Economía de tokens.** Nadie lee ni escribe más de lo necesario.

> Pensado para **Claude Code (CLI)** a nivel de usuario: se instala una vez y funciona en cualquier carpeta.

## Requisitos

- **[Claude Code](https://claude.com/claude-code)** instalado.
- `bash` (para `install.sh`).
- *(Opcional)* `git` + `gh` (GitHub) o `az` con la extensión `azure-devops`, o el MCP de Atlassian/ADO, si querés sincronizar tickets con un tracker externo (protocolo P-7). Si faltan, NERV funciona igual y omite la sincronización.

## Instalación

```bash
git clone https://github.com/gabiMaglia/NERV.git
cd NERV
./install.sh
```

`install.sh` es **idempotente** (corrélo las veces que quieras). Crea symlinks globales desde este repo hacia `~/.claude/`:

- `~/.claude/agents/nerv-*.md` — los 10 agentes
- `~/.claude/commands/nerv-*.md` — los slash commands
- `~/.claude/nerv-protocols.md` — los protocolos

Y copia (sin sobrescribir si ya existen) tu memoria global en `~/.nerv/`:

- `~/.nerv/registry.md` — la "agenda" de tus proyectos
- `~/.nerv/playbook.md` — lecciones de proceso cross-proyecto

> Como son **symlinks**, editar los archivos del repo impacta global sin reinstalar. Solo volvés a correr `install.sh` cuando **agregás un archivo nuevo** (un agente o command que no existía).

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
| `nerv-devops` | Opus | DevOps & Seguridad operacional (consultivo): SaaS, multi-tenancy, CI/CD, IaC, observabilidad, secretos/hardening. |
| `nerv-security` | Opus | AppSec dedicado — **solo por pedido explícito**. Threat model formal, OWASP/ASVS, cripto, supply chain. |
| `nerv-ai` | Sonnet | Tech Lead IA/multiagente (producto): prompt engineering, RAG, evals, agent loops/harness, orquestación, costo/latencia, guardrails. |

El stack por defecto es **React Native · NestJS + PostgreSQL**, pero cada Tech Lead cubre su stack. Cambiar de stack o tecnología requiere un ADR.

## Protocolos

El comportamiento del equipo está gobernado por protocolos cortos (`nerv-protocols.md`):

- **P-0** Memoria · **P-E** Economía de tokens
- **P-1** Handoff · **P-2** Rechazo de QA · **P-3** Cero suposiciones
- **P-4** Propiedad de escritura · **P-5** Cierre de sesión · **P-6** Alta de proyecto
- **P-7** Tracker externo (ADO/Jira) · **P-8** Flujo Git · **P-9** Cadena de mando
- **P-10** Retro de cierre (aprendizaje continuo)
- **P-11** Niveles de revisión (QA escalonado: Advisory / Strong / Adversarial)

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

## Desinstalar

NERV solo crea symlinks; borralos y listo (tu memoria en `~/.nerv/` no se toca):

```bash
rm ~/.claude/agents/nerv-*.md ~/.claude/commands/nerv-*.md ~/.claude/nerv-protocols.md
```

## Licencia

MIT.
