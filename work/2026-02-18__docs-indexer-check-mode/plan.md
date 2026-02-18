# Plan: 2026-02-18__docs-indexer-check-mode

## 1. 対象仕様

- `work/2026-02-18__docs-indexer-check-mode/spec.md`

## 2. Execution Commands

- apply: `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode apply`
- check: `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`

## 3. 実施ステップ

1. モードパラメータを追加する
2. `check` 判定ロジックを実装する
3. workflow を `check` 利用に変更する
4. docs / review / state を更新する

## 4. 変更対象ファイル

- `tools/docs-indexer/index.ps1`
- `.github/workflows/ci-framework.yml`
- `docs/specs/phase2-ci-integration-spec.md`
- `docs/INDEX.md`
- `work/2026-02-18__docs-indexer-check-mode/*`

## 5. リスクとロールバック

- リスク: `check` の誤判定
- ロールバック: 一時的に `apply + git diff` 方式へ戻す

## 6. 完了判定

- AC-001〜AC-004 をすべて PASS
