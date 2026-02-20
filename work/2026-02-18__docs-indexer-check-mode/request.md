# Request: 2026-02-18__docs-indexer-check-mode

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 要望の原文

- `docs-indexer` に非破壊検証モードを追加する高優先タスクを具体化する。

## 要望の整理

- `tools/docs-indexer/index.ps1` に `-Mode check` を追加する。
- `check` モードは `docs/INDEX.md` を書き換えずに差分検知だけ行う。
- CI は `check` モードを利用して差分発生時に失敗させる。

## 成功条件（要望レベル）

1. `-Mode apply` は現行挙動を維持する。
2. `-Mode check` で差分なしなら終了コード `0`、差分ありなら `1`。
3. `.github/workflows/ci-framework.yml` が `check` モード利用に更新される。
