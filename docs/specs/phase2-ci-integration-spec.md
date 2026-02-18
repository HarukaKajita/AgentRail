# Phase 2 CI 連携仕様

## 概要

Phase 2 後半として、`docs-indexer` と `consistency-check` を GitHub Actions に統合する。

## 連携内容

1. `push` / `pull_request` で workflow 起動
2. `tools/docs-indexer/index.ps1` を実行
3. `docs/INDEX.md` 差分検出で失敗
4. `work/` 最新 task-id を自動解決
5. `tools/consistency-check/check.ps1 -TaskId <resolved-task-id>` を実行

## 失敗ポリシー

- task-id 解決不能は失敗
- INDEX 差分が残る場合は失敗
- consistency-check FAIL は失敗

## 参照

- `docs/specs/phase2-automation-spec.md`
- `work/2026-02-18__phase2-ci-integration/spec.md`
- `.github/workflows/ci-framework.yml`
