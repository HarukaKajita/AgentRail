# 仕様書: 2026-02-19__ci-profile-schema-version-governance-gate

## 1. メタ情報 [空欄禁止]

- Task ID: `2026-02-19__ci-profile-schema-version-governance-gate`
- タイトル: CI Profile Schema Version Governance Gate
- 作成日: 2026-02-19
- 更新日: 2026-02-19
- 作成者: codex
- 関連要望: `work/2026-02-19__ci-profile-schema-version-governance-gate/request.md`

## 2. 背景と目的 [空欄禁止]

- 背景: `schema_version` は `2.0.0` へ移行済みだが、schema 変更時の versioning ルール（更新必須・整合必須）が CI で強制されていない。
- 目的: profile schema 更新運用を CI で fail-fast 強制し、`schema_version` 更新漏れや不整合を防止する。

## 3. スコープ [空欄禁止]

### 3.1 In Scope [空欄禁止]

- `tools/profile-validate/profile-schema.json` の base/head 差分を評価する governance script を追加する。
- 以下の判定ルールを CI で強制する。
  - R-001: schema file が変更されたら `schema_version` 変更を必須にする。
  - R-002: `schema_version` は SemVer 形式 (`major.minor.patch`) に一致する。
  - R-003: `schema_version` は `supported_profile_schema_versions` に含まれる。
  - R-004: breaking change（`required_keys` / `forbidden_top_level_keys` / `schema_id` の変更、または `supported_profile_schema_versions` からの削除）がある場合は major 増分を必須にする。
  - R-005: `supported_profile_schema_versions` への追加のみは非破壊変更として扱い、major 増分を必須にしない。
- `.github/workflows/ci-framework.yml` に governance step を追加し、違反時は workflow を失敗させる。
- policy/CI spec/runbook を更新し、運用手順を明文化する。

### 3.2 Out of Scope [空欄禁止]

- `tools/profile-validate/profile-schema.json` の実際の schema 定義変更。
- `state` validator や `consistency-check` JSON schema version への同様ルール展開。
- 既存 commit 履歴への retroactive 適用。

## 4. 受入条件 (Acceptance Criteria / 受入条件) [空欄禁止]

- AC-001: profile schema governance 用の新規 PowerShell script が追加され、base/head を入力に PASS/FAIL 判定できる。
- AC-002: schema file 変更かつ `schema_version` 不変のケースで、governance script が FAIL する。
- AC-003: breaking change があるのに major 増分されていないケースで、governance script が FAIL する。
- AC-004: `schema_version` が `supported_profile_schema_versions` に含まれないケースで、governance script が FAIL する。
- AC-005: `.github/workflows/ci-framework.yml` に governance step が追加され、違反時に CI 全体が失敗する。
- AC-006: `docs/operations/profile-validator-schema-version-policy.md`、`docs/specs/automation-tools-ci-integration-spec.md`、`docs/operations/ci-failure-runbook.md`、`docs/INDEX.md` に運用更新が反映される。

## 5. テスト要件 (Test Requirements / テスト要件) [空欄禁止]

### 5.1 Unit Test (Unit Test / 単体テスト) [空欄禁止]

- 対象: profile schema governance 用の新規 PowerShell script
- 観点:
  - schema file 未変更時 PASS
  - schema file 変更 + `schema_version` 不変時 FAIL
  - breaking change + minor/patch 増分時 FAIL
  - `schema_version` が supported list 外のとき FAIL
- 合格条件: 観点ごとの期待結果（PASS/FAIL）を満たす。

### 5.2 Integration Test (Integration Test / 結合テスト) [空欄禁止]

- 対象: `.github/workflows/ci-framework.yml` と governance script の連携
- 観点:
  - PR / push で `BaseSha` / `HeadSha` を渡して governance step が実行される
  - governance FAIL 時に後続 step へ進まず job が失敗する
- 合格条件: CI 実行ログで step 成否が期待どおりになる。

### 5.3 Regression Test (Regression Test / 回帰テスト) [空欄禁止]

- 対象: 既存 framework checks（docs-indexer/profile-validate/state-validate/consistency-check）
- 観点: governance step 追加後も既存 successful path が破壊されない
- 合格条件:
  - `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check` が PASS
  - `pwsh -NoProfile -File tools/profile-validate/validate.ps1 -ProfilePath project.profile.yaml` が PASS
  - `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks` が PASS

### 5.4 Manual Verification (Manual Verification / 手動検証) [空欄禁止]

- 手順:
  1. `schema_version` を据え置いたまま `required_keys` を変更した差分を作り、governance script を実行する。
  2. `schema_version` を major 増分し、同差分で再実行する。
  3. `schema_version` を supported list から外したケースを作り、再実行する。
  4. policy/spec/runbook/index の更新内容を確認する。
- 期待結果:
  - 手順1/3は FAIL、手順2は PASS する。
  - docs が運用手順として再利用可能な粒度で更新されている。

### 5.5 AC-テスト要件対応表 [空欄禁止]

- AC-001: Unit Test
- AC-002: Unit Test + Manual Verification-1
- AC-003: Unit Test + Manual Verification-1/2
- AC-004: Unit Test + Manual Verification-3
- AC-005: Integration Test
- AC-006: Regression Test + Manual Verification-4

## 6. 影響範囲 [空欄禁止]

- 影響ファイル/モジュール:
  - `.github/workflows/ci-framework.yml`
  - profile schema governance 用の新規 script（`tools/profile-validate/` 配下予定）
  - `tools/profile-validate/profile-schema.json`（判定対象）
  - `tools/profile-validate/validate.ps1`（既存 validator、必要に応じ連携）
- 影響する仕様:
  - `docs/operations/profile-validator-schema-version-policy.md`
  - `docs/specs/automation-tools-ci-integration-spec.md`
  - `docs/operations/ci-failure-runbook.md`
  - `docs/INDEX.md`
- 非機能影響:
  - CI ゲートの厳格化によるリリース安全性向上
  - rule 追加による CI 実行時間の微増

## 7. 制約とリスク [空欄禁止]

- 制約: CI 実行時に base/head SHA が有効であることを前提とする。
- 想定リスク: breaking 判定ロジックが過検知または見逃しを起こす可能性。
- 回避策: ルールを関数化し、正/異常 fixture ケースで unit テストを先行する。

## 8. 未確定事項 [空欄禁止]

- なし。

## 9. 関連資料リンク [空欄禁止]

- request: `work/2026-02-19__ci-profile-schema-version-governance-gate/request.md`
- investigation: `work/2026-02-19__ci-profile-schema-version-governance-gate/investigation.md`
- plan: `work/2026-02-19__ci-profile-schema-version-governance-gate/plan.md`
- review: `work/2026-02-19__ci-profile-schema-version-governance-gate/review.md`
- docs:
  - `docs/operations/profile-validator-schema-version-policy.md`
  - `docs/specs/automation-tools-ci-integration-spec.md`
  - `docs/operations/ci-failure-runbook.md`
