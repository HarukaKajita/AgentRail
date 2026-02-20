# Investigation: 2026-02-20__wave3-automate-doc-quality-metrics-report

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/wave3-doc-quality-kpi-thresholds.md`
  - `tools/consistency-check/check.ps1`
  - `work/2026-02-20__wave3-automate-doc-quality-metrics-report/request.md`
- 理解ポイント:
  - task11 は KPI 指標定義を破壊せずに自動算出へ置換するタスク。

## 1. 調査対象 (Investigation Target) (必須)

- 課題: KPI を手動観測から自動集計へ移行する。
- 目的: 集計スクリプトと可視化レポートの最小実装を確定する。
- 依存: `2026-02-20__wave3-define-doc-quality-kpi-thresholds`

## 2. 仮説 (Hypothesis) (必須)

- consistency-check JSON と state.json だけで task10 定義の KPI を再現できる。

## 3. 調査・観測方法 (Investigation Method) (必須)

- 参照資料:
  - `tools/consistency-check/check.ps1`
  - `tools/common/profile-paths.ps1`
  - `docs/operations/wave3-doc-quality-kpi-thresholds.md`
- 実施した確認:
  1. consistency JSON の `task_count`、`doc_quality_issues`、`results` を確認。
  2. `work/*/state.json` から stale task 件数を算出可能か確認。
  3. 出力形式を JSON + Markdown の2系統にする設計を確認。

## 4. 調査・観測結果 (Observations) (必須)

- 事実:
  - consistency JSON から `task_count`、`doc_quality_issues`、`results` を取得できる。
  - `DQ-002 count` と `warning_free_task_ratio` を算出可能。
  - state.json から active task の更新遅延（14日超）を算出可能。
  - depends_on は解決済み（task10 done）。
- 推測:
  - report schema を固定すれば task12 で Process Findings 連携が容易になる。

## 5. 提案オプション (必須)

1. JSON のみ出力する。
2. JSON + Markdown を同時出力する（推奨）。
3. 既存スクリプトへ集計処理を直接統合する。

## 6. 推奨案 (必須)

- 推奨: 2. JSON + Markdown 同時出力
- 理由:
  - 機械処理（JSON）と人間レビュー（Markdown）を同時に満たせるため。

## 7. 結論 (Conclusion / 結論) (必須)

- `tools/doc-quality/generate-kpi-report.ps1` を追加し、task10定義KPIを自動算出する。

## 8. 未解決事項 (必須)

- task12 での KPI 悪化条件に対する起票ポリシー（次タスクで確定）。

## 9. 次アクション (必須)

1. script と運用 docs を実装する。
2. task11 review/state/backlog/MEMORY を同期する。
3. validator を実行して done 判定を確定する。

## 10. 関連リンク (必須)

- request: `work/2026-02-20__wave3-automate-doc-quality-metrics-report/request.md`
- spec: `work/2026-02-20__wave3-automate-doc-quality-metrics-report/spec.md`
- docs:
  - `docs/operations/wave3-doc-quality-kpi-thresholds.md`
  - `docs/operations/wave3-doc-quality-metrics-report-automation.md`
