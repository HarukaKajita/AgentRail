---
name: list-planned-tasks-by-backlog-priority
description: Display planned backlog tasks in priority order by reading `docs/operations/high-priority-backlog.md` and `work/*/state.json`. Use when asked to check backlog, list queued tasks, or show planned tasks by priority with mismatch warnings between docs and work.
---

# List Planned Tasks By Backlog Priority

## Goal

Show planned tasks in priority order using docs as the primary source of ordering.

## Run Workflow

1. Run the bundled PowerShell script from the repository root.
2. Use `docs/operations/high-priority-backlog.md` as the priority source.
3. Cross-check `work/*/state.json` and include only tasks where `state` is `planned`.
4. Append planned tasks missing from docs to the end.
5. Show mismatch warnings without stopping output.

## Command

```powershell
pwsh -NoProfile -File "$HOME/.agents/skills/list-planned-tasks-by-backlog-priority/scripts/list_planned_tasks.ps1" -RepoRoot .
```

Optional overrides:

```powershell
pwsh -NoProfile -File "$HOME/.agents/skills/list-planned-tasks-by-backlog-priority/scripts/list_planned_tasks.ps1" -RepoRoot . -BacklogPath "docs/operations/high-priority-backlog.md" -WorkDir "work"
```

## Output Contract

Return these sections in order:

1. `Planned Tasks (Priority Order)`
2. `Warnings`
3. `Sources`

Use the list line format:

`<index>. <task-id> (source: docs|work-only)`

## Error Handling

Fail when required paths are missing or unreadable:

- backlog file is missing
- work directory is missing
- priority section cannot be parsed

For state mismatches, continue and report warnings.
