# Plan: 2026-02-18__consistency-check-json-output

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 1. 対象仕様

- `work/2026-02-18__consistency-check-json-output/spec.md`


## 2. 実装計画ドラフト (Plan Draft)

- 目的: 既存資料の移行と整合性確保
- 実施項目:
  1. 既存ドキュメントの構造修正
- 成果物: 更新済み Markdown ファイル

## 3. 依存関係ゲート (Depends-on Gate)

- 依存: なし
- 判定方針: 直接移行
## 5. 実行コマンド (Execution Commands)

- text mode: `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-18__framework-pilot-01`
- json mode: `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-18__framework-pilot-01 -OutputFormat json`
- json file mode: `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-18__framework-pilot-01 -OutputFormat json -OutputFile artifacts/check-result.json`

## 4. 確定実装計画 (Plan Final)

1. checker に output パラメータを追加する。
2. 共通結果モデルを作って text/json へ出力する。
3. `-OutputFile` 保存を実装する。
4. CI での利用方針を docs に反映する。
5. review/state を更新する。

## 4. 変更対象ファイル

- `tools/consistency-check/check.ps1`
- `.github/workflows/ci-framework.yml`
- `docs/specs/automation-tools-ci-integration-spec.md`
- `docs/INDEX.md`
- `work/2026-02-18__consistency-check-json-output/*`

## 5. リスクとロールバック

- リスク: 出力仕様変更で既存ログ解析が壊れる
- ロールバック: 既定 `text` のみに戻し JSON 機能を feature flag 化

## 6. 完了判定

- AC-001〜AC-005 がすべて PASS

## 7. 実装実行計画（2026-02-18T21:40:39+09:00）

1. `tools/consistency-check/check.ps1` に `-OutputFormat text|json` と `-OutputFile` を追加する。
2. 失敗情報の共通結果モデルを作り、text/json の両出力で同一データを利用する。
3. JSON は成功/失敗いずれでも出力し、終了コードは従来どおり維持する。
4. docs に JSON スキーマと実行例を追記し、review/state を更新する。
