# Request: 2026-02-20__wave2-enforce-doc-quality-fail-mode

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/wave2-doc-quality-check-rules-spec.md`
  - `docs/operations/wave2-doc-quality-warning-mode.md`
  - `docs/operations/high-priority-backlog.md`
  - `.github/workflows/ci-framework.yml`
- 理解ポイント:
  - 本タスクは Wave 2-2 として docs品質判定を fail として強制する実装タスクである。

## 要望の原文

- warning モードの結果を踏まえ、fail モードへ昇格する。
- wave 計画の依存順序を維持し、品質ゲートを満たす成果物を作成する。

## 要望分析

- 直要求:
  - 変更対象 task に対して docs品質 issue を CI fail として扱う。
  - fail mode の運用/ロールバック手順を docs 化する。
- 潜在要求:
  - 既存 warning 観測（21件）を段階的に解消できる移行形にする。
  - `state-validate` / `consistency-check` の fail mode 呼び出しを統一する。
- 非要求:
  - warning の全件解消。

## 提案オプション（3案）

1. 既定値を fail へ変更し全経路で即時適用
2. CI の変更対象 task 経路のみ fail 強制（採用）
3. fail 適用を docs 宣言だけに留める

## 推奨案

- 採用: オプション2
- 採用理由:
  - 全 task 一括 fail 化のリスクを避けつつ、実運用経路で fail 強制を開始できるため。

## 依存関係整理

- depends_on: `2026-02-20__wave2-implement-doc-quality-warning-mode`
- 依存状態: 解決済み（`2026-02-20__wave2-implement-doc-quality-warning-mode[done]`）

## 成功条件（要望レベル）

1. CI の変更対象 task 検証で `DocQualityMode=fail` が実行される。
2. fail mode 運用手順と rollback が docs に記録される。
3. backlog/state/MEMORY が次タスク着手状態へ同期される。

## blocked 判定

- 依存解決済みのため plan-ready で進行する。
