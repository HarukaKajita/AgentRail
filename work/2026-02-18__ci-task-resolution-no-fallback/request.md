# Request: 2026-02-18__ci-task-resolution-no-fallback

## 要望の原文

- planned task が無関係に CI 対象となって FAIL するのを防ぎたい。
- 仕様だけ先行変更せず、実装として修正したい。

## 要望の整理

- `resolve-task-id` の fallback 採用を廃止する。
- `push` / `pull_request` で `work/<task-id>/` 差分 0 件時は checker 系 step を skip する。
- `workflow_dispatch` は `task_id` 未指定時に fail-fast とする。

## 成功条件（要望レベル）

1. 無関係 task を checker 対象に選ばない。
2. `workflow_dispatch` で `task_id` 未指定を明示エラーにできる。
3. CI ログで manual-diff-skip の判定理由が確認できる。
