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

## 現在の互換バージョン

- `2.0.0`

## 更新ルール

1. profile schema の破壊的変更時は `schema_version` をメジャー更新する。
2. 新しい version を受け入れる場合は、先に `supported_profile_schema_versions` を更新する。
3. 旧 version を打ち切る場合は、`supported_profile_schema_versions` から削除する。
4. 廃止した key は `forbidden_top_level_keys` に追加し、混入を FAIL とする。
5. 変更後は `pwsh -NoProfile -File tools/profile-validate/validate.ps1 -ProfilePath project.profile.yaml` で検証する。

## 注意点

- `version` は legacy key として廃止済みであり、存在した場合は validator が FAIL する。
- required key の source of truth は `tools/profile-validate/profile-schema.json` とする。
