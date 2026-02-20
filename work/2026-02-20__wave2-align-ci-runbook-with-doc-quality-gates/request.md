# Request: 2026-02-20__wave2-align-ci-runbook-with-doc-quality-gates

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/wave2-doc-quality-warning-mode.md`
  - `docs/operations/wave2-doc-quality-fail-mode.md`
  - `docs/operations/ci-failure-runbook.md`
  - `.github/workflows/ci-framework.yml`
- 理解ポイント:
  - fail mode を導入した CI 実装と運用 runbook の記述を一致させるタスクである。

## 要望の原文

- CI運用資料を docs 品質ゲートに合わせて更新し、運用手順を整合させる。
- wave 計画の依存順序を維持し、品質ゲートを満たす成果物を作成する。

## 要望分析

- 直要求:
  - CI 失敗時ランブックを warning/fail 二段ゲートへ更新する。
  - 実装ガイドのチェック手順を `DocQualityMode` 運用に合わせる。
- 潜在要求:
  - runbook だけで復旧手順を追えるようにコマンド順序を明確化する。
  - Wave 3 の KPI 管理へ引き継げる残課題（warning 21件）を明記する。
- 非要求:
  - warning 21 件をこのタスク内で解消すること。

## 提案オプション（3案）

1. `ci-failure-runbook` のみ更新
2. runbook + 実装ガイドの両方を更新（採用）
3. docs 更新を後続 wave へ延期

## 推奨案

- 採用: オプション2
- 採用理由:
  - 運用者向け runbook と実装者向けガイドの手順差分を同時に解消できるため。

## 依存関係整理

- depends_on: `2026-02-20__wave2-enforce-doc-quality-fail-mode`
- 依存状態: 解決済み（`2026-02-20__wave2-enforce-doc-quality-fail-mode[done]`）

## 成功条件（要望レベル）

1. CI runbook が `DocQualityMode warning/fail` の実運用順序を説明できる。
2. 実装ガイドが state-validate + consistency-check の運用へ同期される。
3. backlog/state/MEMORY が Wave 3 着手前状態へ更新される。

## blocked 判定

- 依存解決済みのため plan-ready で進行する。
