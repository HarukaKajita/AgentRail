# Plan: 2026-02-20__wave1-normalize-doc-work-cross-links

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `docs/operations/wave1-core-docs-human-centric-migration.md`
  - `docs/operations/wave1-operations-docs-human-centric-migration.md`
  - `work/2026-02-20__wave1-normalize-doc-work-cross-links/spec.md`
- 理解ポイント:
  - 本タスクは Wave 1 の締めとして docs/work 相互参照の表記を統一する。

## 1. 対象仕様

- `work/2026-02-20__wave1-normalize-doc-work-cross-links/spec.md`

## 2. plan-draft

- 目的: docs と work の相互参照を統一し、参照切れを解消する。
- 実施項目:
  1. 相互リンク表記の標準ルール（path 記法、配置場所、関連資料節）を定義する。
  2. Wave 1 で追加した主要 docs に統一ルールを適用する。
  3. 正規化結果を docs と task に記録し、Wave 2 着手条件を整える。
- 成果物:
  - `docs/operations/wave1-doc-work-cross-link-normalization.md`
  - 主要 migration docs への正規化反映
  - task 成果物 6 ファイル + backlog/MEMORY 更新

## 3. depends_on gate

- 依存: 2026-02-20__wave1-migrate-core-docs-to-human-centric-model, 2026-02-20__wave1-migrate-operations-docs-to-human-centric-model
- 判定方針: depends_on が全て done になるまで dependency-blocked を維持する。
- 判定結果: pass（依存タスクが done）

## 4. plan-final

- 実行フェーズ:
  1. 準備: 正規化対象 docs と標準記法を定義する。
  2. 実施: 対象 docs の相互参照表記を統一し、欠落リンクを補完する。
  3. 記録: `docs/operations/wave1-doc-work-cross-link-normalization.md` に結果を記録する。
  4. 整合: `spec.md`、`review.md`、`state.json`、`docs/operations/high-priority-backlog.md`、`MEMORY.md` を更新する。
  5. 検証: consistency/state/docs-indexer を実行する。
- 検証順序:
  1. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskIds 2026-02-20__wave1-migrate-core-docs-to-human-centric-model,2026-02-20__wave1-migrate-operations-docs-to-human-centric-model,2026-02-20__wave1-normalize-doc-work-cross-links`
  2. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__wave1-normalize-doc-work-cross-links`
  3. `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__wave1-normalize-doc-work-cross-links`
  4. `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks`
  5. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks`
  6. `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`
- ロールバック: 正規化により可読性が低下した場合は本文側を元に戻し、標準ルール docs だけを残して再適用方針を調整する。

## 5. Execution Commands

- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskIds 2026-02-20__wave1-migrate-core-docs-to-human-centric-model,2026-02-20__wave1-migrate-operations-docs-to-human-centric-model,2026-02-20__wave1-normalize-doc-work-cross-links`
- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__wave1-normalize-doc-work-cross-links`
- `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__wave1-normalize-doc-work-cross-links`
- `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks`
- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks`
- `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`

## 6. 完了判定

- AC-001/AC-002 の判定結果を `work/2026-02-20__wave1-normalize-doc-work-cross-links/review.md` に記録する。
- Wave 2 先行タスク（`2026-02-20__wave2-spec-doc-quality-check-rules`）が plan-ready に更新される。
