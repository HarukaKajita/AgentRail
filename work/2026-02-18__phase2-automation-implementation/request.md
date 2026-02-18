# Request: 2026-02-18__phase2-automation-implementation

## 要望の原文

- `docs/specs/phase2-automation-spec.md` を基に Phase 2 実装タスクを起票し、実装する。

## 要望の整理

- `docs-indexer` を PowerShell で実装する。
- `consistency-check` を PowerShell で実装する。
- 実装結果を docs と profile に反映する。
- CI 連携は後続タスクに分離する。

## 成功条件（要望レベル）

1. `tools/docs-indexer/index.ps1` が INDEX 管理セクションを更新できる。
2. `tools/consistency-check/check.ps1` が PASS/FAIL と終了コードを返せる。
3. `project.profile.yaml` にコマンド定義が追加される。
4. docs に実装反映が追記される。
