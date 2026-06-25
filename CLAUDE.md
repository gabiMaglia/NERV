# NERV — Framework Multi-Agente

> Este repo **ES** el framework NERV. Para USARLO en otros proyectos, ver `~/.claude/nerv-protocols.md` y `~/.claude/agents/nerv-*.md` (symlinks a este repo).

## Estás editando NERV mismo

| Archivo | Para qué |
|---------|----------|
| `nerv-framework-v2.md` | Mapa/índice de la arquitectura — §2 y §4 apuntan a agentes y protocolos, NO los copian |
| `nerv-protocols.md` | Protocolos P-0 a P-11 + P-E (memoria, handoffs, QA, git, niveles de revisión) — **fuente de verdad** |
| `.claude/agents/nerv-*.md` | Los 9 agentes (orquestador, arquitecto, backend, mobile, web, desktop, qa, devops, security) — **fuente de verdad** |
| `.claude/commands/nerv-*.md` | Slash commands (`/nerv-init`, `/nerv-status`, etc.) |
| `ROADMAP.md` | Plan de evolución (fases 0 a 7) |
| `CHANGELOG.md` | Cambios versionados (SemVer) |
| `install.sh` | Reinstalación global vía symlinks |
| `registry.md` | Plantilla del registry — NO es el registry real (vive en `~/.nerv/registry.md`) |

## Reglas para editar NERV

1. **Edits aquí impactan global** automáticamente (symlinks). No hace falta reinstalar.
2. **Todo cambio relevante → entrada en `CHANGELOG.md`** bajo `[Unreleased]`.
3. **NERV no es una app**: no agregues package.json, deps, build steps, tests automáticos.
4. **Economía de tokens (P-E) también aplica al framework**: agentes cortos, protocolos cortos, sin párrafos de relleno.
5. **Modelos por agente** ya están en frontmatter: Opus (orquestador, arquitecto, devops, security), Sonnet (backend, mobile, web, desktop, qa). No agregues `model:` arbitrariamente.

## Cómo agregar cosas nuevas

| Querés agregar... | Dónde va |
|-------------------|----------|
| Un agente nuevo | `.claude/agents/nerv-<rol>.md` + entrada en `install.sh` |
| Un slash command | `.claude/commands/nerv-<verbo>.md` + entrada en `install.sh` |
| Un protocolo nuevo | `nerv-protocols.md` (sección P-N) |
| Un stack nuevo | Un agente = un stack (naming plano: `nerv-<stack>`). Ver Fase 4 del `ROADMAP.md` |

## No tocar sin razón

- Los archivos en `~/.nerv/` (registry real, archive) — viven del lado del usuario, no del framework.
- Los `.claude/CLAUDE.md` (instrucciones personales) — NO son parte del framework NERV.
