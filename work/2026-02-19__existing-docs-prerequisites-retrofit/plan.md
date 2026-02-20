# Plan: 2026-02-19__existing-docs-prerequisites-retrofit

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `work/2026-02-19__existing-docs-prerequisites-retrofit/request.md`
  - `work/2026-02-19__existing-docs-prerequisites-retrofit/spec.md`
- 理解ポイント:
  - `spec.md` の優先度フェーズ（P1-P3）を実装順序へ落とし込む。

## 1. 対象仕様

- `work/2026-02-19__existing-docs-prerequisites-retrofit/spec.md`


## 2. 実装計画ドラフト (Plan Draft)

- 目的: 既存資料の移行と整合性確保
- 実施項目:
  1. 既存ドキュメントの構造修正
- 成果物: 更新済み Markdown ファイル

## 3. 依存関係ゲート (Depends-on Gate)

- 依存: なし
- 判定方針: 直接移行
## 5. 実行コマンド (Execution Commands)

- 棚卸し:
  - `pwsh -NoProfile -Command '<inventory-command>'`
- task consistency:
  - `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-19__existing-docs-prerequisites-retrofit`
- all tasks consistency:
  - `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks`
- state validate:
  - `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks`
- docs index check:
  - `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`

## 4. 確定実装計画 (Plan Final)

1. P1（`docs/operations`、`docs/INDEX.md`、active task）を更新し、task consistency を実行する。
2. P2（`docs/specs`、`docs/investigations`、`docs/decisions`、`docs/README.md`）を更新し、all tasks consistency を実行する。
3. P3（完了済み task 文書）を更新し、state validate と docs index check を実行する。
4. `review.md`、`docs/operations/high-priority-backlog.md`、`MEMORY.md` を更新し、最終レビューを完了する。

## 4. 変更対象ファイル

- `docs/**/*.md`（archive/legacy 除外）
- `work/*/*.md`（archive/legacy 除外）
- `docs/operations/high-priority-backlog.md`
- `work/2026-02-19__existing-docs-prerequisites-retrofit/*`
- `MEMORY.md`

## 5. リスクとロールバック

- リスク:
  - 大量差分でレビュー時に見落としが増える。
  - 前提知識セクションのリンク切れが混入する。
- ロールバック:
  1. フェーズ単位でコミットを分割し、問題フェーズのみ切り戻す。
  2. consistency/state/docs check をフェーズごとに再実行して再適用する。

## 6. 完了判定

- AC-001〜AC-006 が `review.md` で PASS になる。
- `tools/consistency-check/check.ps1 -AllTasks` が PASS する。
- `tools/state-validate/validate.ps1 -AllTasks` が PASS する。
