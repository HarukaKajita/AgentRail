# Phase 2 実装仕様

## 概要

Phase 2 設計に基づき、`docs-indexer` と `consistency-check` を PowerShell で実装する。

## 実装対象

- `tools/docs-indexer/index.ps1`
- `tools/consistency-check/check.ps1`
- `project.profile.yaml` の自動化コマンド追加
- CI 連携仕様は `docs/specs/phase2-ci-integration-spec.md` で管理する

## 受入条件

1. INDEX 管理セクションを自動更新できる
2. 冪等実行で差分が発生しない
3. checker が rule_id/file/reason を含む失敗詳細を返す
4. 対象タスクで checker が PASS する

## 参照

- `docs/specs/phase2-automation-spec.md`
- `work/2026-02-18__phase2-automation-implementation/spec.md`
- `docs/specs/phase2-ci-integration-spec.md`
