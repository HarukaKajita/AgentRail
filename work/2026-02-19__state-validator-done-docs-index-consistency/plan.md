# Plan: 2026-02-19__state-validator-done-docs-index-consistency

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 1. 対象仕様

- `work/2026-02-19__state-validator-done-docs-index-consistency/spec.md`

## 2. Execution Commands

- state validate(all): `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks`
- state validate(fail): `pwsh -NoProfile -Command '$tempRoot = Join-Path $env:TEMP ("state-done-docs-index-" + [Guid]::NewGuid().ToString("N")); $tempWork = Join-Path $tempRoot "work"; $tempDocs = Join-Path $tempRoot "docs"; New-Item -ItemType Directory -Path $tempWork,$tempDocs -Force | Out-Null; $taskId = "2026-02-19__profile-validator-required-checks-source-of-truth"; Copy-Item -Path ("work/" + $taskId) -Destination (Join-Path $tempWork $taskId) -Recurse; Copy-Item -Path "docs/INDEX.md" -Destination (Join-Path $tempDocs "INDEX.md"); $indexPath = Join-Path $tempDocs "INDEX.md"; $indexContent = Get-Content -Raw $indexPath; $indexContent = $indexContent -replace "(?m)^.*profile-validator-required-checks-source-of-truth\.md.*\r?\n?", ""; Set-Content -LiteralPath $indexPath -Value $indexContent; & pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId $taskId -WorkRoot $tempWork -DocsIndexPath $indexPath; $exit = $LASTEXITCODE; Remove-Item -LiteralPath $tempRoot -Recurse -Force; exit $exit'`
- consistency: `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-19__state-validator-done-docs-index-consistency`
- index update: `pwsh -NoProfile -File tools/docs-indexer/index.ps1`
- index check: `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`

## 3. 実施ステップ

1. source finding の evidence を基に、done 判定に不足している docs/INDEX 整合条件を特定する。
2. `tools/state-validate/validate.ps1` へ docs path 抽出 + index 収録確認ロジックを追加する。
3. 正常系（`-AllTasks`）と異常系（temp index から docs path を削除）で validator の PASS/FAIL を確認する。
4. docs / backlog / review / state / MEMORY を更新する。
5. `consistency-check` と `docs-indexer -Mode check` を実行して完了条件を検証する。

## 4. 変更対象ファイル

- `tools/state-validate/validate.ps1`
- `docs/operations/state-validator-done-docs-index-consistency.md`（新規）
- `docs/operations/validator-enhancement-backlog.md`
- `docs/operations/high-priority-backlog.md`
- `docs/INDEX.md`
- `work/2026-02-19__state-validator-done-docs-index-consistency/investigation.md`
- `work/2026-02-19__state-validator-done-docs-index-consistency/spec.md`
- `work/2026-02-19__state-validator-done-docs-index-consistency/plan.md`
- `work/2026-02-19__state-validator-done-docs-index-consistency/review.md`
- `work/2026-02-19__state-validator-done-docs-index-consistency/state.json`
- `MEMORY.md`

## 5. リスクとロールバック

- リスク: docs path 抽出条件が厳しすぎると既存 done task で誤検知する。
- ロールバック:
  1. docs 整合チェック追加部分を切り戻す。
  2. 抽出対象を最小規則（`docs/...` の backtick path）へ再調整する。

## 6. 完了判定

- AC-001〜AC-004 がすべて PASS。
- `review.md` に正常系/異常系の state validator 実行結果が記録されている。
- `state.json` が `done` かつ `updated_at` が更新されている。
