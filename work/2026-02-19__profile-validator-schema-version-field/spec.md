# 仕様書: 2026-02-19__profile-validator-schema-version-field

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 1. メタ情報 (Metadata) (必須)

- Task ID: `2026-02-19__profile-validator-schema-version-field`
- タイトル: Profile Validator Schema Version Field
- 作成日: 2026-02-19
- 更新日: 2026-02-19
- 作成者: codex
- 関連要望: `work/2026-02-19__profile-validator-schema-version-field/request.md`

## 2. 背景と目的 (Background & Objectives) (必須)

- 背景: profile validator には `project.profile.yaml` の schema 互換を示す明示フィールドがなく、拡張時の互換判断を運用メモに依存していた。
- 目的: `schema_version` フィールドを導入し、validator で許容バージョン照合を実施して互換ポリシーを明確化する。

## 3. スコープ (Scope) (必須)

### 3.1 In Scope (必須)

- `project.profile.yaml` に `schema_version` を追加する。
- `tools/profile-validate/profile-schema.json` に許容 schema version 定義を追加する。
- `tools/profile-validate/validate.ps1` で `schema_version` の互換チェックを追加する。
- schema version 運用ルールを docs と backlog に反映する。

### 3.2 Out of Scope (必須)

- `version` フィールド廃止・統合。
- profile validator 以外の validator への schema version 強制導入。

## 4. 受入条件 (Acceptance Criteria) (必須)

- AC-001: `project.profile.yaml` が `schema_version` を持ち、`tools/profile-validate/profile-schema.json` の required key と整合する。
- AC-002: `tools/profile-validate/validate.ps1` が `schema_version` を抽出し、`supported_profile_schema_versions` と照合する。
- AC-003: 非互換 `schema_version` を含む一時 profile では validator が FAIL し、互換エラーを出力する。
- AC-004: schema version の運用方針が docs に記録され、`docs/INDEX.md` から参照できる。

## 5. テスト要件 (Test Requirements) (必須)

### 5.1 単体テスト (Unit Test) (必須)

- **対象**: `tools/profile-validate/validate.ps1`
- **検証項目**: `schema_version` 抽出と許容バージョン照合が機能する。
- **合格基準**: 現行 profile は PASS、非互換 `schema_version` は FAIL。

### 5.2 結合テスト (Integration Test) (必須)

- **対象**: `tools/profile-validate/validate.ps1` と `project.profile.yaml`
- **検証項目**: required key と supported version の両方が同時に満たされたときに PASS する。
- **合格基準**: `pwsh -NoProfile -File tools/profile-validate/validate.ps1 -ProfilePath project.profile.yaml` が PASS。

### 5.3 回帰テスト (Regression Test) (必須)

- **対象**: `tools/consistency-check/check.ps1` と `tools/docs-indexer/index.ps1`
- **検証項目**: task 文書と docs 更新後も既存運用チェックが PASS する。
- **合格基準**: consistency-check と docs-indexer check が PASS。

### 5.4 手動検証 (Manual Verification) (必須)

- **検証手順**:
  1. `pwsh -NoProfile -File tools/profile-validate/validate.ps1 -ProfilePath project.profile.yaml` を実行する。
  2. 一時 profile の `schema_version` を `9.9.9` に変更して validator を実行する。
  3. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-19__profile-validator-schema-version-field` を実行する。
  4. `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check` を実行する。
- **期待される結果**: 手順1/3/4は PASS、手順2は `Unsupported schema_version` を出力して FAIL。

## 6. 影響範囲 (Impact Assessment) (必須)

- 影響ファイル/モジュール:
  - `project.profile.yaml`
  - `tools/profile-validate/profile-schema.json`
  - `tools/profile-validate/validate.ps1`
  - `docs/templates/project-profile.md`
  - `docs/operations/profile-validator-schema-version-policy.md`（新規）
  - `docs/operations/validator-enhancement-backlog.md`
  - `docs/operations/high-priority-backlog.md`
  - `docs/INDEX.md`
- 影響する仕様:
  - `docs/operations/validator-enhancement-backlog.md`
- 非機能影響:
  - profile schema 拡張時の互換判断が明文化される。

## 7. 制約とリスク (Constraints & Risks) (必須)

- 制約: 既存 `version` フィールド互換を維持しつつ段階導入する。
- 想定リスク: schema version 値の書式ゆれで誤判定する可能性。
- 回避策: `supported_profile_schema_versions` に明示値を列挙し、validator で照合失敗時に具体エラーメッセージを返す。

## 8. 未確定事項 (Open Issues) (必須)

- `version` と `schema_version` の統合時期。

## 9. 関連資料リンク (Reference Links) (必須)

- request: `work/2026-02-19__profile-validator-schema-version-field/request.md`
- investigation: `work/2026-02-19__profile-validator-schema-version-field/investigation.md`
- plan: `work/2026-02-19__profile-validator-schema-version-field/plan.md`
- review: `work/2026-02-19__profile-validator-schema-version-field/review.md`
- docs:
  - `docs/operations/profile-validator-schema-version-policy.md`
  - `docs/operations/validator-enhancement-backlog.md`
  - `docs/operations/high-priority-backlog.md`
