# Plan: 2026-02-20__wave0-define-doc-ownership-and-update-matrix

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/human-centric-doc-bank-governance.md`
  - `docs/operations/human-centric-doc-bank-migration-plan.md`
  - `work/2026-02-20__wave0-define-doc-ownership-and-update-matrix/spec.md`
- 理解ポイント:
  - Wave 0: docs更新責務マトリクス定義 は wave 計画に従う実行タスクである。

## 1. 対象仕様

- `work/2026-02-20__wave0-define-doc-ownership-and-update-matrix/spec.md`

## 2. plan-draft

- 目的: task owner / implementation owner / reviewer の責務を資料単位で定義する。
- 実施項目:
  1. 対象成果物と更新責務を確定する。
  2. depends_on gate と検証順序を確定する。
  3. review/state/backlog 連携を確定する。
- 成果物:
  - task 成果物 6 ファイル
  - 必要な docs 導線更新
  - 検証結果記録

## 3. depends_on gate

- 依存: 2026-02-20__wave0-inventory-human-centric-doc-coverage
- 判定方針: depends_on が全て done になるまで dependency-blocked を維持する。
- 判定結果: pending（依存タスク完了後に pass へ更新）

## 4. plan-final

- 実行フェーズ:
  1. 準備: 対象と責務の確認
  2. 実施: 文書更新と整合反映
  3. 検証: consistency/state/docs-indexer 実行
  4. 確定: review/state/backlog/MEMORY 更新
- 検証順序:
  1. pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskIds 2026-02-20__wave0-inventory-human-centric-doc-coverage,2026-02-20__wave0-define-doc-ownership-and-update-matrix
  2. pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__wave0-define-doc-ownership-and-update-matrix
  3. pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__wave0-define-doc-ownership-and-update-matrix
  4. pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check
- ロールバック: 依存や導線に不整合が出た場合は state を blocked/planned に戻して再計画する。

## 5. Execution Commands

- pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskIds 2026-02-20__wave0-inventory-human-centric-doc-coverage,2026-02-20__wave0-define-doc-ownership-and-update-matrix
- pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__wave0-define-doc-ownership-and-update-matrix
- pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__wave0-define-doc-ownership-and-update-matrix
- pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check

## 6. 完了判定

- AC-001/AC-002 の判定結果を `work/2026-02-20__wave0-define-doc-ownership-and-update-matrix/review.md` に記録する。
- depends_on と backlog/state/plan の整合が維持される。

