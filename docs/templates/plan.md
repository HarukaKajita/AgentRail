# 計画テンプレート

このテンプレートは `work/<task-id>/plan.md` で利用します。

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 実装着手前に確認すべき前提・依存関係・制約を記載する。

## 1. 対象仕様

- `work/<task-id>/spec.md`

## 2. plan-draft

- 目的:
- 実施項目:
  1. 
  2. 
  3. 
- 成果物:

## 3. depends_on gate

- 依存:
- 判定方針:

## 4. plan-final

- 実装順序:
  1. 
  2. 
  3. 
- 検証順序:
  1. 
  2. 
- ロールバック:

## 5. Execution Commands

- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId <task-id>`
- `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId <task-id>`
- `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`

## 6. 完了判定

- 受入条件の判定結果を `work/<task-id>/review.md` に記録する。
- 対象 task の検証コマンドが成功する。
