# Plan: 2026-02-20__wave0-define-doc-ownership-and-update-matrix

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/human-centric-doc-bank-governance.md`
  - `docs/operations/wave0-inventory-human-centric-doc-coverage.md`
  - `work/2026-02-20__wave0-define-doc-ownership-and-update-matrix/spec.md`
- 理解ポイント:
  - Wave 0: docs更新責務マトリクス定義 は Wave 1 以降の docs 更新責務を固定する実行タスクである。

## 1. 対象仕様

- `work/2026-02-20__wave0-define-doc-ownership-and-update-matrix/spec.md`

## 2. plan-draft

- 目的: task owner / implementation owner / reviewer の責務を資料単位で定義する。
- 実施項目:
  1. must 対象資料の責務境界を role 別に定義する。
  2. 変更起点（仕様変更/実装変更/運用変更）ごとの更新責務を明文化する。
  3. Wave 1 以降へ適用する運用チェックリストを確定する。
- 成果物:
  - `docs/operations/wave0-doc-ownership-and-update-matrix.md`
  - task 成果物 6 ファイルの整合更新
  - backlog / docs index / MEMORY の同期更新

## 3. depends_on gate

- 依存: 2026-02-20__wave0-inventory-human-centric-doc-coverage
- 判定方針: depends_on が全て done になるまで dependency-blocked を維持する。
- 判定結果: pass（依存タスクが done）

## 4. plan-final

- 実行フェーズ:
  1. 準備: Wave 0 inventory 結果から対象資料と不足カテゴリを確認する。
  2. 実施: 資料単位の責務マトリクスと更新トリガーを docs に反映する。
  3. 整合: `spec/review/state/backlog/docs index/MEMORY` を更新し、次タスクへの導線を明確化する。
  4. 検証: consistency/state/docs-indexer を実行して完了条件を確認する。
- 検証順序:
  1. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskIds 2026-02-20__wave0-inventory-human-centric-doc-coverage,2026-02-20__wave0-define-doc-ownership-and-update-matrix`
  2. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__wave0-define-doc-ownership-and-update-matrix`
  3. `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__wave0-define-doc-ownership-and-update-matrix`
  4. `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks`
  5. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks`
  6. `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`
- ロールバック: 責務境界に曖昧さが残る場合は state を `planned` に戻し、マトリクス項目を再定義して再実施する。

## 5. Execution Commands

- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskIds 2026-02-20__wave0-inventory-human-centric-doc-coverage,2026-02-20__wave0-define-doc-ownership-and-update-matrix`
- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__wave0-define-doc-ownership-and-update-matrix`
- `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__wave0-define-doc-ownership-and-update-matrix`
- `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks`
- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks`
- `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`

## 6. 完了判定

- AC-001/AC-002 の判定結果を `work/2026-02-20__wave0-define-doc-ownership-and-update-matrix/review.md` に記録する。
- 責務マトリクス docs が公開され、後続 Wave 1 タスクから参照可能な状態になっている。
