# Profile Validator Schema Version Policy

## 目的

`project.profile.yaml` の schema 互換性を明示し、validator の受け入れバージョンを運用で一貫させる。

## 管理対象

- profile 側フィールド: `project.profile.yaml` の `schema_version`
- validator 側定義: `tools/profile-validate/profile-schema.json` の `supported_profile_schema_versions`

`tools/profile-validate/validate.ps1` は `schema_version` が `supported_profile_schema_versions` に含まれる場合のみ PASS とする。

## 現在の互換バージョン

- `1.0.0`

## 更新ルール

1. 新しい schema を導入する場合、先に `supported_profile_schema_versions` を更新する。
2. 互換バージョン外を許可しない場合は、旧バージョンを配列から削除する。
3. profile 更新時は `project.profile.yaml` の `schema_version` も同時更新する。
4. 変更後は `pwsh -NoProfile -File tools/profile-validate/validate.ps1 -ProfilePath project.profile.yaml` で検証する。

## 注意点

- `version` フィールドは既存運用互換のため維持し、schema 互換判定は `schema_version` を正とする。
- validator の required key は `tools/profile-validate/profile-schema.json` を source of truth とする。
