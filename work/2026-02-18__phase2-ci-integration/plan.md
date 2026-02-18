# Plan: 2026-02-18__phase2-ci-integration

## 1. 対象仕様

- 主仕様: `work/2026-02-18__phase2-ci-integration/spec.md`
- 参照仕様:
  - `docs/specs/phase2-automation-spec.md`
  - `docs/specs/phase2-implementation-spec.md`

## 2. Execution Commands

- index docs: `pwsh -NoProfile -File tools/docs-indexer/index.ps1`
- index diff check: `git diff --exit-code -- docs/INDEX.md`
- consistency check (ci task): `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-18__phase2-ci-integration`
- consistency check (phase2 task): `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-18__phase2-automation-implementation`
- consistency check (pilot task): `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-18__framework-pilot-01`

## 3. 実施ステップ

1. GitHub Actions workflow を追加する。
2. latest task-id 自動解決ロジックを workflow に実装する。
3. docs-indexer + INDEX差分検知 + checker 実行の順を構成する。
4. CI 連携内容を docs/specs + docs/investigations に昇格する。
5. docs-indexer / checker をローカル検証し、review/state/memory を更新する。

## 4. 変更対象ファイル

- `.github/workflows/ci-framework.yml`
- `docs/specs/phase2-automation-spec.md`
- `docs/specs/phase2-ci-integration-spec.md`
- `docs/investigations/phase2-ci-integration-investigation.md`
- `docs/INDEX.md`
- `MEMORY.md`
- `work/2026-02-18__phase2-ci-integration/*`

## 5. リスクとロールバック

- リスク: 同時刻更新で最新 task-id が一意に解決できない
- ロールバック: workflow の task-id 解決を入力パラメータ必須方式へ切り替える

## 6. 完了判定

- AC-001〜AC-005 を `review.md` ですべて PASS にする。
- `state.json` を `done` に更新する。
