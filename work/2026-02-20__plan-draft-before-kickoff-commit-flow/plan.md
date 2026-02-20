# Plan: 2026-02-20__plan-draft-before-kickoff-commit-flow

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `work/2026-02-20__plan-draft-before-kickoff-commit-flow/request.md`
  - `work/2026-02-20__plan-draft-before-kickoff-commit-flow/spec.md`
- 理解ポイント:
  - `plan-draft` は kickoff 境界の前に確定し、`plan-final` は depends_on gate pass 後に確定する。

## 1. 対象仕様

- `work/2026-02-20__plan-draft-before-kickoff-commit-flow/spec.md`

## 2. 実装計画ドラフト (Plan Draft)

- 目的:
  - 可視化ガイドと skills flow guide の順序不整合を解消する実装方針を確定する。
- 実施項目:
  1. `docs/operations/framework-request-to-commit-visual-guide.md` の mermaid 順序を修正する。
  2. 同資料の工程説明・コミット境界説明を順序に合わせて修正する。
  3. `docs/operations/skills-framework-flow-guide.md` に kickoff 前提（plan-draft 完了）を明示する。
- 成果物:
  - docs 2ファイルの順序定義一貫化。

## 3. depends_on gate

- 確認対象:
  - `2026-02-19__task-commit-boundary-automation-flow`
  - `2026-02-19__task-dependency-aware-prioritization-flow`
  - `2026-02-20__dependency-gate-before-plan-flow`
- 判定:
  - 依存先はすべて `done` のため `plan-ready`。

## 4. 確定実装計画 (Plan Final)

- 実装順序:
  1. docs 修正を実施する。
  2. `tools/consistency-check/check.ps1 -TaskId 2026-02-20__plan-draft-before-kickoff-commit-flow` を実行する。
  3. `tools/consistency-check/check.ps1 -AllTasks` を実行する。
  4. `tools/state-validate/validate.ps1 -AllTasks` を実行する。
  5. `tools/docs-indexer/index.ps1 -Mode check` を実行する。
  6. `review.md` / `state.json` / backlog / MEMORY を更新して finalize する。
- ロールバック:
  - docs 更新に不整合が出た場合、該当2ファイルのみを差し戻して順序説明を再調整する。

## 5. Execution Commands

- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__plan-draft-before-kickoff-commit-flow`
- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks`
- `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks`
- `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`

## 6. 完了判定

- AC-001〜AC-005 が `review.md` で PASS になる。
- 全体整合チェック（consistency/state/docs-indexer）が PASS する。
