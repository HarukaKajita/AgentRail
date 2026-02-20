# Plan: 2026-02-20__dq002-wave-c-fix-remaining-doc-links

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/dq002-warning-remediation-priority-plan.md`
  - `work/2026-02-20__dq002-wave-c-fix-remaining-doc-links/spec.md`
- 理解ポイント:
  - Wave C は depends_on 解決後に実施する最終バッチ。

## 1. 対象仕様

- `work/2026-02-20__dq002-wave-c-fix-remaining-doc-links/spec.md`

## 2. 実装計画ドラフト (Plan Draft)

- 目的:
  - 残存 6 件を解消し、全体 `dq002_count=0` を達成する。
- 実施項目:
  1. Wave C 対象 6 ファイルの関連リンクを補完する。
  2. 全体集計で DQ-002 ゼロ化を確認する。
  3. backlog と MEMORY を DQ-002 remediation 完了状態へ同期する。
- 成果物:
  - 修正済み Wave C 対象 docs
  - 検証結果（Wave C: 6 -> 0、全体: 6 -> 0）

## 3. depends_on gate

- 依存: `2026-02-20__dq002-wave-b-fix-profile-validator-schema-policy-links`
- 判定方針: 依存 task が done なら `plan-ready`、未完了なら `dependency-blocked`
- 判定結果: pass（Wave B 完了を確認）

## 4. 確定実装計画 (Plan Final)

- 実装順序:
  1. Wave C 対象 6 ファイルに `関連資料リンク` セクションを追加し、`docs/*` と `work/*` を明示する。
  2. Wave C task の `plan.md` / `review.md` / `state.json` を実績ベースへ更新する。
  3. backlog と MEMORY を DQ-002 remediation 完了状態へ同期する。
- 検証順序:
  1. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__dq002-wave-c-fix-remaining-doc-links -DocQualityMode warning`
  2. `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__dq002-wave-c-fix-remaining-doc-links -DocQualityMode warning`
  3. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks -DocQualityMode warning -OutputFormat json`（`dq002_count=0` を確認）
  4. `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`
- ロールバック:
  - DQ-002 が残る場合は対象ファイルごとに関連リンクを追加補完し、残件が 0 になるまで再検証する。

## 5. Execution Commands

- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__dq002-wave-c-fix-remaining-doc-links -DocQualityMode warning`
- `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__dq002-wave-c-fix-remaining-doc-links -DocQualityMode warning`
- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks -DocQualityMode warning -OutputFormat json`
- `pwsh -NoProfile -File tools/commit-boundary/check-staged-files.ps1 -TaskId 2026-02-20__dq002-wave-c-fix-remaining-doc-links -Phase kickoff -AllowCommonSharedPaths`

## 6. 完了判定

- AC-001（Wave C 6件 -> 0件）が review で PASS
- AC-002（全体 `dq002_count=0`）が review で PASS
- `state.json` が `done` である
- backlog の planned 項目が解消されている
