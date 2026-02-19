# Investigation: 2026-02-19__profile-version-schema-version-unification-strategy

## 1. 調査対象 [空欄禁止]

- `version` と `schema_version` の共存状態を将来どう統合するか。

## 2. 仮説 (Hypothesis / 仮説) [空欄禁止]

- 正本を `schema_version` に統一し、`version` を段階的に廃止する移行方針を定義すれば、互換性と保守性を両立できる。

## 3. 観測方法 [空欄禁止]

- 参照資料:
  - `project.profile.yaml`
  - `tools/profile-validate/validate.ps1`
  - `tools/profile-validate/profile-schema.json`
  - `docs/operations/profile-validator-schema-version-policy.md`
- 実施した確認:
  - 現行 validator が `schema_version` を互換判定に利用していることを確認する。
  - `version` フィールドの残存理由（互換維持）を確認する。
  - 既存タスク・docs 側で `version` を直接参照する箇所を把握する。

## 4. 観測結果 (Observations / 観測結果) [空欄禁止]

- 現在の互換判定は `schema_version` を正として実装済み。
- `version` は互換維持のため残しているが、統合完了条件は未定義。
- 統合方針が未確定のため、将来の破壊的変更タイミングを判断しづらい。

## 5. 結論 (Conclusion / 結論) [空欄禁止]

- 本タスクで `version` と `schema_version` の統合ロードマップを確定する。
- 最低限、次を成果物として定義する:
  1. 正本フィールド決定
  2. 移行期間と段階ゲート
  3. validator の warning/fail 切替条件

## 6. 未解決事項 [空欄禁止]

- 廃止猶予期間を日付ベースで管理するか、schema_version のメジャー更新で管理するか。

## 7. 次アクション [空欄禁止]

1. 統合方針タスクの受入条件を spec に具体化する。
2. 実装順序とロールバックを plan に定義する。
3. backlog へ planned 登録して着手順を固定する。

## 8. 関連リンク [空欄禁止]

- request: `work/2026-02-19__profile-version-schema-version-unification-strategy/request.md`
- spec: `work/2026-02-19__profile-version-schema-version-unification-strategy/spec.md`
