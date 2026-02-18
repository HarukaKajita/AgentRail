# Plan: 2026-02-18__framework-request-to-commit-visual-guide

## 1. 対象仕様

- `work/2026-02-18__framework-request-to-commit-visual-guide/spec.md`

## 2. Execution Commands

- index update: `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode apply`
- consistency check: `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-18__framework-request-to-commit-visual-guide`

## 3. 実施ステップ

1. 新規資料 docs/operations/framework-request-to-commit-visual-guide.md を作成する。
2. Mermaid フローチャートと工程解説を記述する。
3. CLI 要望サンプルと AI 応答サンプルを追記する。
4. `docs/INDEX.md` の導線を更新する。
5. task 資料（review/state）を更新し、整合チェックを実行する。

## 4. 変更対象ファイル

- docs/operations/framework-request-to-commit-visual-guide.md
- `docs/INDEX.md`
- `work/2026-02-18__framework-request-to-commit-visual-guide/*`

## 5. リスクとロールバック

- リスク: 図だけでは運用判断に必要な情報が不足する。
- ロールバック: 図を維持したまま、工程解説とサンプルを優先して補強する。

## 6. 完了判定

- AC-001〜AC-004 がすべて PASS。
- `docs/INDEX.md` から新規資料へ遷移できる。

## 7. 実装実行計画（2026-02-19T00:36:44+09:00）

1. 新規資料を作成し、Mermaid 図と工程解説を記述する。
2. docs 改善題材の CLI/AI サンプルを追加する。
3. `docs-indexer` と `consistency-check` を実行して整合を確認する。
4. `review.md` と `state.json` を更新して完了判定を記録する。
