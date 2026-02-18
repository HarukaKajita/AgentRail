# Suggested Commands (Windows / PowerShell)

## Basic navigation
- `git status`
- `git diff`
- `Get-ChildItem`
- `Set-Location <path>`
- `Select-String -Path <file> -Pattern <pattern>`

## Framework commands (from `project.profile.yaml`)
- Build:
  - `pwsh -NoProfile -Command "Write-Output 'Build step: documentation-only repository, no binary build required.'"`
- Test:
  - `pwsh -NoProfile -Command '$required = @("AGENTS.md","CLAUDE.md","MEMORY.md","project.profile.yaml","docs/INDEX.md"); $missing = $required | Where-Object { -not (Test-Path $_) }; if ($missing.Count -gt 0) { Write-Error ("Missing files: " + ($missing -join ", ")); exit 1 }; Write-Output "Baseline framework file check passed."'`
- Format:
  - `pwsh -NoProfile -Command "Write-Output 'Format step: markdown formatting is manual in this repository.'"`
- Lint:
  - `pwsh -NoProfile -Command "Write-Output 'Lint step: policy checks are performed via review checklist.'"`

## Project utility commands
- Rebuild docs index:
  - `pwsh -NoProfile -File tools/docs-indexer/index.ps1`
- Consistency check for task:
  - `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId <task-id>`
- Validate/extract process findings:
  - `pwsh -NoProfile -File tools/improvement-harvest/scan.ps1 -TaskId <task-id>`
- Create follow-up improvement task:
  - `pwsh -NoProfile -File tools/improvement-harvest/create-task.ps1 -SourceTaskId <task-id> -FindingId <finding-id> -Title <title> -Severity <severity> -Category <category>`

## Typical completion run
1. `pwsh -NoProfile -File tools/improvement-harvest/scan.ps1 -TaskId <task-id>`
2. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId <task-id>`
3. `pwsh -NoProfile -File tools/docs-indexer/index.ps1`
