# Investigation: 2026-02-20__wave3-connect-kpi-to-process-findings-loop

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/wave3-doc-quality-metrics-report-automation.md`
  - `tools/doc-quality/generate-kpi-report.ps1`
  - `tools/improvement-harvest/create-task.ps1`
  - `work/2026-02-20__wave3-connect-kpi-to-process-findings-loop/request.md`
- 理解ポイント:
  - KPI 観測結果は `review.md` の Process Findings 契約へ正しく変換される必要がある。

## 1. 調査対象 [空欄禁止]

- 課題: KPI レポート悪化時の改善起票フローが未定義。
- 目的: status 判定から finding 記録、follow-up task 起票までの接続ルールを確立する。
- 依存: `2026-02-20__wave3-automate-doc-quality-metrics-report`

## 2. 仮説 (Hypothesis / 仮説) [空欄禁止]

- KPI status ごとの decision table とテンプレート生成を用意すれば、起票品質を均一化できる。

## 3. 調査方法 (Observation Method / 観測方法) [空欄禁止]

- 参照資料:
  - `tools/improvement-harvest/scan.ps1`
  - `tools/improvement-harvest/create-task.ps1`
  - `.tmp/wave3-metrics-report.json`
- 実施した確認:
  1. review finding の必須キーと許容 category/severity を確認。
  2. KPI report 出力から severity/action_required を導出可能か確認。
  3. create-task 実行に必要な引数を確認。

## 4. 調査結果 (Observations / 観測結果) [空欄禁止]

- 事実:
  - `tools/improvement-harvest/scan.ps1` は category=`quality`、severity=`must|high|medium|low` を要求する。
  - `tools/improvement-harvest/create-task.ps1` は `SourceTaskId`、`FindingId`、`Title`、`Severity`、`Category` が必須。
  - report の `overall_status` と KPI status から finding severity を決定できる。
- 推測:
  - finding テンプレート生成スクリプトがあれば、手動作業でも誤記を抑制できる。

## 5. 提案オプション [空欄禁止]

1. docs のみで手順化する。
2. docs + finding テンプレート生成スクリプトを追加する（推奨）。
3. create-task まで自動実行する。

## 6. 推奨案 [空欄禁止]

- 推奨: 2. docs + finding テンプレート生成
- 理由:
  - 安全性と再現性のバランスが最も良い。

## 7. 結論 (Conclusion / 結論) [空欄禁止]

- `tools/doc-quality/generate-finding-template.ps1` を追加し、KPI report から Process Findings 記載テンプレートを生成する。

## 8. 未解決事項 [空欄禁止]

- follow-up task の優先度基準の詳細チューニング（運用で継続改善）。

## 9. 次アクション [空欄禁止]

1. loop runbook とテンプレート生成スクリプトを実装する。
2. task12 review/state/backlog/MEMORY を Wave 3 完了状態へ更新する。
3. validator を実行して最終完了判定する。

## 10. 関連リンク [空欄禁止]

- request: `work/2026-02-20__wave3-connect-kpi-to-process-findings-loop/request.md`
- spec: `work/2026-02-20__wave3-connect-kpi-to-process-findings-loop/spec.md`
- docs:
  - `docs/operations/wave3-kpi-process-findings-loop.md`
  - `docs/operations/wave3-doc-quality-metrics-report-automation.md`
