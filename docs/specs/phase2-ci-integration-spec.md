# Phase 2 CI 連携仕様

## 概要

Phase 2 後半として、`docs-indexer` と `consistency-check` を GitHub Actions に統合する。

## 連携内容

1. `push` / `pull_request` で workflow 起動
2. `workflow_dispatch` で任意 `task_id` 指定起動に対応
3. `tools/docs-indexer/index.ps1` を実行
4. `docs/INDEX.md` 差分検出で失敗
5. `tools/ci/resolve-task-id.ps1` で task-id を解決
6. `tools/improvement-harvest/scan.ps1 -TaskId <resolved-task-id>` を実行
7. `tools/consistency-check/check.ps1 -TaskId <resolved-task-id>` を実行

### task-id 解決ルール

1. `workflow_dispatch` の `task_id` 入力がある場合は最優先で採用する
2. 入力が無い場合はイベント差分から `work/<task-id>/` を抽出する
3. 抽出が 1 件なら採用、複数件なら失敗
4. 抽出 0 件の場合は `resolved_task_source=skip` として checker 系 step を実行しない

## 失敗ポリシー

- task-id 解決不能は失敗
- 差分から複数 task-id が検出された場合は失敗
- `workflow_dispatch` で `task_id` 未指定の場合は失敗
- INDEX 差分が残る場合は失敗
- Process Findings の構造不備または未起票重大 finding は失敗
- consistency-check FAIL は失敗

## 参照

- `docs/specs/phase2-automation-spec.md`
- `work/2026-02-18__phase2-ci-integration/spec.md`
- `.github/workflows/ci-framework.yml`
- `docs/specs/self-improvement-loop-spec.md`
