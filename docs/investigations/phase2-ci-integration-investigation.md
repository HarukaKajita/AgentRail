# Phase 2 CI 連携調査記録

## 調査目的

Phase 2 で実装済みの自動化スクリプトを CI に組み込むための具体方式を確定する。

## 主な観測

- `.github/workflows/` が未作成で、CI 定義が存在しない
- `check.ps1` は `-TaskId` 必須で、CI 側で task 解決が必要
- `docs-indexer` 後の INDEX 差分をゲート化すると更新漏れを防げる

## 結論

- CI 基盤は GitHub Actions を採用
- latest task-id 自動解決方式を採用
- INDEX 差分検出は失敗扱いにする

## 参照

- `docs/specs/phase2-automation-spec.md`
- `docs/specs/phase2-ci-integration-spec.md`
- `work/2026-02-18__phase2-ci-integration/investigation.md`
