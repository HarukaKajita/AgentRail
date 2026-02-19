# Request: 2026-02-19__profile-version-schema-version-unification-strategy

## 要望の原文

- version と schema_version の将来統合方針タスクを起票して

## 要望の整理

- 背景: `project.profile.yaml` に `version` と `schema_version` が共存しており、将来の正本フィールドを明確化する必要がある。
- 目的: 統合方針（正本フィールド、移行期間、validator 互換モード）を定義するための実装タスクを起票する。
- 参照: `work/2026-02-19__profile-validator-schema-version-field/review.md`

## 成功条件（要望レベル）

1. `work/2026-02-19__profile-version-schema-version-unification-strategy/` に必須6ファイルが作成される。
2. `spec.md` の空欄禁止項目とテスト要件が実施可能な粒度で記述される。
3. `docs/operations/high-priority-backlog.md` と `docs/operations/validator-enhancement-backlog.md` に planned として登録される。
