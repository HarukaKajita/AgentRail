# Plan: 2026-02-20__wave1-migrate-operations-docs-to-human-centric-model

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `docs/operations/wave0-inventory-human-centric-doc-coverage.md`
  - `docs/operations/wave1-core-docs-human-centric-migration.md`
  - `work/2026-02-20__wave1-migrate-operations-docs-to-human-centric-model/spec.md`
- 理解ポイント:
  - operations docs 補完は Wave 1 normalize の前提であり、説明粒度を先に統一する。

## 1. 対象仕様

- `work/2026-02-20__wave1-migrate-operations-docs-to-human-centric-model/spec.md`

## 2. plan-draft

- 目的: `docs/operations` の主要資料を情報モデルに合わせて補完・再編する。
- 実施項目:
  1. Wave 0 の欠落カテゴリを operations docs の対象にマッピングする。
  2. runbook/guide/rules/backlog の主要資料へ共通導線を追記する。
  3. 移行結果を集約した operations migration 記録 docs を作成する。
- 成果物:
  - `docs/operations/wave1-operations-docs-human-centric-migration.md`
  - 主要 operations docs への導線補完
  - task 成果物 6 ファイル + backlog/MEMORY 同期

## 3. depends_on gate

- 依存: 2026-02-20__wave0-inventory-human-centric-doc-coverage
- 判定方針: depends_on が全て done になるまで dependency-blocked を維持する。
- 判定結果: pass（依存タスクが done）

## 4. plan-final

- 実行フェーズ:
  1. 準備: 対象 operations docs の不足カテゴリを確定する。
  2. 実施: 主要 docs に人間理解導線（目的/使い方/仕組み/実装/関連）を補完する。
  3. 記録: `docs/operations/wave1-operations-docs-human-centric-migration.md` に移行内容を記録する。
  4. 整合: `spec.md`、`review.md`、`state.json`、`docs/operations/high-priority-backlog.md`、`MEMORY.md` を更新する。
  5. 検証: consistency/state/docs-indexer を実行する。
- 検証順序:
  1. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskIds 2026-02-20__wave0-inventory-human-centric-doc-coverage,2026-02-20__wave1-migrate-operations-docs-to-human-centric-model`
  2. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__wave1-migrate-operations-docs-to-human-centric-model`
  3. `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__wave1-migrate-operations-docs-to-human-centric-model`
  4. `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks`
  5. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks`
  6. `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`
- ロールバック: 既存運用手順の可読性が悪化した場合は追記セクションを最小化し、詳細説明を migration 記録 docs に退避する。

## 5. Execution Commands

- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskIds 2026-02-20__wave0-inventory-human-centric-doc-coverage,2026-02-20__wave1-migrate-operations-docs-to-human-centric-model`
- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__wave1-migrate-operations-docs-to-human-centric-model`
- `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__wave1-migrate-operations-docs-to-human-centric-model`
- `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks`
- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks`
- `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`

## 6. 完了判定

- AC-001/AC-002 の判定結果を `work/2026-02-20__wave1-migrate-operations-docs-to-human-centric-model/review.md` に記録する。
- operations docs 補完が完了し、`2026-02-20__wave1-normalize-doc-work-cross-links` の依存が解決済みになる。
