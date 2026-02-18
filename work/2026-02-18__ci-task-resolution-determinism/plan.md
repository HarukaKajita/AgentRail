# Plan: 2026-02-18__ci-task-resolution-determinism

## 1. 対象仕様

- `work/2026-02-18__ci-task-resolution-determinism/spec.md`

## 2. Execution Commands

- validation: `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-18__ci-task-resolution-determinism`
- index update: `pwsh -NoProfile -File tools/docs-indexer/index.ps1`

## 3. 実施ステップ

1. CI の task-id 解決ロジックを差分ベースへ置換する。
2. workflow_dispatch 入力の優先解決を追加する。
3. 曖昧ケース（複数task）で明示的に失敗させる。
4. docs仕様を更新し、INDEXを更新する。
5. review と state を更新する。

## 4. 変更対象ファイル

- `.github/workflows/ci-framework.yml`
- `docs/specs/automation-tools-ci-integration-spec.md`
- `docs/INDEX.md`
- `work/2026-02-18__ci-task-resolution-determinism/*`

## 5. リスクとロールバック

- リスク: 差分取得ロジックがイベント種別で失敗する
- ロールバック: 直前の latest 1件方式へ一時復帰し、追加ログを入れて再修正

## 6. 完了判定

- AC-001〜AC-005 がすべて PASS
