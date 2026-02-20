# Plan: 2026-02-20__dq002-wave-b-fix-profile-validator-schema-policy-links

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/dq002-warning-remediation-priority-plan.md`
  - `work/2026-02-20__dq002-wave-b-fix-profile-validator-schema-policy-links/spec.md`
- 理解ポイント:
  - Wave B は depends_on 解決まで `dependency-blocked` を維持する。

## 1. 対象仕様

- `work/2026-02-20__dq002-wave-b-fix-profile-validator-schema-policy-links/spec.md`

## 2. plan-draft

- 目的:
  - Wave B 対象 3 件を解消し、全体 `dq002_count` を 9 から 6 へ減らす。
- 実施項目:
  1. `docs/operations/profile-validator-schema-version-policy.md` の関連リンク不足を補完する。
  2. Wave B 完了後の全体件数を再集計する。
  3. backlog と MEMORY を Wave C 着手条件へ同期する。
- 成果物:
  - 修正済み Wave B 対象 docs
  - 検証結果（Wave B: 3 -> 0、全体: 9 -> 6）

## 3. depends_on gate

- 依存: `2026-02-20__dq002-wave-a-fix-automation-tools-design-spec-links`
- 判定方針: 依存 task が done なら `plan-ready`、未完了なら `dependency-blocked`
- 判定結果: pass（Wave A 完了を確認）

## 4. plan-final

- 実装順序:
  1. `docs/operations/profile-validator-schema-version-policy.md` に `関連資料リンク` を追加し、`docs/*` と `work/*` を明示する。
  2. Wave B task の `plan.md` / `review.md` / `state.json` を実績ベースへ更新する。
  3. backlog と MEMORY を Wave C 着手可能な状態へ同期する。
- 検証順序:
  1. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__dq002-wave-b-fix-profile-validator-schema-policy-links -DocQualityMode warning`
  2. `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__dq002-wave-b-fix-profile-validator-schema-policy-links -DocQualityMode warning`
  3. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks -DocQualityMode warning -OutputFormat json`（`dq002_count=6` を確認）
  4. `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`
- ロールバック:
  - DQ-002 が残る場合は追加したリンク構成を見直し、`work/*` 参照の不足を補完して再検証する。

## 5. Execution Commands

- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__dq002-wave-b-fix-profile-validator-schema-policy-links -DocQualityMode warning`
- `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__dq002-wave-b-fix-profile-validator-schema-policy-links -DocQualityMode warning`
- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks -DocQualityMode warning -OutputFormat json`
- `pwsh -NoProfile -File tools/commit-boundary/check-staged-files.ps1 -TaskId 2026-02-20__dq002-wave-b-fix-profile-validator-schema-policy-links -Phase kickoff -AllowCommonSharedPaths`

## 6. 完了判定

- AC-001（Wave B 3件 -> 0件）が review で PASS
- AC-002（全体 9件 -> 6件）が review で PASS
- `state.json` が `done` である
- backlog で Wave C が `plan-ready` へ遷移している
