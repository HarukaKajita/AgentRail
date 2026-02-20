# Plan: 2026-02-20__dq002-wave-a-fix-automation-tools-design-spec-links

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/dq002-warning-remediation-priority-plan.md`
  - `work/2026-02-20__dq002-wave-a-fix-automation-tools-design-spec-links/spec.md`
- 理解ポイント:
  - 起票段階では plan-draft まで確定し、実装時に plan-final を更新する。

## 1. 対象仕様

- `work/2026-02-20__dq002-wave-a-fix-automation-tools-design-spec-links/spec.md`

## 2. plan-draft

- 目的:
  - Wave A 対象ファイルの DQ-002 warning 12 件を 0 件にする。
- 実施項目:
  1. `docs/specs/automation-tools-design-spec.md` の関連リンク節を修正する。
  2. 修正後の `dq002_count` を全体で再集計する。
  3. backlog と MEMORY を Wave B 着手可能な状態へ同期する。
- 成果物:
  - 修正済み docs
  - 検証結果（Wave A: 12 -> 0、全体: 21 -> 9）

## 3. depends_on gate

- 依存: なし
- 判定方針: 依存なしのため `plan-ready`
- 判定結果: pass（起票時点）

## 4. plan-final

- 実装順序:
  1. `docs/specs/automation-tools-design-spec.md` に `関連資料リンク` セクションを追加し、`docs/*` と `work/*` の導線を明示する。
  2. Wave A task の `plan.md` / `review.md` / `state.json` を実績ベースへ更新する。
  3. backlog と MEMORY を Wave B 着手可能な状態へ同期する。
- 検証順序:
  1. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__dq002-wave-a-fix-automation-tools-design-spec-links -DocQualityMode warning`
  2. `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__dq002-wave-a-fix-automation-tools-design-spec-links -DocQualityMode warning`
  3. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks -DocQualityMode warning -OutputFormat json`（`dq002_count=9` を確認）
  4. `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`
- ロールバック:
  - DQ-002 が残る場合は追加したリンク構成を見直し、`work/*` 参照を不足なく補完して再検証する。

## 5. Execution Commands

- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__dq002-wave-a-fix-automation-tools-design-spec-links -DocQualityMode warning`
- `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__dq002-wave-a-fix-automation-tools-design-spec-links -DocQualityMode warning`
- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks -DocQualityMode warning -OutputFormat json`
- `pwsh -NoProfile -File tools/commit-boundary/check-staged-files.ps1 -TaskId 2026-02-20__dq002-wave-a-fix-automation-tools-design-spec-links -Phase kickoff -AllowCommonSharedPaths`

## 6. 完了判定

- AC-001（Wave A 12件 -> 0件）が review で PASS
- AC-002（全体 21件 -> 9件）が review で PASS
- `state.json` が `done` である
- backlog で Wave B が `plan-ready` へ遷移している
