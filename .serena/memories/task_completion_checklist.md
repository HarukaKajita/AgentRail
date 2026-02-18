# Task Completion Checklist

A task can be marked `done` only when all below are satisfied.

## Acceptance and verification
- All acceptance criteria in `work/<task-id>/spec.md` are satisfied.
- `テスト要件` execution results are recorded in `work/<task-id>/review.md`.

## Documentation
- Relevant docs under `docs/` are updated to reflect changes.
- `docs/INDEX.md` includes links to new/updated docs.

## Process findings and improvements
- `review.md` includes `## 6. Process Findings`.
- Any `must/high` finding is linked to a follow-up task (`linked_task_id`) when action is required.

## State and handoff
- `work/<task-id>/state.json` is up to date with required keys:
  - `state`
  - `owner`
  - `updated_at`
  - `blocking_issues`
- `MEMORY.md` is updated with latest status and next actions.

## Recommended command checks before closing
- `pwsh -NoProfile -File tools/improvement-harvest/scan.ps1 -TaskId <task-id>`
- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId <task-id>`
- `pwsh -NoProfile -File tools/docs-indexer/index.ps1`
