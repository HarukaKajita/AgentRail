# Request: 2026-02-20__wave3-connect-kpi-to-process-findings-loop

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/wave3-doc-quality-kpi-thresholds.md`
  - `docs/operations/wave3-doc-quality-metrics-report-automation.md`
  - `docs/operations/high-priority-backlog.md`
- 理解ポイント:
  - task12 は KPI 観測結果を Process Findings と起票フローへ接続する最終タスク。

## 要望の原文

- KPI悪化時に Process Findings から改善タスクへ接続する運用を定義する。
- wave 計画の依存順序を維持し、品質ゲートを満たす成果物を作成する。

## 要望分析

- 直要求:
  - KPI status（green/yellow/red）と finding severity/action_required を対応付ける。
  - follow-up task 起票までの手順を標準化する。
- 潜在要求:
  - 手動運用でも再現可能なテンプレートを提供する。
  - 既存 improvement-harvest ツールと整合する。
- 非要求:
  - 新規の CI 自動起票ジョブ追加。

## 提案オプション（3案）

1. docs のみで運用定義する。
2. docs + finding テンプレート生成スクリプトを追加する（採用）。
3. create-task 自動実行まで含めて実装する。

## 推奨案

- 採用: オプション2
- 採用理由:
  - 過剰自動化を避けつつ、起票品質を安定化できるため。

## 依存関係整理

- depends_on: `2026-02-20__wave3-automate-doc-quality-metrics-report`
- 依存状態: 解決済み（task11 は `done`）

## 成功条件（要望レベル）

1. KPI status ごとの finding 運用ルールが docs に定義される。
2. `tools/doc-quality/generate-finding-template.ps1` で Process Finding テンプレートを生成できる。
3. backlog/state/MEMORY が Wave 3 完了状態へ同期される。

## blocked 判定

- depends_on 解決済みのため plan-ready で進行する。
