# Request: 2026-02-20__wave3-automate-doc-quality-metrics-report

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/wave3-doc-quality-kpi-thresholds.md`
  - `docs/operations/wave2-doc-quality-warning-mode.md`
  - `docs/operations/high-priority-backlog.md`
- 理解ポイント:
  - task11 は task10 で定義した KPI を機械集計へ落とし込む実装タスク。

## 要望の原文

- docs 品質KPIの自動集計と可視化レポートを設計・実装する。
- wave 計画の依存順序を維持し、品質ゲートを満たす成果物を作成する。

## 要望分析

- 直要求:
  - KPI 集計スクリプトを追加し、JSON/Markdown レポートを生成可能にする。
  - 運用ドキュメントを追加し、実行手順と判定ルールを明文化する。
- 潜在要求:
  - task12 で Process Findings 連携しやすい出力形式にする。
  - 既存 warning/fail 運用と競合しないことを担保する。
- 非要求:
  - KPI 悪化時の自動起票（task12 で実施）。

## 提案オプション（3案）

1. docs のみ更新し、集計は手動のままにする。
2. スクリプト + docs を同時実装する（採用）。
3. CI 組み込みまで同時実装する。

## 推奨案

- 採用: オプション2
- 採用理由:
  - Wave 3 の段階実行を維持しつつ、task12 の入力を先に安定化できるため。

## 依存関係整理

- depends_on: `2026-02-20__wave3-define-doc-quality-kpi-thresholds`
- 依存状態: 解決済み（task10 は `done`）

## 成功条件（要望レベル）

1. `tools/doc-quality/generate-kpi-report.ps1` で KPI レポートを生成できる。
2. `docs/operations/wave3-doc-quality-metrics-report-automation.md` で運用手順を参照できる。
3. backlog/state/MEMORY が task12 着手状態へ同期される。

## blocked 判定

- depends_on 解決済みのため plan-ready で進行する。
