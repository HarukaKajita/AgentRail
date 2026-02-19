# Request: 2026-02-19__ci-profile-schema-version-governance-gate

## 要望の原文

- `schema_version` 更新運用（2.x 以降）を CI で強制するタスクを起票してほしい。
- 起票後、`spec.md` まで確定してほしい。

## 要望の整理

- 直要求:
  - `schema_version` の更新ルールを CI で fail-fast できるようにする。
  - 新規 task を起票し、`spec.md` を実装可能粒度で確定する。
- 潜在要求:
  - profile schema 変更時の運用品質を人依存から自動ゲートへ移す。
  - 破壊的変更時の versioning ミスを早期検知する。
- 非要求:
  - 本タスク内で実装コードを変更して CI ゲートを導入すること。
  - profile 以外（state/consistency JSON など）の schema version 管理統合。

## 境界条件

- 対象は `project.profile.yaml` と `tools/profile-validate/profile-schema.json` の schema version ガバナンスに限定する。
- CI 連携は `.github/workflows/ci-framework.yml` を前提とする。
- `spec.md` まで確定し、実装は次工程とする。

## 成功条件（要望レベル）

1. `work/2026-02-19__ci-profile-schema-version-governance-gate/` に必須6ファイルが作成される。
2. `request.md` / `investigation.md` / `spec.md` が空欄禁止項目を満たし、実装可能粒度になる。
3. `docs/operations/validator-enhancement-backlog.md` と `docs/operations/high-priority-backlog.md` に `planned` として登録される。
