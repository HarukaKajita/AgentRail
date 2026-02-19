# Plan: 2026-02-20__add-sidecar-log-rule-to-visual-guide

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `work/2026-02-20__add-sidecar-log-rule-to-visual-guide/request.md`
  - `work/2026-02-20__add-sidecar-log-rule-to-visual-guide/spec.md`
- 理解ポイント:
  - spec の受入条件とテスト要件に沿って実装順序を固定する。

## 1. 対象仕様

- `work/2026-02-20__add-sidecar-log-rule-to-visual-guide/spec.md`

## 2. plan-draft

- 目的:
  - "可視化ガイドの委譲契約に sidecar 監査ログ要件が欠落している。" を最小差分で解消する手順を確定する。
- 実施項目:
  1. 再現条件を確認する。
  2. 変更対象を絞り込む。
  3. 修正差分を作成する。
- 成果物:
  - 対象不備を解消する実装差分。

## 3. depends_on gate

- 依存: なし
- 判定方針:
  - 依存 task がある場合は state=done を確認してから plan-final に進む。

## 4. plan-final

- 実装順序:
  1. 変更を実装する。
  2. 必要 docs を更新する。
  3. consistency/state/docs チェックを実行する。
  4. review と state を更新する。
- ロールバック:
  - 不整合が発生した場合は該当差分のみ取り下げて原因を再調査する。

## 5. Execution Commands

- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__add-sidecar-log-rule-to-visual-guide`
- `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__add-sidecar-log-rule-to-visual-guide`
- `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`

## 6. 完了判定

- AC-001 から AC-003 が `work/2026-02-20__add-sidecar-log-rule-to-visual-guide/review.md` で PASS になる。
- 対象 task の検証コマンドが成功する。
