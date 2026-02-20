# Plan: 2026-02-20__wave0-inventory-human-centric-doc-coverage

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/human-centric-doc-bank-governance.md`
  - `docs/operations/human-centric-doc-bank-migration-plan.md`
  - `work/2026-02-20__wave0-inventory-human-centric-doc-coverage/spec.md`
- 理解ポイント:
  - Wave 0: must対象の資料棚卸しと欠落マップ作成 は wave 計画に従う実行タスクである。

## 1. 対象仕様

- `work/2026-02-20__wave0-inventory-human-centric-doc-coverage/spec.md`

## 2. plan-draft

- 目的: must対象資料の棚卸しと欠落カテゴリ（目的/使い方/仕組み/実装/関連）の可視化を行う。
- 実施項目:
  1. 対象成果物と更新責務を確定する。
  2. depends_on gate と検証順序を確定する。
  3. review/state/backlog 連携を確定する。
- 成果物:
  - task 成果物 6 ファイル
  - 必要な docs 導線更新
  - 検証結果記録

## 3. depends_on gate

- 依存: 2026-02-20__plan-migration-to-human-centric-doc-bank
- 判定方針: depends_on が全て done になるまで dependency-blocked を維持する。
- 判定結果: pass（依存タスクが done）

## 4. plan-final

- 実行フェーズ:
  1. 準備: 対象と責務の確認
  2. 実施: 文書更新と整合反映
  3. 検証: consistency/state/docs-indexer 実行
  4. 確定: review/state/backlog/MEMORY 更新
- 検証順序:
  1. pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskIds 2026-02-20__plan-migration-to-human-centric-doc-bank,2026-02-20__wave0-inventory-human-centric-doc-coverage
  2. pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__wave0-inventory-human-centric-doc-coverage
  3. pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__wave0-inventory-human-centric-doc-coverage
  4. pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check
- ロールバック: 依存や導線に不整合が出た場合は state を blocked/planned に戻して再計画する。

## 5. Execution Commands

- pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskIds 2026-02-20__plan-migration-to-human-centric-doc-bank,2026-02-20__wave0-inventory-human-centric-doc-coverage
- pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__wave0-inventory-human-centric-doc-coverage
- pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__wave0-inventory-human-centric-doc-coverage
- pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check

## 6. 完了判定

- AC-001/AC-002 の判定結果を `work/2026-02-20__wave0-inventory-human-centric-doc-coverage/review.md` に記録する。
- depends_on と backlog/state/plan の整合が維持される。

