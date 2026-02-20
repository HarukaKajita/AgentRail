# Request: 2026-02-18__automation-tools-implementation

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 要望の原文

- `docs/specs/automation-tools-design-spec.md` を基に自動化基盤段階の実装タスクを起票し、実装する。

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
