# Plan: 2026-02-19__ci-profile-schema-version-governance-gate

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `work/2026-02-19__ci-profile-schema-version-governance-gate/request.md`
  - `work/2026-02-19__ci-profile-schema-version-governance-gate/spec.md`
- 理解ポイント:
  - 本資料に入る前に、task の目的・受入条件・依存関係を把握する。
## 1. 対象仕様

- `work/2026-02-19__ci-profile-schema-version-governance-gate/spec.md`


## 2. 実装計画ドラフト (Plan Draft)

- 目的: 既存資料の移行と整合性確保
- 実施項目:
  1. 既存ドキュメントの構造修正
- 成果物: 更新済み Markdown ファイル

## 3. 依存関係ゲート (Depends-on Gate)

- 依存: なし
- 判定方針: 直接移行
## 5. 実行コマンド (Execution Commands)

- governance check:
  - `pwsh -NoProfile -File <governance-script> -RepoRoot . -BaseSha <base-sha> -HeadSha <head-sha>`
- profile validate:
  - `pwsh -NoProfile -File tools/profile-validate/validate.ps1 -ProfilePath project.profile.yaml`
- state validate:
  - `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks`
- docs index check:
  - `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`
- consistency:
  - `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-19__ci-profile-schema-version-governance-gate`

## 4. 確定実装計画 (Plan Final)

1. governance script の入出力仕様（base/head、判定結果）を実装する。
2. breaking/non-breaking 判定ロジックを実装する。
3. workflow に governance step を挿入する。
4. policy/spec/runbook/index を更新する。
5. Unit/Integration/Regression/Manual の結果を review に記録する。

## 4. 変更対象ファイル

- `.github/workflows/ci-framework.yml`
- `tools/profile-validate/` 配下の governance script（新規）
- `docs/operations/profile-validator-schema-version-policy.md`
- `docs/specs/automation-tools-ci-integration-spec.md`
- `docs/operations/ci-failure-runbook.md`
- `docs/INDEX.md`
- `work/2026-02-19__ci-profile-schema-version-governance-gate/request.md`
- `work/2026-02-19__ci-profile-schema-version-governance-gate/investigation.md`
- `work/2026-02-19__ci-profile-schema-version-governance-gate/spec.md`
- `work/2026-02-19__ci-profile-schema-version-governance-gate/plan.md`
- `work/2026-02-19__ci-profile-schema-version-governance-gate/review.md`
- `work/2026-02-19__ci-profile-schema-version-governance-gate/state.json`

## 5. リスクとロールバック

- リスク:
  - breaking 判定の過検知で不要な CI fail が増える。
  - base/head 解決失敗時に governance step が不安定化する。
- ロールバック:
  1. workflow の governance step を一時無効化する。
  2. rule を最小セット（R-001/R-003）へ縮退して再導入する。

## 6. 完了判定

- AC-001〜AC-006 が `review.md` で PASS になる。
- `tools/consistency-check/check.ps1 -TaskId 2026-02-19__ci-profile-schema-version-governance-gate` が PASS する。
- `state.json` が `done` へ更新される。

