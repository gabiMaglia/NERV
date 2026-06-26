---
description: Intake guiado P-6 para dar de alta un proyecto nuevo en el registry NERV
---

Ejecutá el intake P-6 para un proyecto nuevo según los protocolos NERV.

Pasos (en orden):

1. **Pediéndome TODOS los campos en UN SOLO mensaje** (no preguntas en serie):
   - `alias` — slug corto (kebab-case)
   - `path local` — ruta absoluta donde clonar / vive el repo
   - `git remoto` — URL del repo (HTTPS o SSH)
   - `rama objetivo` — default `dev` si no digo nada
   - `tracker` — ADO / Jira / ninguno
   - `board` — URL del board si hay tracker
   - `Figma` — URL si hay diseño
   - `stack` — backend (nestjs por default | none) / mobile (rn-expo | none) / web (react-vite | nextjs | none) / desktop (pyside6 | none) / ai (llm-agents | none). Cada uno mapea a su agente (nerv-backend/mobile/web/desktop/ai).
   - `en_prod` — true/false (define si aplica protocolo de hotfix)

2. **Con mis respuestas, verificá el repo**:
   - Si el path no existe → `git clone` desde el remoto.
   - Si el path existe pero no es git → STOP, decímelo.
   - Si existe y es git → `git fetch` y confirmá rama objetivo.

3. **Creá `engram/` desde plantillas** si no existe (los 7 archivos: `_state.md`, `01_requirements.md`, `02_architecture.md`, `03_backlog.md`, `04_api_contracts.md`, `05_handoff_log.md`, `06_retro.md`). Plantillas en `nerv-framework-v2.md` sección 3.

4. **Agregá la fila al `~/.nerv/registry.md`** con los datos del intake. Estado inicial: "Recién dado de alta — sin sprint definido."

5. **Devolveme** confirmación + próxima pregunta P-6: "¿Definimos sprint 1 ahora o querés explorar el repo primero?"

P-3: si algún campo queda ambiguo, registralo en `engram/01_requirements.md §6` y preguntame. No inventes.
