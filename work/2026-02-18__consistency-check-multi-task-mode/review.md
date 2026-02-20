# Review: 2026-02-18__consistency-check-multi-task-mode

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 1. レビュー対象

- `tools/consistency-check/check.ps1`
- `.github/workflows/ci-framework.yml`

## 2. 受入条件評価

- AC-001: PASS
- AC-002: PASS
- AC-003: PASS
- AC-004: PASS
- AC-005: PASS

## 3. テスト結果

### Unit Test

- 実施内容:
  1. `-TaskId` 単一モードで既存出力互換を確認
  2. `-TaskIds` で複数 task 集計を確認
  3. `-AllTasks -WorkRoot <temp>` で全件走査を確認
- 結果: PASS

### Integration Test

- 実施内容: `-TaskIds` の FAIL ケースで task別サマリと集計 failure が出力され、終了コード 1 が返ることを確認
- 結果: PASS

### Regression Test

- 実施内容: 既存 CI 呼び出し（`-TaskId`）で `CHECK_RESULT` 形式が維持されることを確認
- 結果: PASS

### Manual Verification

- 実施内容:
  1. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-18__project-profile-schema-validation`
  2. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskIds 2026-02-18__project-profile-schema-validation,does-not-exist`
  3. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks -WorkRoot <temp-work-root>`
- 結果: PASS

## 4. 指摘事項

- 重大: なし
- 改善提案:
  - 全件実行時の timeout 制御を追加する

## 5. 結論

- 本タスクは `done` 判定とする。

## 6. プロセス改善案 (Process Findings) (必須)

### 6.1 Finding F-001

- finding_id: F-001
- category: flow
- severity: low
- summary: `-AllTasks` は既存 legacy task の不整合をそのまま拾うため、運用では対象絞り込み戦略が必要。
- evidence: 実リポジトリの `-AllTasks` 実行で旧 task の Process Findings 欠落が検出された。
- action_required: no
- linked_task_id: none
