# Plan: 2026-02-20__wave2-implement-doc-quality-warning-mode

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/wave2-doc-quality-check-rules-spec.md`
  - `work/2026-02-20__wave2-implement-doc-quality-warning-mode/spec.md`
- 理解ポイント:
  - warning 段階は終了コード非影響で観測値を蓄積する。

## 1. 対象仕様

- `work/2026-02-20__wave2-implement-doc-quality-warning-mode/spec.md`

## 2. plan-draft

- 目的: docs品質ルールを warning mode で導入し、fail 昇格の土台を揃える。
- 実施項目:
  1. validator へ `DocQualityMode` を追加する。
  2. DQ-001〜DQ-004 を warning 形式で出力する。
  3. warning mode 運用ガイドと backlog/state/MEMORY を更新する。
- 成果物:
  - `tools/consistency-check/check.ps1`
  - `tools/state-validate/validate.ps1`
  - `docs/operations/wave2-doc-quality-warning-mode.md`
  - task 文書一式

## 3. depends_on gate

- 依存: `2026-02-20__wave2-spec-doc-quality-check-rules`
- 判定方針: 依存 task が `done` の場合のみ実装着手する。
- 判定結果: pass（`2026-02-20__wave2-spec-doc-quality-check-rules[done]`）

## 4. plan-final

- 実行フェーズ:
  1. 実装: 2 validator へ `DocQualityMode` と summary 出力を追加
  2. 文書化: warning mode 運用資料と task 文書を更新
  3. 検証: unit/integration/regression/manual を実行
  4. 同期: backlog/state/MEMORY を更新
- 検証順序:
  1. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__wave2-implement-doc-quality-warning-mode -DocQualityMode warning`
  2. `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__wave2-implement-doc-quality-warning-mode -DocQualityMode warning`
  3. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskIds 2026-02-20__wave2-spec-doc-quality-check-rules,2026-02-20__wave2-implement-doc-quality-warning-mode -DocQualityMode warning`
  4. `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks -DocQualityMode warning`
  5. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks -DocQualityMode warning`
  6. `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`
- ロールバック:
  - warning mode 導入で不整合が発生した場合は `DocQualityMode off` で一時切り戻し、DQ ルール実装差分を再調整する。

## 5. Execution Commands

- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__wave2-implement-doc-quality-warning-mode -DocQualityMode warning`
- `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__wave2-implement-doc-quality-warning-mode -DocQualityMode warning`
- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskIds 2026-02-20__wave2-spec-doc-quality-check-rules,2026-02-20__wave2-implement-doc-quality-warning-mode -DocQualityMode warning`
- `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks -DocQualityMode warning`
- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks -DocQualityMode warning`
- `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`

## 6. 完了判定

- AC-001〜AC-004 が review で PASS となる。
- `state.json` は `done`、`docs/operations/high-priority-backlog.md` は task7 を Completed へ移動。
- 次タスク `2026-02-20__wave2-enforce-doc-quality-fail-mode` が plan-ready で着手可能になる。
