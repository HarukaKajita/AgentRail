# Plan: 2026-02-20__wave2-spec-doc-quality-check-rules

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `docs/operations/wave1-doc-work-cross-link-normalization.md`
  - `work/2026-02-20__wave2-spec-doc-quality-check-rules/spec.md`
- 理解ポイント:
  - Wave 2 の先頭タスクとして、warning/fail 導入の前提仕様を確定する。

## 1. 対象仕様

- `work/2026-02-20__wave2-spec-doc-quality-check-rules/spec.md`

## 2. plan-draft

- 目的: consistency-check / state-validate へ追加する docs 品質チェック仕様を設計する。
- 実施項目:
  1. docs 品質ルール対象（リンク、前提知識、更新同期）を定義する。
  2. warning/fail の段階導入方針を定義する。
  3. 後続タスクで使う引き継ぎ情報を記録する。
- 成果物:
  - `docs/operations/wave2-doc-quality-check-rules-spec.md`
  - task 成果物 6 ファイル + backlog/MEMORY 同期

## 3. depends_on gate

- 依存: 2026-02-20__wave1-normalize-doc-work-cross-links
- 判定方針: depends_on が全て done になるまで dependency-blocked を維持する。
- 判定結果: pass（依存タスクが done）

## 4. plan-final

- 実行フェーズ:
  1. 準備: Wave 1 の正規化ルールを入力に品質判定観点を定義する。
  2. 実施: 仕様 docs を作成し、warning/fail の適用順を明文化する。
  3. 整合: `spec.md`、`review.md`、`state.json`、`docs/operations/high-priority-backlog.md`、`MEMORY.md` を更新する。
  4. 検証: consistency/state/docs-indexer を実行する。
- 検証順序:
  1. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskIds 2026-02-20__wave1-normalize-doc-work-cross-links,2026-02-20__wave2-spec-doc-quality-check-rules`
  2. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__wave2-spec-doc-quality-check-rules`
  3. `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__wave2-spec-doc-quality-check-rules`
  4. `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks`
  5. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks`
  6. `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`
- ロールバック: 仕様が過剰複雑化した場合はルールを最小セットへ戻し、warning 導入時に段階追加する。

## 5. Execution Commands

- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskIds 2026-02-20__wave1-normalize-doc-work-cross-links,2026-02-20__wave2-spec-doc-quality-check-rules`
- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__wave2-spec-doc-quality-check-rules`
- `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__wave2-spec-doc-quality-check-rules`
- `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks`
- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks`
- `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`

## 6. 完了判定

- AC-001/AC-002 の判定結果を `work/2026-02-20__wave2-spec-doc-quality-check-rules/review.md` に記録する。
- `2026-02-20__wave2-implement-doc-quality-warning-mode` が plan-ready に更新される。
