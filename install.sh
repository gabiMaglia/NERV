#!/usr/bin/env bash
# NERV install — crea symlinks globales desde este repo.
# Idempotente: corré las veces que quieras, no duplica nada.

set -euo pipefail

NERV_REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_HOME="${HOME}/.claude"
NERV_HOME="${HOME}/.nerv"

echo "==> Instalando NERV desde: ${NERV_REPO}"
echo

mkdir -p "${CLAUDE_HOME}/agents" "${CLAUDE_HOME}/commands" "${NERV_HOME}"

link() {
  local src="$1"
  local dest="$2"
  local label="$3"
  if [[ ! -f "${src}" ]]; then
    echo "  ⚠ skip ${label} (source no existe: ${src})"
    return
  fi
  ln -sfn "${src}" "${dest}"
  echo "  ✓ ${label}"
}

echo "→ Agentes:"
for agent in nerv-orquestador nerv-arquitecto nerv-backend nerv-mobile nerv-web nerv-desktop nerv-qa; do
  link "${NERV_REPO}/.claude/agents/${agent}.md" \
       "${CLAUDE_HOME}/agents/${agent}.md" \
       "agent: ${agent}"
done
echo

echo "→ Slash commands:"
for cmd in nerv-init nerv-status nerv-handoff nerv-adr nerv-new-project nerv-close nerv-ticket; do
  link "${NERV_REPO}/.claude/commands/${cmd}.md" \
       "${CLAUDE_HOME}/commands/${cmd}.md" \
       "command: /${cmd}"
done
echo

echo "→ Protocolos:"
link "${NERV_REPO}/nerv-protocols.md" \
     "${CLAUDE_HOME}/nerv-protocols.md" \
     "nerv-protocols.md"
echo

echo "→ Registry:"
if [[ ! -f "${NERV_HOME}/registry.md" ]]; then
  cp "${NERV_REPO}/registry.md" "${NERV_HOME}/registry.md"
  echo "  ✓ ${NERV_HOME}/registry.md (creado desde plantilla)"
else
  echo "  → ${NERV_HOME}/registry.md ya existe (no se sobrescribe)"
fi
echo

echo "→ Playbook (memoria de proceso global):"
if [[ ! -f "${NERV_HOME}/playbook.md" ]]; then
  cp "${NERV_REPO}/playbook.md" "${NERV_HOME}/playbook.md"
  echo "  ✓ ${NERV_HOME}/playbook.md (creado desde plantilla)"
else
  echo "  → ${NERV_HOME}/playbook.md ya existe (no se sobrescribe)"
fi
echo

echo "✅ NERV instalado."
echo "   Desde cualquier directorio, arrancá con:  /nerv-init"
