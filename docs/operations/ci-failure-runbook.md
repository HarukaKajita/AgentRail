# CI 失敗時ランブック

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `docs/operations/wave2-doc-quality-warning-mode.md`
  - `docs/operations/wave2-doc-quality-fail-mode.md`
  - `.github/workflows/ci-framework.yml`
  - `work/2026-02-20__wave2-enforce-doc-quality-fail-mode/spec.md`
- 理解ポイント:
  - docs品質ゲートは「全体=warning / 変更対象task=fail」の二段運用で実行される。

## 目的

`Framework CI` が失敗したときに、原因を短時間で切り分けて復旧する。

## Human-Centric 利用ガイド

1. 使い方:
   - 失敗した step 名を特定し、本資料の該当セクションへ移動する。
2. 仕組み:
   - CI は `docs-indexer -> profile schema governance -> profile validate -> state-validate(all/warning) -> resolve-task-id -> improvement scan -> state-validate(task/fail) -> consistency-check(task/fail)` の順で判定する。
3. 実装:
   - 復旧コマンドは `tools/*` をそのままローカル実行し、`rule_id/file/reason` で修正箇所を確定する。
4. 関連:
   - 運用仕様は `docs/operations/wave2-doc-quality-warning-mode.md` / `docs/operations/wave2-doc-quality-fail-mode.md` を参照する。

## 対象ワークフロー

- `.github/workflows/ci-framework.yml`

## 失敗パターンと対処

### 1. `docs-indexer` 失敗

- 症状: `tools/docs-indexer/index.ps1 -Mode check` が FAIL
- 確認:
  1. `docs/INDEX.md` の managed section が壊れていないか
  2. 新規 docs が `#` 見出しを持つか
  3. 同名 Markdown が重複していないか
- 対処:
  1. `pwsh -NoProfile -File tools/docs-indexer/index.ps1`
  2. `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`

### 2. `profile schema governance` 失敗

- 症状: `tools/profile-validate/check-schema-governance.ps1` が FAIL
- 確認:
  1. `profile-schema.json` 変更時に `schema_version` を更新したか
  2. major/minor/patch の増分ルールに違反していないか
- 対処:
  1. `pwsh -NoProfile -File tools/profile-validate/check-schema-governance.ps1 -RepoRoot . -BaseSha <base-sha> -HeadSha <head-sha>`
  2. 失敗 rule に対応して schema を更新

### 3. `Validate task states` 失敗（all tasks / warning mode）

- 症状: `tools/state-validate/validate.ps1 -AllTasks -DocQualityMode warning` が FAIL
- 確認:
  1. task の `state.json` 必須キー
  2. `state=done` の review pending 行
  3. `depends_on` の循環や未解決依存
- 対処:
  1. `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks -DocQualityMode warning`
  2. 失敗 task の `state.json` / `review.md` を修正

### 4. `Resolve task ID` 失敗

- 症状: `tools/ci/resolve-task-id.ps1` が FAIL
- 確認:
  1. `workflow_dispatch` の `task_id` が正しいか
  2. `work/<task-id>/` の差分が単一 task に閉じているか
- 対処:
  1. 必要なら `workflow_dispatch` で `task_id` を明示
  2. 複数 task 変更を分割して再実行

### 5. `improvement-harvest scan` 失敗

- 症状: `tools/improvement-harvest/scan.ps1` が FAIL
- 確認:
  1. `review.md` に `## 6. Process Findings` があるか
  2. `must/high` finding の `action_required` と `linked_task_id`
- 対処:
  1. `review.md` の finding を修正
  2. 必要に応じて `tools/improvement-harvest/create-task.ps1` で follow-up task を作成

### 6. `state-validate` 失敗（target task / fail mode）

- 症状: `tools/state-validate/validate.ps1 -TaskId <task-id> -DocQualityMode fail` が FAIL
- 確認:
  1. `rule_id=DQ-*` が出ているか
  2. 対象 docs の前提知識・導線・depends_on 整合
- 対処:
  1. `reason` のファイルを修正
  2. 再実行して `error_count=0` を確認

### 7. `consistency-check` 失敗（target task / fail mode）

- 症状: `tools/consistency-check/check.ps1 -TaskId <task-id> -DocQualityMode fail` が FAIL
- 確認:
  1. task 必須6ファイル
  2. `spec.md` のテスト要件・関連 docs リンク
  3. DQ issue（`rule_id=DQ-*`）
- 対処:
  1. `rule_id/file/reason` を順に解消
  2. `DocQualityMode fail` で再確認

## 復旧後チェック

1. `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`
2. `pwsh -NoProfile -File tools/profile-validate/check-schema-governance.ps1 -RepoRoot . -BaseSha <base-sha> -HeadSha <head-sha>`
3. `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks -DocQualityMode warning`
4. `pwsh -NoProfile -File tools/improvement-harvest/scan.ps1 -TaskId <task-id>`
5. `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId <task-id> -DocQualityMode fail`
6. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId <task-id> -DocQualityMode fail`

## 関連タスク

- `work/2026-02-20__wave2-implement-doc-quality-warning-mode/spec.md`
- `work/2026-02-20__wave2-enforce-doc-quality-fail-mode/spec.md`
- `work/2026-02-20__wave2-align-ci-runbook-with-doc-quality-gates/spec.md`
