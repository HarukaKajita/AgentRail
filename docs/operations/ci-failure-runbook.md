# CI 失敗時ランブック

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


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

### 2. `profile schema governance` 失敗

- 症状: `tools/profile-validate/check-schema-governance.ps1` step が失敗
- 確認:
  1. `tools/profile-validate/profile-schema.json` を変更した場合に `schema_version` を更新したか
  2. `schema_version` が SemVer 形式（`major.minor.patch`）か
  3. `schema_version` が `supported_profile_schema_versions` に含まれているか
  4. `required_keys` / `forbidden_top_level_keys` / `schema_id` 変更、または supported versions の削除がある場合に major を増分したか
- 対処:
  1. ローカルで `pwsh -NoProfile -File tools/profile-validate/check-schema-governance.ps1 -RepoRoot . -BaseSha <base-sha> -HeadSha <head-sha>` を実行
  2. 失敗した `rule_id`（R-001〜R-005）に対応する schema version 更新を実施
  3. 再実行して `SCHEMA_GOVERNANCE: PASS` を確認

### 3. `docs/INDEX.md` 差分検出失敗

- 症状: `git diff --exit-code -- docs/INDEX.md` で失敗
- 確認:
  1. docs の追加/更新後に INDEX を再生成したか
- 対処:
  1. `pwsh -NoProfile -File tools/docs-indexer/index.ps1` を実行
  2. `docs/INDEX.md` をコミット対象へ含める

### 4. `Resolve task ID` 失敗

- 症状: `tools/ci/resolve-task-id.ps1` が失敗
- 確認:
  1. `workflow_dispatch` 実行時に `task_id` が正しいか
  2. 差分で `work/<task-id>/` が複数にまたがっていないか
  3. `work/` が空でないか
- 対処:
  1. 必要なら `workflow_dispatch` の `task_id` を明示指定
  2. 複数 task 変更を分割して PR を作成

### 5. `consistency-check` 失敗

- 症状: `tools/consistency-check/check.ps1` が FAIL
- 確認:
  1. 対象 task の必須6ファイル
  2. `spec.md` の空欄禁止項目
  3. `docs/INDEX.md` 導線
  4. `review.md` の `## 6. Process Findings`
- 対処:
  1. ローカルで同コマンドを再実行
  2. failure の `rule_id/file/reason` を順に修正

### 6. `improvement-harvest scan` 失敗

- 症状: `tools/improvement-harvest/scan.ps1` が FAIL
- 確認:
  1. `review.md` に `## 6. Process Findings` があるか
  2. 各 finding が必須キーを持つか
  3. `must/high` finding で `action_required: yes` になっているか
  4. `linked_task_id` が `work/` 配下に存在するか
- 対処:
  1. `review.md` の finding をテンプレート形式へ修正
  2. 必要なら `tools/improvement-harvest/create-task.ps1` で follow-up task を起票
  3. 再度 scan と consistency-check を実行

## 復旧後チェック

1. `pwsh -NoProfile -File tools/docs-indexer/index.ps1`
2. `pwsh -NoProfile -File tools/profile-validate/check-schema-governance.ps1 -RepoRoot . -BaseSha <base-sha> -HeadSha <head-sha>`
3. `pwsh -NoProfile -File tools/improvement-harvest/scan.ps1 -TaskId <task-id>`
4. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId <task-id>`
5. `git diff --exit-code -- docs/INDEX.md`
