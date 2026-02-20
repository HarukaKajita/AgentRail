# Plan: 2026-02-20__wave0-inventory-human-centric-doc-coverage

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/human-centric-doc-bank-governance.md`
  - `docs/operations/human-centric-doc-bank-migration-plan.md`
  - `work/2026-02-20__wave0-inventory-human-centric-doc-coverage/spec.md`
- 理解ポイント:
  - Wave 0: must対象の資料棚卸しと欠落マップ作成 は wave 計画に従う実行タスクである。

## 1. 対象仕様

- `work/2026-02-20__wave0-inventory-human-centric-doc-coverage/spec.md`

## 2. 実装計画ドラフト (Plan Draft)

- 目的: must対象資料の棚卸しと欠落カテゴリ（目的/使い方/仕組み/実装/関連）の可視化を行う。
- 実施項目:
  1. must 対象資料（AGENTS/README/docs/operations 主要資料）の棚卸し範囲を確定する。
  2. 資料ごとの欠落カテゴリをマッピングし、優先補完先を明確化する。
  3. 後続 Wave 1 へ引き継ぐための成果物を docs と task へ記録する。
- 成果物:
  - `docs/operations/wave0-inventory-human-centric-doc-coverage.md`
  - task 成果物 6 ファイルの整合更新
  - backlog / docs index / MEMORY の同期更新

## 3. depends_on gate

- 依存: 2026-02-20__plan-migration-to-human-centric-doc-bank
- 判定方針: depends_on が全て done になるまで dependency-blocked を維持する。
- 判定結果: pass（依存タスクが done）

## 4. 確定実装計画 (Plan Final)

- 実行フェーズ:
  1. 準備: wave 計画の must 対象と分類軸（目的/使い方/仕組み/実装/関連）を固定する。
  2. 実施: 対象資料一覧と欠落マップを `docs/operations/wave0-inventory-human-centric-doc-coverage.md` に記録する。
  3. 整合: `spec/review/state/backlog/docs index/MEMORY` を更新して後続タスク着手条件を同期する。
  4. 検証: consistency/state/docs-indexer を実行して完了条件を確認する。
- 検証順序:
  1. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskIds 2026-02-20__plan-migration-to-human-centric-doc-bank,2026-02-20__wave0-inventory-human-centric-doc-coverage`
  2. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__wave0-inventory-human-centric-doc-coverage`
  3. `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__wave0-inventory-human-centric-doc-coverage`
  4. `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks`
  5. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks`
  6. `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`
- ロールバック: 欠落分類や導線整合に不整合が出た場合は state を `planned` に戻し、分類基準を再定義して再実施する。

## 5. Execution Commands

- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskIds 2026-02-20__plan-migration-to-human-centric-doc-bank,2026-02-20__wave0-inventory-human-centric-doc-coverage`
- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__wave0-inventory-human-centric-doc-coverage`
- `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__wave0-inventory-human-centric-doc-coverage`
- `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks`
- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks`
- `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`

## 6. 完了判定

- AC-001/AC-002 の判定結果を `work/2026-02-20__wave0-inventory-human-centric-doc-coverage/review.md` に記録する。
- Wave 0 成果物が `docs/operations/wave0-inventory-human-centric-doc-coverage.md` として公開され、後続 Wave 1 の依存解除が反映される。
