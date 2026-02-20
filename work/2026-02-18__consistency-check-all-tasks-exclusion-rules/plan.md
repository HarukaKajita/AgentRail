# Plan: 2026-02-18__consistency-check-all-tasks-exclusion-rules

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 1. 対象仕様

- `work/2026-02-18__consistency-check-all-tasks-exclusion-rules/spec.md`


## 2. 実装計画ドラフト (Plan Draft)

- 目的: 既存資料の移行と整合性確保
- 実施項目:
  1. 既存ドキュメントの構造修正
- 成果物: 更新済み Markdown ファイル

## 3. 依存関係ゲート (Depends-on Gate)

- 依存: なし
- 判定方針: 直接移行
## 5. 実行コマンド (Execution Commands)

- all tasks (mixed root): `pwsh -NoProfile -Command "$temp = Join-Path $env:TEMP ('consistency-alltasks-' + [Guid]::NewGuid().ToString('N')); New-Item -ItemType Directory -Path $temp -Force | Out-Null; Copy-Item work/2026-02-18__project-profile-schema-validation (Join-Path $temp '2026-02-18__project-profile-schema-validation') -Recurse; New-Item -ItemType Directory -Path (Join-Path $temp 'archive-old') -Force | Out-Null; New-Item -ItemType Directory -Path (Join-Path $temp 'legacy-unused') -Force | Out-Null; pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks -WorkRoot $temp -OutputFormat json; Remove-Item -Path $temp -Recurse -Force"`
- all tasks fail case: `pwsh -NoProfile -Command "$temp = Join-Path $env:TEMP ('consistency-alltasks-' + [Guid]::NewGuid().ToString('N')); New-Item -ItemType Directory -Path $temp -Force | Out-Null; Copy-Item work/2026-02-18__project-profile-schema-validation (Join-Path $temp '2026-02-18__project-profile-schema-validation') -Recurse; New-Item -ItemType Directory -Path (Join-Path $temp '2026-02-19__broken-task') -Force | Out-Null; pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks -WorkRoot $temp -OutputFormat json; Remove-Item -Path $temp -Recurse -Force"`
- regression explicit task: `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId does-not-exist`
- docs index update: `pwsh -NoProfile -File tools/docs-indexer/index.ps1`
- task consistency: `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-18__consistency-check-all-tasks-exclusion-rules`

## 4. 確定実装計画 (Plan Final)

1. investigation/spec を反映し、`-AllTasks` 除外対象を archive/legacy prefix に固定する。
2. `tools/consistency-check/check.ps1` all モードへ除外判定を実装する。
3. `docs/specs/automation-tools-design-spec.md` に除外条件を追記する。
4. temp work root で PASS ケースと FAIL ケースを実行し、除外ルールの有効性を確認する。
5. `review.md` / `state.json` / `MEMORY.md` を更新し、task consistency を通す。

## 4. 変更対象ファイル

- `tools/consistency-check/check.ps1`
- `docs/specs/automation-tools-design-spec.md`
- `work/2026-02-18__consistency-check-all-tasks-exclusion-rules/investigation.md`
- `work/2026-02-18__consistency-check-all-tasks-exclusion-rules/spec.md`
- `work/2026-02-18__consistency-check-all-tasks-exclusion-rules/plan.md`
- `work/2026-02-18__consistency-check-all-tasks-exclusion-rules/review.md`
- `work/2026-02-18__consistency-check-all-tasks-exclusion-rules/state.json`
- `MEMORY.md`

## 5. リスクとロールバック

- リスク: prefix 判定が広すぎると対象 task を除外する可能性
- 回避: `archive`/`legacy` で始まる名前のみに限定し docs に明示する
- ロールバック: 除外実装コミットを戻し、運用ルール先行で再検討する

## 6. 完了判定

- AC-001〜AC-004 が PASS
- `review.md` に除外ルール検証結果が記録される
- `state.json` が `done` に更新される

## 7. 実装実行計画（2026-02-19T01:32:08+09:00）

1. all モードの task 列挙に prefix 除外処理を追加する。
2. docs に `-AllTasks` の除外仕様を追記する。
3. temp work root で mixed root PASS と broken task FAIL を確認する。
4. review/state/memory 更新後に task consistency を実行しコミットする。
