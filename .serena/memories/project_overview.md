# Project Overview: AgentRail

- Purpose: AgentRail is a stack-agnostic development framework that standardizes the end-to-end flow from request to implementation, testing, review, docs update, and memory handoff.
- Core SSOT:
  - `work/<task-id>/` for task artifacts
  - `docs/` for cross-task permanent documentation
- Main language/tooling: PowerShell scripts (`pwsh`) + Markdown documentation.
- Operating system context: Windows.

## Repository Structure (rough)
- `AGENTS.md`: canonical workflow/rules.
- `CLAUDE.md`: compatibility guidance (lower priority than AGENTS.md).
- `project.profile.yaml`: authoritative command definitions.
- `MEMORY.md`: handoff summary across sessions.
- `docs/`: specs, decisions, investigations, operations, templates, and `docs/INDEX.md`.
- `work/`: per-task working directories.
- `tools/`:
  - `tools/docs-indexer/`
  - `tools/consistency-check/`
  - `tools/improvement-harvest/`
  - `tools/ci/`
- `.github/workflows/ci-framework.yml`: CI governance for framework consistency.

## Standard Workflow
1. request.md
2. investigation.md
3. spec.md
4. plan.md
5. implementation
6. test
7. review.md
8. docs update (`docs/INDEX.md` included)
9. memory update (`MEMORY.md`, `state.json`)

## Mandatory Task Artifact Set
Each `work/<task-id>/` must include:
- `request.md`
- `investigation.md`
- `spec.md`
- `plan.md`
- `review.md`
- `state.json`
