# NERV — Operating Protocols

> Loaded on demand by NERV agents. NOT included in the global CLAUDE.md:
> they only apply when you start a NERV session with the ignition prompt.

## P-0 · Memory
The Engram and ~/.nerv/registry.md are the only memory. What isn't written doesn't exist.
Orchestrator boot: registry → project selection → engram/_state.md. NOTHING else.

## P-E · Token Economy (cross-cutting, mandatory)
1. Minimal reading: each agent opens ONLY the files/sections its handoff
   specifies. Forbidden to "read the whole engram for context".
2. _state.md ≤15 lines; handoff entries ≤6 lines; PO summaries ≤5 lines.
3. Never paste file contents into the chat or into sub-agent invocations:
   reference by path + ID (ticket, ADR, endpoint).
4. Rotation: handoff_log >30 entries and closed sprints >5 → ~/.nerv/archive/.
   Archived files are NOT read unless the PO explicitly asks.
5. Don't repeat info already in a file: cite the ID.
6. Diffs over existing files, not full regeneration.

## P-1 · Handoff
Valid only if: (1) the ticket exists in 03_backlog.md with ID, criteria, branch and
**review level** (P-11); (2) the sub-agent invocation contains ONLY: ticket ID +
review level + list of files/sections to read; (3) entry logged in
05_handoff_log.md; (4) the receiver reads its section in
~/.nerv/playbook.md (process lessons) before coding; (5) the receiver
returns control to the Orchestrator with its **structured return handoff**
(≤6 lines): `status` · `files touched` · `risks/caveats` · `how to test`.
Nobody closes alone.

## P-2 · QA Rejection
REJECTED ⇒ numbered list of defects in the backlog → goes back to "En progreso" with the
same Tech Lead → fix ONLY the listed defects (no opportunistic refactors)
→ re-review. 2 consecutive rejections ⇒ escalate to nerv-arquitecto and inform the PO.

## P-3 · Zero Assumptions
Ambiguity in scope/behavior/priority ⇒ STOP. Logged in
01_requirements.md §6 and the Orchestrator asks the PO. Forbidden: inventing
requirements, mocking silently, assuming API responses. The PO's answer
is written BEFORE resuming. (Purely technical trade-offs: the Architect
resolves them via ADR without bothering the PO.)

## P-4 · Write Ownership
registry/_state/backlog/handoff: Orchestrator · ADRs: Architect · contracts for
their endpoints: Backend · verdicts and "Done": QA · own task states:
each Tech Lead. Changes outside your ownership: request via the Orchestrator.

## P-5 · Session Close
Before ending, the Orchestrator ALWAYS: (a) updates 03_backlog.md and
_state.md; (b) close entry in 05_handoff_log.md with the next step;
(c) updates the project's "Última sesión" and "Estado" in ~/.nerv/registry.md;
(d) runs the P-10 retro; (e) PO summary ≤5 lines.

## P-6 · Project selection / onboarding
"Let's work on X": if X is in the registry → load it. If not → intake in
ONE message: alias, local path, git remote, target branch (default: dev),
tracker+board, Figma. Verify the repo (clone if needed), create engram/ from
templates if missing, add the row to the registry. Switching project mid-session
⇒ run P-5 on the current one first.

## P-7 · Tasks with an external tracker (ADO/Jira)
- Import existing: pull the work item by ID/URL (ADO/Jira MCP, or CLI:
  `az boards work-item show --id N`), create a mirror ticket in 03_backlog.md with
  the Ext column mapped. The external description does NOT replace acceptance
  criteria: if missing, P-3.
- Create new: ticket first in the backlog (PO-approved) → create the external
  work item → save the ID in the Ext column.
- States: when moving to "En revisión QA" and "Done", the Orchestrator reflects the
  state in the tracker (move column / comment with PR link).
- No credentials/MCP available ⇒ warn the PO and continue in engram only.

## P-8 · Git Flow (standard implementation)
1. Approved ticket ⇒ Orchestrator creates a branch from the updated target branch:
   `feature/T-XXX-slug` (with tracker: `feature/AB123-slug` or the project's
   convention). Record the branch in the ticket.
2. Tech Lead implements and commits on that branch. Messages: conventional
   commits + external reference (ADO: include `AB#123` for auto-link).
3. QA approves ⇒ Orchestrator pushes and opens a PR to the target branch
   (`gh pr create` / `az repos pr create`) with: title = ticket, description =
   criteria + change summary + work item link.
4. NEVER: direct push to dev/main/master, nor merging the PR without an explicit
   order from the PO. The PR stays open and the link is reported.
5. Conflicts or red pipeline ⇒ ticket "Bloqueado" + inform the PO.
6. **Commit = unit of work**: each commit is a deliverable behavior/fix/migration
   with its tests and docs TOGETHER, that passes review and reverts on its own
   without touching unrelated work. Forbidden to group by file type (all models,
   then all tests). Outcome-focused message: `feat(auth): add token
   validation model and tests`, not `add models`.
7. **Chained PRs**: if the ticket forecast is >400 diff lines (P-11 threshold),
   plan chained PRs by unit of work instead of one giant PR;
   each slice independently reviewable and mergeable.

## P-9 · Chain of command
The PO talks ONLY to nerv-orquestador. If another agent receives direct input from
the PO, it replies: "Derivo al Orquestador" and does not act.

## P-10 · Closing retro (continuous learning)
After P-5 and before the PO summary, the Orchestrator runs the session retro.
Without summoning agents (P-E): it synthesizes, it doesn't convene.
1. Inputs: the session's return handoffs in 05_handoff_log.md + QA
   verdicts (approvals and rejections with their reason) + blockers. Only from THIS session.
2. Write a new entry at the TOP of 06_retro.md (≤8 lines): what went well,
   what went wrong, and the concrete action that changes the next one. Project-specific.
3. Promote ONLY durable process lessons to ~/.nerv/playbook.md, in the section
   of the applicable role (≤10 lines/role). If a new lesson contradicts an old one, it
   replaces it. Promotion criterion: it enters the playbook only if it would apply to
   ANY project; anything tied to this project stays only in 06_retro.md.
4. Agents read their playbook section before coding (P-1). So the team doesn't
   repeat the same mistake across sessions or projects.

## P-11 · Review levels (tiered QA)
QA doesn't spend the same effort on a typo as on auth. The Orchestrator marks the level
on the ticket at handoff (P-1); QA applies it. The lenses are dimensions of
ONE audit, not parallel sub-agents (P-E: QA convenes nobody).
- **Advisory** (default, bounded change): core lenses — acceptance criteria
  + readability. Cost ~1x. The everyday case.
- **Strong** (the diff touches `auth`/security/payments/migrations, **or** exceeds 400
  lines): the 4 lenses — *risk* (security/data), *resilience* (errors/edge
  cases), *readability* (clarity/maintainability), *reliability* (tests/correctness).
- **Adversarial** (architecture-critical change / new ADR, or 2nd attempt after a
  rejection): on top of Strong, a hostile pass — "assume it's broken, find the
  flaw". QA runs it; on architecture-critical changes nerv-arquitecto runs it; on
  critical security/infra changes (auth/payments/secrets/PII/deploy), nerv-devops.
- Anti-bloat (P-E): the level is chosen by the ticket, NOT raised "just in case".
  Raising the level without a trigger wastes tokens; lowering it on a sensitive path
  is negligence.
