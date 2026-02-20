# Plan: 2026-02-20__split-framework-runtime-rules-from-agents

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `work/2026-02-20__split-framework-runtime-rules-from-agents/spec.md`
- 理解ポイント:
  - 実装前に depends_on とゲート状態を確認する。

## 1. 対象仕様

- `work/2026-02-20__split-framework-runtime-rules-from-agents/spec.md`

## 2. plan-draft

- 目的: フレームワーク動作必須ルールを専用ファイルへ分離し、AGENTS.md は要旨と参照導線に整理する。
- 実施項目:
  1. 現行構成の問題箇所を再確認し、変更境界を固定する。
  2. spec の受入条件を満たす実装差分を最小単位で設計する。
  3. 実装後の検証コマンドとレビュー観点を確定する。
- 成果物: 変更対象一覧、実装手順、検証手順

## 3. depends_on gate

- 依存: `2026-02-20__add-runtime-installer-with-agentrail-work-layout`
- 判定方針: 依存タスクがすべて done になるまで dependency-blocked を維持する。
- 判定結果: pass（依存タスクが `done` であることを確認）

## 4. plan-final

- 実装順序:
  1. 仕様・ルールの更新
  2. スクリプト/設定の更新
  3. docs/index/backlog/state の整合更新
- 検証順序:
  1. `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__split-framework-runtime-rules-from-agents`
  2. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__split-framework-runtime-rules-from-agents`
  3. 影響範囲の回帰チェック
- ロールバック: 対象コミットを単位に戻し、spec と plan を再確認して再実装する

## 5. Execution Commands

- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__split-framework-runtime-rules-from-agents`
- `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__split-framework-runtime-rules-from-agents`
- `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`

## 6. 完了判定

- 受入条件の判定結果を `work/2026-02-20__split-framework-runtime-rules-from-agents/review.md` に記録する。
- 対象 task の検証コマンドが成功する。
