# Investigation: 2026-02-19__profile-version-schema-version-unification-strategy

## 1. 調査対象 [空欄禁止]

- `project.profile.yaml` で `version` と `schema_version` を一本化する最短変更。
- `version` 依存箇所の実コードと docs 反映範囲。

## 2. 仮説 (Hypothesis / 仮説) [空欄禁止]

- `schema_version` を唯一の正本に固定し、`version` の存在自体を validator で禁止すると、運用判断の分岐を最小化できる。

## 3. 観測方法 [空欄禁止]

- 参照資料:
  - `project.profile.yaml`
  - `tools/profile-validate/validate.ps1`
  - `tools/profile-validate/profile-schema.json`
  - `docs/operations/profile-validator-schema-version-policy.md`
  - `docs/operations/high-priority-backlog.md`
  - `docs/operations/validator-enhancement-backlog.md`
- 実施した確認:
  - `schema_version` 照合ロジックが validator 実装済みであること。
  - `version` が required key として残存していること。
  - `version` 参照が profile/policy/backlog/task 文書に分散していること。

## 4. 観測結果 (Observations / 観測結果) [空欄禁止]

- validator の互換判定は `schema_version` を使用している。
- `version` は `tools/profile-validate/profile-schema.json` の required key に残っており、共存を許容している。
- 現行 policy は `version` を互換目的で維持する記述のまま。
- 未着手の planned タスクが本件 1 件で、統合完了後は backlog を done へ反映できる。

## 5. 結論 (Conclusion / 結論) [空欄禁止]

- 本タスクでは互換モードを廃止し、`schema_version` 単一運用へ即時移行する。
- 実装上の確定事項:
  1. `project.profile.yaml` から `version` を削除する。
  2. profile schema の `required_keys` から `version` を削除する。
  3. validator に `version` キー拒否チェックを追加する。
  4. `schema_version` を `2.0.0` に更新し、許容バージョンを `2.0.0` のみにする。
  5. policy/backlog/index/memory/task 文書を done 状態へ更新する。

## 6. 未解決事項 [空欄禁止]

- なし（破壊的変更許容は要望で明示済み）。

## 7. 次アクション [空欄禁止]

1. `spec.md` で AC とテスト要件を破壊的変更前提へ更新する。
2. `plan.md` で docs 更新範囲と実行コマンドを確定する。
3. 実装・テスト・review・docs・memory を一気通貫で完了する。

## 8. 関連リンク [空欄禁止]

- request: `work/2026-02-19__profile-version-schema-version-unification-strategy/request.md`
- spec: `work/2026-02-19__profile-version-schema-version-unification-strategy/spec.md`
