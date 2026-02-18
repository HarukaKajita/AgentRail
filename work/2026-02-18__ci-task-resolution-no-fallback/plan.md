# Plan: 2026-02-18__ci-task-resolution-no-fallback

## 1. 対象仕様

- `work/2026-02-18__ci-task-resolution-no-fallback/spec.md`

## 2. Execution Commands

- resolve manual: `pwsh -NoProfile -File tools/ci/resolve-task-id.ps1 -EventName workflow_dispatch -RepoRoot . -ManualTaskId <task-id>`
- resolve diff: `pwsh -NoProfile -File tools/ci/resolve-task-id.ps1 -EventName push -RepoRoot . -HeadSha <head> -BaseSha <base>`
- checker: `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-18__ci-task-resolution-no-fallback`

## 3. 実施ステップ

1. `tools/ci/resolve-task-id.ps1` の fallback 分岐を削除し、`skip` / `fail` 出力を追加する。
2. workflow の checker 系 step に `if` 条件を設定する。
3. `workflow_dispatch` 未指定時 fail を実装する。
4. docs/ADR を実装結果で更新する。
5. 回帰テストと手動検証を実施する。

## 4. 変更対象ファイル

- `tools/ci/resolve-task-id.ps1`
- `.github/workflows/ci-framework.yml`
- `docs/specs/automation-tools-ci-integration-spec.md`
- `docs/specs/automation-tools-design-spec.md`
- `docs/decisions/20260218-ci-governance-and-task-resolution.md`
- `work/2026-02-18__ci-task-resolution-no-fallback/*`

## 5. リスクとロールバック

- リスク: 条件分岐ミスにより必要な checker が skip される。
- ロールバック: 直前コミットへ戻し、出力契約を維持したまま段階修正する。

## 6. 完了判定

- AC-001〜AC-005 がすべて PASS。
- CI で差分0件ケースが成功（checker skip）する。

## 7. 実装実行計画（2026-02-18T21:19:22+09:00）

1. resolver の出力契約を `manual|diff|skip` + fail-fast に整理する。
2. workflow に `resolved_task_source` 条件を追加し、`skip` 時は scan/check を実行しない。
3. 仕様 docs / ADR を新ルール（fallback 廃止）へ更新する。
4. spec の手順に沿って resolver の主要分岐を手動検証し、review/state を更新する。
