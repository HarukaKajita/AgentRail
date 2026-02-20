# Review: 2026-02-18__docs-indexer-check-mode

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 1. レビュー対象

- `tools/docs-indexer/index.ps1`
- `.github/workflows/ci-framework.yml`

## 2. 受入条件評価

- AC-001: PASS
- AC-002: PASS
- AC-003: PASS
- AC-004: PASS

## 3. テスト結果

### Unit Test

- 実施内容:
  1. 一時ディレクトリで `-Mode apply` 実行（終了コード0）
  2. 同一入力で `-Mode check` 実行（終了コード0）
  3. docsタイトル改変後に `-Mode check` 実行（終了コード1）
- 結果: PASS

### Integration Test

- 実施内容: `.github/workflows/ci-framework.yml` の docs step が `tools/docs-indexer/index.ps1 -Mode check` 呼び出しに切り替わったことを確認
- 結果: PASS

### Regression Test

- 実施内容: `-Mode apply` 実行後の `docs/INDEX.md` が生成され、従来の管理セクション更新が維持されることを確認
- 結果: PASS

### Manual Verification

- 実施内容:
  1. `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode apply`
  2. `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`
  3. workflow の docs step 設定確認
- 結果: PASS

## 4. 指摘事項

- 重大: なし
- 改善提案:
  - `--verbose` の将来追加を検討

## 5. 結論

- 本タスクは `done` 判定とする。

## 6. プロセス改善案 (Process Findings) (必須)

### 6.1 Finding F-001

- finding_id: F-001
- category: flow
- severity: low
- summary: `check` モードの差分詳細は要点のみのため、大規模差分時は追加ログが欲しくなる可能性がある。
- evidence: `tools/docs-indexer/index.ps1` は Summary の件数/パスのみ出力する。
- action_required: no
- linked_task_id: none
