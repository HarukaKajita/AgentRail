# Investigation: 2026-02-19__state-validator-done-docs-index-consistency

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 1. 調査対象 [空欄禁止]

- Source task 2026-02-18__state-transition-validation の finding F-001 の根本原因分析。

## 2. 仮説 (Hypothesis / 仮説) [空欄禁止]

- `state=done` 判定に docs/INDEX 反映整合を追加すれば、docs 更新漏れのまま done 化されるリスクを低減できる。

## 3. 調査方法 (Observation Method / 観測方法) [空欄禁止]

- 参照資料:
  - work/2026-02-18__state-transition-validation/review.md
  - tools/state-validate/validate.ps1
  - tools/consistency-check/check.ps1
- 実施した確認:
  - source finding の evidence にある done 判定条件の実装範囲を確認する。
  - docs/INDEX 整合を検証している既存ロジックがどこにあるかを確認する。
  - state validator へ最小追加で導入できる検証方式を確認する。

## 4. 調査結果 (Observations / 観測結果) [空欄禁止]

- `tools/state-validate/validate.ps1` の done 判定は owner / review PENDING の整合を主に検証しており、docs/INDEX 反映は対象外。
- `tools/consistency-check/check.ps1` には spec の docs path と `docs/INDEX.md` の整合確認ロジックがある。
- done 判定で spec の docs path が index に反映されているかを state validator 側で確認すれば、done 状態の品質ゲートを一段強化できる。

## 5. 結論 (Conclusion / 結論) [空欄禁止]

- `tools/state-validate/validate.ps1` に `DocsIndexPath` パラメータを追加し、`state=done` のとき spec docs path と index 収録整合を検証する。
- docs path の抽出は `## 9. 関連資料リンク` の docs エントリ（`docs/...`）を対象とし、存在確認 + index 収録確認を実施する。
- 運用 docs に新規検証ルールを追記し、backlog 状態を更新する。

## 6. 未解決事項 [空欄禁止]

- docs path 抽出規則を state validator と consistency-check で共通化するか（本タスクでは state validator への適用を優先）。

## 7. 次アクション [空欄禁止]

1. done + docs/INDEX 整合チェックを state validator に実装する。
2. 失敗ケース（index 未反映）を一時環境で再現し、FAIL を確認する。
3. docs / review / state を更新し、完了条件を検証する。

## 8. 関連リンク [空欄禁止]

- request: work/2026-02-19__state-validator-done-docs-index-consistency/request.md
- spec: work/2026-02-19__state-validator-done-docs-index-consistency/spec.md
- source review: work/2026-02-18__state-transition-validation/review.md
