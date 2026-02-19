# Request: 2026-02-18__project-profile-schema-validation

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 要望の原文

- `project.profile.yaml` の壊れを早期検知するスキーマ検証機能を高優先でタスク化する。

## 要望の整理

- `project.profile.yaml` の必須キーと禁止値を検証する。
- CI で profile 検証を必須チェックとして実行する。

## 成功条件（要望レベル）

1. 必須キー欠落で失敗する。
2. `TODO_SET_ME` 残存で失敗する。
3. CI で自動実行される。
