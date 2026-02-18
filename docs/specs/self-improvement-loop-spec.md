# 自己改善ループ仕様

## 1. 目的

開発フロー中に発見された運用・品質・手順上の問題を、`review.md` から機械的に要件化し、再発防止タスクへ確実に接続する。

## 2. 対象

- `work/<task-id>/review.md` の `## 6. Process Findings`
- `tools/improvement-harvest/scan.ps1`
- `tools/improvement-harvest/create-task.ps1`
- `tools/consistency-check/check.ps1`
- `.github/workflows/ci-framework.yml`

## 3. Process Findings スキーマ

各 finding は `### 6.x Finding ...` ブロックで記述し、以下キーを持つ。

- `finding_id`: finding 識別子
- `category`: `flow|docs|ci|quality|other`
- `severity`: `must|high|medium|low`
- `summary`: 問題の要約
- `evidence`: 根拠
- `action_required`: `yes|no`
- `linked_task_id`: `action_required: yes` の場合は必須（`work/` 配下実在）

## 4. 強制ルール

1. `review.md` は `## 6. Process Findings` を必須とする。
2. `severity` が `must/high` の finding は `action_required: yes` を必須とする。
3. `action_required: yes` の finding は `linked_task_id` を必須とする。
4. `linked_task_id` は `work/<linked_task_id>/` の実在ディレクトリでなければならない。

### 4.1 移行ポリシー

- checker では互換性のため、少なくとも `state.json` が `done` の task に対して上記ルールを強制する。
- 進行中 task でも `Process Findings` を記述した場合は同ルールで検証する。

## 5. 実行フロー

1. CI で task-id を解決する。
2. `scan.ps1` で `review.md` を検証・抽出する。
3. `check.ps1` で既存整合チェック + 改善ゲートを実行する。
4. 失敗時は `review.md` 修正または `create-task.ps1` で follow-up task を作成する。

## 6. CLI

- scan:
  - `pwsh -NoProfile -File tools/improvement-harvest/scan.ps1 -TaskId <task-id>`
- create task:
  - `pwsh -NoProfile -File tools/improvement-harvest/create-task.ps1 -SourceTaskId <task-id> -FindingId <finding-id> -Title <title> -Severity <severity> -Category <category>`

## 7. 受入基準

- CI が Process Findings 不備を fail-fast で検知できる。
- `must/high` finding が未起票状態で merge されない。
- 自動起票された task が `work/<task-id>/` の必須6ファイルを持つ。

## 8. 参照

- `docs/specs/automation-tools-design-spec.md`
- `docs/specs/automation-tools-ci-integration-spec.md`
- `docs/operations/ci-failure-runbook.md`
