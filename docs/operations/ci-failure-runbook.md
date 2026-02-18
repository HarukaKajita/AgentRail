# CI 失敗時ランブック

## 目的

`Framework CI` が失敗したときに、原因を短時間で切り分けて復旧するための手順。

## 対象ワークフロー

- `.github/workflows/ci-framework.yml`

## 失敗パターンと対処

### 1. `docs-indexer` 失敗

- 症状: `tools/docs-indexer/index.ps1` step が失敗
- 確認:
  1. `docs/INDEX.md` の見出し (`## 2`〜`## 6`) が存在するか
  2. `docs/*` の Markdown に `#` 見出しがあるか
  3. ファイル名重複がないか
- 対処:
  1. ローカルで `pwsh -NoProfile -File tools/docs-indexer/index.ps1` 実行
  2. 失敗メッセージのファイルを修正

### 2. `docs/INDEX.md` 差分検出失敗

- 症状: `git diff --exit-code -- docs/INDEX.md` で失敗
- 確認:
  1. docs の追加/更新後に INDEX を再生成したか
- 対処:
  1. `pwsh -NoProfile -File tools/docs-indexer/index.ps1` を実行
  2. `docs/INDEX.md` をコミット対象へ含める

### 3. `Resolve task ID` 失敗

- 症状: `tools/ci/resolve-task-id.ps1` が失敗
- 確認:
  1. `workflow_dispatch` 実行時に `task_id` が正しいか
  2. 差分で `work/<task-id>/` が複数にまたがっていないか
  3. `work/` が空でないか
- 対処:
  1. 必要なら `workflow_dispatch` の `task_id` を明示指定
  2. 複数 task 変更を分割して PR を作成

### 4. `consistency-check` 失敗

- 症状: `tools/consistency-check/check.ps1` が FAIL
- 確認:
  1. 対象 task の必須6ファイル
  2. `spec.md` の空欄禁止項目
  3. `docs/INDEX.md` 導線
- 対処:
  1. ローカルで同コマンドを再実行
  2. failure の `rule_id/file/reason` を順に修正

## 復旧後チェック

1. `pwsh -NoProfile -File tools/docs-indexer/index.ps1`
2. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId <task-id>`
3. `git diff --exit-code -- docs/INDEX.md`
