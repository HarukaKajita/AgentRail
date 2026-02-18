# Plan: 2026-02-18__state-transition-validation

## 1. 対象仕様

- `work/2026-02-18__state-transition-validation/spec.md`

## 2. Execution Commands

- validate single: `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-18__framework-pilot-01`
- validate all: `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks`

## 3. 実施ステップ

1. state validator を実装する
2. 許可 state と整合条件の検証を追加する
3. CI へ組み込む
4. docs / review / state を更新する

## 4. 変更対象ファイル

- `tools/state-validate/validate.ps1`
- `.github/workflows/ci-framework.yml`
- `docs/specs/phase2-ci-integration-spec.md`
- `docs/INDEX.md`
- `work/2026-02-18__state-transition-validation/*`

## 5. リスクとロールバック

- リスク: 既存 task で想定外 FAIL
- ロールバック: validator を warning モードで導入し基準を調整

## 6. 完了判定

- AC-001〜AC-005 をすべて PASS
