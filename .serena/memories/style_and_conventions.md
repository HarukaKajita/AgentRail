# Style and Conventions

## Communication / documentation language
- CLI communication: Japanese.
- Documentation default language: Japanese (`project.profile.yaml` defaults).
- Code comments: English.
- If request/spec is ambiguous or unclear, ask the user before proceeding.

## Process conventions
- Follow the fixed workflow in `AGENTS.md`.
- Do not start implementation if pre-check files/sections are missing.
- Enforce strict block conditions:
  - required sections in `spec.md` cannot be blank
  - `テスト要件` must be testable and concrete
  - `plan.md` must reference `spec.md`
  - `docs/INDEX.md` must be updated after review
  - `project.profile.yaml` required keys must exist

## Quality / governance conventions
- Keep `docs/` and `work/` as SSOT.
- `review.md` must include process findings; `must/high` findings require follow-up linkage.
- Update `MEMORY.md` and `state.json` for handoff continuity.

## Safety conventions
- No destructive commands unless explicitly requested.
- Do not revert unrelated in-progress changes.
- Record reason/impact before risky operations.
