# Plan: 2026-02-20__fix-invalid-docs-path-in-self-improvement-spec

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `work/2026-02-20__fix-invalid-docs-path-in-self-improvement-spec/request.md`
  - `work/2026-02-20__fix-invalid-docs-path-in-self-improvement-spec/spec.md`
- 理解ポイント:
  - spec の受入条件とテスト要件に沿って実装順序を固定する。

## 1. 対象仕様

- `work/2026-02-20__fix-invalid-docs-path-in-self-improvement-spec/spec.md`

## 2. 実装計画ドラフト (Plan Draft)

- 目的:
  - "self-improvement-loop spec に実在しない docs パス記述がある。" を最小差分で解消する手順を確定する。
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

## 4. 確定実装計画 (Plan Final)

- 実装順序:
  1. 変更を実装する。
  2. 必要 docs を更新する。
  3. consistency/state/docs チェックを実行する。
  4. review と state を更新する。
- ロールバック:
  - 不整合が発生した場合は該当差分のみ取り下げて原因を再調査する。

## 5. Execution Commands

- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__fix-invalid-docs-path-in-self-improvement-spec`
- `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__fix-invalid-docs-path-in-self-improvement-spec`
- `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`

## 6. 完了判定

- AC-001 から AC-003 が `work/2026-02-20__fix-invalid-docs-path-in-self-improvement-spec/review.md` で PASS になる。
- 対象 task の検証コマンドが成功する。
