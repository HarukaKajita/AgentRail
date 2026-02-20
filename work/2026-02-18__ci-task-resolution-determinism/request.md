# Request: 2026-02-18__ci-task-resolution-determinism

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 要望の原文

- フレームワーク機能の不足を補うため、CI対象Taskの決定性を強化するタスクを起票する。

## 要望の整理

- CI での `check_consistency` 対象 task-id を、`LastWriteTime` のみではなく変更差分ベースで解決する。
- 変更差分から一意に決まらない場合は失敗させる。
- 変更差分が無い場合のみ、明示的なフォールバック戦略を使う。

## 成功条件（要望レベル）

1. PR / push の変更ファイルから task-id を決定できる。
2. 複数 task が混在する場合に曖昧実行しない。
3. CI ワークフローが決定ロジックを利用する。
