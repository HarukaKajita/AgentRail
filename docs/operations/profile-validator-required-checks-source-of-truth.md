# Profile Validator Required Checks Source Of Truth

## 目的

`tools/profile-validate/validate.ps1` の required key 判定を、スクリプト内の静的配列ではなく単一の schema 定義から管理する。

## Source Of Truth

- 定義ファイル: `tools/profile-validate/profile-schema.json`
- 利用側: `tools/profile-validate/validate.ps1`

`validate.ps1` は `required_keys` の `path` と `value_type` を読み込み、regex を動的生成して profile を検証する。

## Schema フィールド

- `forbidden_placeholders`: profile に残ってはいけない禁止プレースホルダー一覧
- `required_keys[].path`: required key のドット区切りパス
- `required_keys[].value_type`: `scalar` または `container`

## 更新手順

1. required key を追加・変更するときは `tools/profile-validate/profile-schema.json` を更新する。
2. `pwsh -NoProfile -File tools/profile-validate/validate.ps1 -ProfilePath project.profile.yaml` を実行して PASS を確認する。
3. 欠落ケースを作って FAIL を確認し、期待する key path がエラーに出ることを確認する。
4. 関連 task の `review.md` と `docs/INDEX.md` を更新して完了させる。

## 注意点

- `tools/consistency-check/check.ps1` の profile required key 判定は別実装であり、本資料の source of truth 統合対象外。
- schema の `value_type` は validator の判定ロジックと対で運用するため、未定義値を使わない。
