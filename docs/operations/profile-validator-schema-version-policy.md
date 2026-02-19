# Profile Validator Schema Version Policy

## 目的

`project.profile.yaml` の schema 互換判定を `schema_version` に一本化し、`version` 依存を排除する。

## 管理対象

- profile 側フィールド: `project.profile.yaml` の `schema_version`
- validator 側定義: `tools/profile-validate/profile-schema.json` の
  - `supported_profile_schema_versions`
  - `forbidden_top_level_keys`

`tools/profile-validate/validate.ps1` は以下を満たす場合のみ PASS とする。

1. `schema_version` が `supported_profile_schema_versions` に含まれる。
2. `forbidden_top_level_keys` に含まれる key（現行は `version`）が profile に存在しない。

## CI Governance Gate

- 実行スクリプト: `tools/profile-validate/check-schema-governance.ps1`
- 実行タイミング: `.github/workflows/ci-framework.yml` の profile validate より前
- 判定対象: `tools/profile-validate/profile-schema.json` の base/head 差分

### 強制ルール

1. R-001: schema file が変更されたら `schema_version` 変更を必須にする。
2. R-002: `schema_version` は SemVer 形式（`major.minor.patch`）を必須にする。
3. R-003: `schema_version` は `supported_profile_schema_versions` に含まれていることを必須にする。
4. R-004: breaking change（`required_keys` / `forbidden_top_level_keys` / `schema_id` の変更、または `supported_profile_schema_versions` からの削除）がある場合は major 増分を必須にする。
5. R-005: `supported_profile_schema_versions` への追加のみは非破壊変更として扱い、major 増分は必須にしない。

## 現在の互換バージョン

- `2.0.0`

## 更新ルール

1. profile schema の破壊的変更時は `schema_version` をメジャー更新する。
2. 新しい version を受け入れる場合は、先に `supported_profile_schema_versions` を更新する。
3. 旧 version を打ち切る場合は、`supported_profile_schema_versions` から削除する。
4. 廃止した key は `forbidden_top_level_keys` に追加し、混入を FAIL とする。
5. schema file 変更時は `schema_version` を必ず更新する（変更なしは禁止）。
6. 変更後は以下を実行し、governance と profile validate の両方で PASS を確認する。
   - `pwsh -NoProfile -File tools/profile-validate/check-schema-governance.ps1 -RepoRoot . -BaseSha <base-sha> -HeadSha <head-sha>`
   - `pwsh -NoProfile -File tools/profile-validate/validate.ps1 -ProfilePath project.profile.yaml`

## 注意点

- `version` は legacy key として廃止済みであり、存在した場合は validator が FAIL する。
- required key の source of truth は `tools/profile-validate/profile-schema.json` とする。
