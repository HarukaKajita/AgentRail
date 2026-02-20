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
- 判定結果: pending（起票時点）

## 4. plan-final

- 実装順序:
  - 起票段階のため未確定。depends_on 解決後に更新する。
- 検証順序:
  - 起票段階のため未確定。depends_on 解決後に更新する。
- ロールバック:
  - 追加した導線を戻し、配置方針を再調整する。

## 5. Execution Commands

- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__dq002-wave-b-fix-profile-validator-schema-policy-links -DocQualityMode warning`
- `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__dq002-wave-b-fix-profile-validator-schema-policy-links -DocQualityMode warning`
- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks -DocQualityMode warning -OutputFormat json`
- `pwsh -NoProfile -File tools/commit-boundary/check-staged-files.ps1 -TaskId 2026-02-20__dq002-wave-b-fix-profile-validator-schema-policy-links -Phase kickoff -AllowCommonSharedPaths`

## 6. 完了判定

- plan-draft が spec を参照している
- `state.json` に Wave A への depends_on が定義されている
- backlog で Wave B が `dependency-blocked` として登録される
