# Request: 2026-02-19__profile-version-schema-version-unification-strategy

## 要望の原文

- 2026-02-19__profile-version-schema-version-unification-strategy に着手する。
- 着手前にテスト要件と docs 更新範囲を確定する。
- review -> docs -> memory まで一気通貫で完了する。
- `version` と `schema_version` を統合し、`version` 依存箇所を一括修正する。
- 過去バージョン互換は考慮せず、合理的な破壊的変更を許容する。

## 要望の整理

- 背景: `project.profile.yaml` で `version` と `schema_version` が共存し、profile schema の正本フィールドが重複している。
- 目的: `schema_version` を唯一の正本に一本化し、`version` 依存と両立運用を終了する。
- 方針: 互換モードを持たず、破壊的変更として `version` を廃止する。
- 参照:
  - `work/2026-02-19__profile-validator-schema-version-field/review.md`
  - `docs/operations/profile-validator-schema-version-policy.md`

## 成功条件（要望レベル）

1. `project.profile.yaml` から `version` が削除され、`schema_version` のみで運用される。
2. profile validator が `version` キーを拒否し、`schema_version` のみを互換判定に使う。
3. 着手前に確定したテスト要件を実施し、結果が `review.md` に記録される。
4. 関連 docs と `docs/INDEX.md`、`MEMORY.md`、`state.json` が更新される。
