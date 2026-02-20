# Investigation: 2026-02-20__wave3-define-doc-quality-kpi-thresholds

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/human-centric-doc-bank-governance.md`
  - `docs/operations/human-centric-doc-bank-migration-plan.md`
  - `docs/operations/wave2-doc-quality-warning-mode.md`
  - `docs/operations/wave2-doc-quality-fail-mode.md`
  - `work/2026-02-20__wave3-define-doc-quality-kpi-thresholds/request.md`
- 理解ポイント:
  - KPI は Wave 2 実測値を前提に、Wave 3 automation の入力仕様として成立する必要がある。

## 1. 調査対象 (Investigation Target) (必須)

- 課題: 更新遅延/導線整合/網羅率を定量監視できる KPI と暫定閾値を定義する。
- 目的: 後続 task（自動集計・改善ループ接続）が実装可能な指標定義を固定する。
- 依存: `2026-02-20__wave2-enforce-doc-quality-fail-mode`, `2026-02-20__wave2-align-ci-runbook-with-doc-quality-gates`

## 2. 仮説 (Hypothesis) (必須)

- 既存 validator 出力と state.json から直接算出できる KPI に限定すれば、低コストで運用を開始できる。

## 3. 調査・観測方法 (Investigation Method) (必須)

- 参照資料:
  - `docs/operations/high-priority-backlog.md`
  - `tools/consistency-check/check.ps1`
  - `tools/state-validate/validate.ps1`
- 実施した確認:
  1. `consistency-check -AllTasks -DocQualityMode warning -OutputFormat json` の出力項目を確認。
  2. rule別 warning 件数と warning-free ratio を baseline として採用可能か確認。
  3. `state.json.updated_at` を使った stale task 件数指標の算出可能性を確認。

## 4. 調査・観測結果 (Observations) (必須)

- 事実:
  - `task_count=56`、`warning_count=21`、`DQ-002=21`、`DQ-001=0`・`DQ-003=0`・`DQ-004=0`（2026-02-20 観測）。
  - `warning_free_ratio=62.5%`（35/56）を算出可能。
  - depends_on 2件は `done` で解決済み。
- 推測:
  - KPI を 3 指標（更新遅延/導線整合/網羅率）へ固定すると、task11 で JSON/Markdown レポート実装がしやすい。

## 5. 提案オプション (必須)

1. 定義中心: KPI 名称のみを決める。
2. 実測中心（推奨）: KPI + 算出式 + 暫定閾値 + baseline を同時確定する。
3. 実装先行: KPI 定義を最小化し task11 実装で調整する。

## 6. 推奨案 (必須)

- 推奨: 2. 実測中心
- 理由:
  - 閾値未定義のまま自動化すると、判定基準が task 間でブレるため。

## 7. 結論 (Conclusion / 結論) (必須)

- `docs/operations/wave3-doc-quality-kpi-thresholds.md` を新規作成し、3 KPI と暫定閾値、guardrail、baseline を固定する。

## 8. 未解決事項 (必須)

- KPI-FRESH-01 の実測自動化は task11 で実装する。

## 9. 次アクション (必須)

1. task10 spec/plan を KPI 定義実装に合わせて更新する。
2. backlog と MEMORY を task11 着手状態へ更新する。
3. consistency/state/docs-indexer を再実行して完了判定する。

## 10. 関連リンク (必須)

- request: `work/2026-02-20__wave3-define-doc-quality-kpi-thresholds/request.md`
- spec: `work/2026-02-20__wave3-define-doc-quality-kpi-thresholds/spec.md`
- docs:
  - `docs/operations/wave3-doc-quality-kpi-thresholds.md`
  - `docs/operations/wave2-doc-quality-warning-mode.md`
