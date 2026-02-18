# 自動化基盤 実装仕様

## 概要

自動化基盤の設計に基づき、`docs-indexer` と `consistency-check` を PowerShell で実装する。

## 実装対象

- `tools/docs-indexer/index.ps1`
- `tools/consistency-check/check.ps1`
- `tools/improvement-harvest/scan.ps1`
- `tools/improvement-harvest/create-task.ps1`
- `project.profile.yaml` の自動化コマンド追加
- CI 連携仕様は `docs/specs/automation-tools-ci-integration-spec.md` で管理する

## 受入条件

1. INDEX 管理セクションを自動更新できる
2. 冪等実行で差分が発生しない
3. checker が rule_id/file/reason を含む失敗詳細を返す
4. 対象タスクで checker が PASS する
5. Process Findings から改善タスクを機械可読で抽出できる

## 参照

- `docs/specs/automation-tools-design-spec.md`
- `work/2026-02-18__automation-tools-implementation/spec.md`
- `docs/specs/automation-tools-ci-integration-spec.md`
- `docs/specs/self-improvement-loop-spec.md`
