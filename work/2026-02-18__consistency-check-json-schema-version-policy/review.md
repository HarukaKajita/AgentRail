# Review: 2026-02-18__consistency-check-json-schema-version-policy

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 1. レビュー対象

- `tools/consistency-check/check.ps1`
- `docs/specs/automation-tools-design-spec.md`

## 2. 受入条件評価

- AC-001: PASS
- AC-002: PASS
- AC-003: PASS
- AC-004: PASS

## 3. テスト結果

### Unit Test

- 実施内容:
  1. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-18__project-profile-schema-validation -OutputFormat json`
  2. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskIds 2026-02-18__project-profile-schema-validation,does-not-exist -OutputFormat json`
- 結果: PASS

### Integration Test

- 実施内容: `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-18__project-profile-schema-validation -OutputFormat json -OutputFile .tmp/schema-check.json` を実行し、標準出力と保存ファイルの `schema_version` 一致を確認
- 結果: PASS

### Regression Test

- 実施内容:
  1. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-18__project-profile-schema-validation`
  2. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId does-not-exist`
- 結果: PASS

### Manual Verification

- 実施内容:
  1. `pwsh -NoProfile -File tools/docs-indexer/index.ps1`
  2. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-18__consistency-check-json-schema-version-policy`
- 結果: PASS

## 4. 指摘事項

- 重大: なし
- 改善提案:
  - `schema_version` 変更時は `docs/specs/automation-tools-design-spec.md` の互換ポリシーと同時に更新する運用を明文化しておくと安全。

## 5. 結論

- 本タスクは `done` 判定とする。

## 6. プロセス改善案 (Process Findings) (必須)

### 6.1 Finding F-001

- finding_id: F-001
- category: quality
- severity: low
- summary: JSON スキーマ版の運用は docs 依存のため、version bump 手順を review で継続確認する必要がある。
- evidence: `tools/consistency-check/check.ps1` に `schema_version` 定数を追加し、`docs/specs/automation-tools-design-spec.md` に versioning policy を追記した。
- action_required: no
- linked_task_id: none
