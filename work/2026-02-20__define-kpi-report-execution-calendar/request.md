# Request: 2026-02-20__define-kpi-report-execution-calendar

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `docs/operations/wave3-doc-quality-kpi-thresholds.md`
  - `docs/operations/wave3-doc-quality-metrics-report-automation.md`
  - `docs/operations/wave3-kpi-process-findings-loop.md`
  - `MEMORY.md`
- 理解ポイント:
  - KPI 定義と自動集計は実装済みで、未定義なのは運用カレンダーへの実行タイミング反映。

## 要望の原文

- KPI レポートの定期実行タイミング（週次/リリース前）を運用カレンダーへ反映する。

## 要望分析

- 直要求:
  - KPI レポートの実行頻度とトリガーを運用手順へ固定する。
- 潜在要求:
  - 実行責任者、失敗時のエスカレーション、レビュー更新タイミングを明確化する。
- 非要求:
  - KPI 計算ロジックの変更。

## 提案オプション（3案）

1. 週次のみを規定する。
2. 週次 + リリース前 + 臨時実行条件を規定する（採用）。
3. CI で完全自動スケジュール化する。

## 推奨案

- 採用: オプション2
- 採用理由:
  - 手動運用でも抜け漏れが少なく、段階的に自動化へ移行しやすい。

## 依存関係整理

- depends_on: `2026-02-20__wave3-connect-kpi-to-process-findings-loop`
- 不足依存: なし

## 成功条件（要望レベル）

1. KPI 実行タイミング（週次/リリース前/臨時）の判定基準が docs に明記される。
2. 実行担当・出力保存先・review 反映先が定義される。
3. 運用フローが backlog/MEMORY と整合する。

## blocked 判定

- depends_on は解決済みのため `plan-ready`。
