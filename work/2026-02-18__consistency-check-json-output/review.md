# Review: 2026-02-18__consistency-check-json-output

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
  1. 既定 `text` 出力の互換確認
  2. `-OutputFormat json` で JSON パース確認
  3. 不存在 task で FAIL 時 JSON 生成を確認
- 結果: PASS

### Integration Test

- 実施内容: checker 実行で `-OutputFormat json` と `-OutputFile` の併用時に同一 JSON が出力/保存されることを確認
- 結果: PASS

### Regression Test

- 実施内容: 既定 `text` モードで従来の `CHECK_RESULT` ログ形式が維持されることを確認
- 結果: PASS

### Manual Verification

- 実施内容:
  1. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-18__project-profile-schema-validation`
  2. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-18__project-profile-schema-validation -OutputFormat json`
  3. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-18__project-profile-schema-validation -OutputFormat json -OutputFile <temp-path>`
- 結果: PASS

## 4. 指摘事項

- 重大: なし
- 改善提案:
  - JSON schema version を持たせる

## 5. 結論

- 本タスクは `done` 判定とする。

## 6. プロセス改善案 (Process Findings) (必須)

### 6.1 Finding F-001

- finding_id: F-001
- category: quality
- severity: low
- summary: JSON スキーマversionは未導入のため、将来拡張時に互換方針を明文化する余地がある。
- evidence: `tools/consistency-check/check.ps1` の JSON payload は version field を持たない。
- action_required: no
- linked_task_id: none
