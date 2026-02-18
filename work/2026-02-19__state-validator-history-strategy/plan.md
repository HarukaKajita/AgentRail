# Plan: 2026-02-19__state-validator-history-strategy

## 1. 対象仕様

- `work/2026-02-19__state-validator-history-strategy/spec.md`

## 2. Execution Commands

- state validate(all): `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks`
- state validate(fail): `pwsh -NoProfile -Command '$tempRoot = Join-Path $env:TEMP ("state-history-strategy-" + [Guid]::NewGuid().ToString("N")); $tempWork = Join-Path $tempRoot "work"; New-Item -ItemType Directory -Path $tempWork -Force | Out-Null; $taskId = "2026-02-19__profile-validator-required-checks-source-of-truth"; Copy-Item -Path ("work/" + $taskId) -Destination (Join-Path $tempWork $taskId) -Recurse; $statePath = Join-Path $tempWork ($taskId + "/state.json"); $stateObj = Get-Content -Raw $statePath | ConvertFrom-Json; $historyEntry = [PSCustomObject]@{ state = "planned"; changed_at = "2026-02-19T00:00:00+09:00" }; Add-Member -InputObject $stateObj -NotePropertyName history -NotePropertyValue @($historyEntry) -Force; $stateObj | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $statePath; & pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId $taskId -WorkRoot $tempWork; $exit = $LASTEXITCODE; Remove-Item -LiteralPath $tempRoot -Recurse -Force; exit $exit'`
- consistency: `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-19__state-validator-history-strategy`
- index update: `pwsh -NoProfile -File tools/docs-indexer/index.ps1`
- index check: `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`

## 3. 実施ステップ

1. state history 管理方式を外部化（Git 履歴）で確定する。
2. `tools/state-validate/validate.ps1` に `history` / `state_history` 禁止チェックを追加する。
3. 正常系（`-AllTasks`）と異常系（history キー混入）で validator 挙動を確認する。
4. docs / backlog / review / state / MEMORY を更新する。
5. consistency-check と docs-indexer check を実行する。

## 4. 変更対象ファイル

- `tools/state-validate/validate.ps1`
- `docs/operations/state-history-strategy.md`（新規）
- `docs/operations/validator-enhancement-backlog.md`
- `docs/operations/high-priority-backlog.md`
- `docs/INDEX.md`
- `work/2026-02-19__state-validator-history-strategy/investigation.md`
- `work/2026-02-19__state-validator-history-strategy/spec.md`
- `work/2026-02-19__state-validator-history-strategy/plan.md`
- `work/2026-02-19__state-validator-history-strategy/review.md`
- `work/2026-02-19__state-validator-history-strategy/state.json`
- `MEMORY.md`

## 5. リスクとロールバック

- リスク: history キー禁止が将来の拡張要件と衝突する。
- ロールバック:
  1. 禁止キーチェックを一時解除する。
  2. 履歴ストア方針を別タスクで再設計する。

## 6. 完了判定

- AC-001〜AC-004 がすべて PASS。
- `review.md` に state history 方針決定と検証結果が記録されている。
- `state.json` が `done` に更新されている。
