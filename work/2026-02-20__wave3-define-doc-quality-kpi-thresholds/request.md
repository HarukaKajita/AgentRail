# Request: 2026-02-20__wave3-define-doc-quality-kpi-thresholds

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/human-centric-doc-bank-governance.md`
  - `docs/operations/human-centric-doc-bank-migration-plan.md`
  - `docs/operations/wave2-doc-quality-warning-mode.md`
  - `docs/operations/wave2-doc-quality-fail-mode.md`
  - `docs/operations/high-priority-backlog.md`
- 理解ポイント:
  - Wave 3 先頭タスクとして、docs品質KPIの定義と暫定閾値を先に固定する。

## 要望の原文

- 更新遅延/導線整合/網羅率の KPI 指標と暫定閾値を定義する。
- wave 計画の依存順序を維持し、品質ゲートを満たす成果物を作成する。

## 要望分析

- 直要求:
  - Wave 3 KPI 定義文書を追加し、算出式・閾値・guardrail を明文化する。
  - backlog/state/MEMORY を次タスク（metrics automation）へ同期する。
- 潜在要求:
  - Wave 2 warning/fail 運用を前提とした測定可能なKPI設計にする。
  - 後続 task が再利用できる baseline 値を残す。
- 非要求:
  - KPI 自動集計の実装（task11で実施）。

## 提案オプション（3案）

1. KPI 名称のみ定義し、閾値は後回しにする。
2. KPI + 暫定閾値 + baseline を文書化する（採用）。
3. KPI 定義と自動集計実装を同時に実施する。

## 推奨案

- 採用: オプション2
- 採用理由:
  - task11 の実装要件をブレなく固定でき、段階実行（Wave 3 2段階起票）に適合するため。

## 依存関係整理

- depends_on: `2026-02-20__wave2-enforce-doc-quality-fail-mode`, `2026-02-20__wave2-align-ci-runbook-with-doc-quality-gates`
- 依存状態: 解決済み（両タスクとも `done`）

## 成功条件（要望レベル）

1. `docs/operations/wave3-doc-quality-kpi-thresholds.md` に 3 KPI（更新遅延/導線整合/網羅率）と閾値が定義される。
2. baseline 観測値（task_count / warning_count / warning_free_ratio）が記録される。
3. backlog/state/MEMORY が task11 着手状態へ同期される。

## blocked 判定

- depends_on 解決済みのため plan-ready で進行する。
