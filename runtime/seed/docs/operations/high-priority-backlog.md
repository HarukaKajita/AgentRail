# 高優先バックログ

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 目的

次に着手すべき高優先タスクを docs から俯瞰できるようにする。

## 優先タスク一覧

- なし

## Completed

- なし

## 更新ルール

- task の状態を更新したら本資料も同時更新する。
- `planned` タスクには `計画段階`、`ゲート状態`、`依存` と `依存状態` を必ず記載する。
- `依存` は `state.json` の `depends_on` と一致させる。
- `計画段階` は `plan-draft` / `plan-final` を使用し、`ゲート状態` は `plan-ready` / `dependency-blocked` を使用する。
- 完了タスクは `Completed` セクションへ移動する。
