# Investigation: 2026-02-19__profile-validator-schema-version-field

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 1. 調査対象 (Investigation Target) (必須)

- Source task 2026-02-18__project-profile-schema-validation の finding F-001 の根本原因分析。

## 2. 仮説 (Hypothesis) (必須)

- `project.profile.yaml` に schema_version を導入し、validator 側でサポートバージョンを明示すれば、互換性判断を運用で一貫できる。

## 3. 調査・観測方法 (Investigation Method) (必須)

- 参照資料:
  - work/2026-02-18__project-profile-schema-validation/review.md
  - project.profile.yaml
  - tools/profile-validate/validate.ps1
  - tools/profile-validate/profile-schema.json
- 実施した確認:
  - 現行 profile で schema version を表す専用フィールド有無を確認する。
  - profile validator がバージョン互換をどこで判断しているかを確認する。
  - 既存 `version` フィールドとの役割分担を確認する。

## 4. 調査・観測結果 (Observations) (必須)

- `project.profile.yaml` は `version` を持つが、profile schema 互換を示す専用フィールドは未定義。
- `tools/profile-validate/validate.ps1` は required key 判定中心で、schema version 互換（許容バージョン）の検証は未実装。
- `tools/profile-validate/profile-schema.json` に互換対象バージョンを追加し、validator で照合すれば、運用上の判断をコード化できる。

## 5. 結論 (Conclusion) (必須)

- `project.profile.yaml` に `schema_version` を追加し、profile schema 互換判定の基準値とする。
- `tools/profile-validate/profile-schema.json` に `supported_profile_schema_versions` を定義し、validator が `schema_version` を照合する。
- schema version 運用ルールを docs に記録し、更新時の意思決定手順を固定する。

## 6. 未解決事項 (Open Issues) (必須)

- `version` と `schema_version` の将来統合方針（本タスクでは両立運用を採用）。

## 7. 次のアクション (Next Action) (必須)

1. profile / validator schema / validator 本体に schema version 互換チェックを実装する。
2. 互換バージョン外の profile を一時ファイルで再現し、FAIL を確認する。
3. docs / review / state を更新して完了判定を記録する。

## 8. 関連資料リンク (Reference Links) (必須)

- request: work/2026-02-19__profile-validator-schema-version-field/request.md
- spec: work/2026-02-19__profile-validator-schema-version-field/spec.md
- source review: work/2026-02-18__project-profile-schema-validation/review.md
