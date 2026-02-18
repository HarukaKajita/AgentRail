# Plan: 2026-02-18__consistency-check-json-output

## 1. 対象仕様

- `work/2026-02-18__consistency-check-json-output/spec.md`

## 2. Execution Commands

- text mode: `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-18__framework-pilot-01`
- json mode: `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-18__framework-pilot-01 -OutputFormat json`
- json file mode: `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-18__framework-pilot-01 -OutputFormat json -OutputFile artifacts/check-result.json`

## 3. 実施ステップ

1. checker に output パラメータを追加する。
2. 共通結果モデルを作って text/json へ出力する。
3. `-OutputFile` 保存を実装する。
4. CI での利用方針を docs に反映する。
5. review/state を更新する。

## 4. 変更対象ファイル

- `tools/consistency-check/check.ps1`
- `.github/workflows/ci-framework.yml`
- `docs/specs/phase2-ci-integration-spec.md`
- `docs/INDEX.md`
- `work/2026-02-18__consistency-check-json-output/*`

## 5. リスクとロールバック

- リスク: 出力仕様変更で既存ログ解析が壊れる
- ロールバック: 既定 `text` のみに戻し JSON 機能を feature flag 化

## 6. 完了判定

- AC-001〜AC-005 がすべて PASS
