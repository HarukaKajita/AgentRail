# Request: 2026-02-20__dependency-gate-before-plan-flow

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `docs/operations/skills-framework-flow-guide.md`
  - `docs/operations/high-priority-backlog.md`
- 理解ポイント:
  - 依存解決前に詳細計画を確定すると手戻りが増えるため、計画を2段階化する。

## 要望の原文

- plan（実装計画）の後に depends_on（依存解決確認）のフローになっているが、依存解決を先にして依存タスク完了後に実装計画を立てるほうが良いのではないか。
- ソフトウェア開発のベストプラクティス観点で意見がほしい。
- その方針で起票してほしい。
- `plan-draft -> 依存解決 -> plan-final` を採用したい。

## 要望分析

- 直要求:
  - `plan-draft -> depends_on gate -> plan-final` の2段階計画フローを仕様化する。
  - 依存未解決時は `plan-final` と実装着手を禁止する。
- 潜在要求:
  - 前提未確定な詳細計画を避け、再計画コストを下げる。
  - 依存解決状況を計画確定条件として明確化する。
- 非要求:
  - 本リクエスト内でフロー改修実装完了までは求めない。
  - 外部プロジェクト管理ツール連携は求めない。

## 提案オプション（3案）

1. 1段階計画:
   - `depends_on gate` 通過後にのみ `plan` を作成する。
2. 2段階計画（採用）:
   - `plan-draft` を先に作成し、依存解決後に `plan-final` を確定する。
3. 現行維持:
   - `plan` 後に依存確認し、必要なら再計画する。

## 推奨案

- 採用: オプション2（2段階計画）
- 採用理由:
  - 依存調査のための軽量計画を残しつつ、詳細計画は依存解決後に確定できるため。
  - Definition of Ready と実務上の探索コストの両方を両立できるため。
- 非採用理由:
  - オプション1は初期探索の情報が不足しやすい。
  - オプション3は手戻りを許容する運用で再発防止にならない。

## 分割提案

1. フロー定義更新:
   - docs/skills で `plan-draft` と `plan-final` の役割を定義する。
2. 検証ルール更新:
   - validator/checker で `plan-final` 確定条件（gate pass）を検証する。
3. 表示更新:
   - backlog/Rail10 で `plan-draft`, `plan-ready`, `dependency-blocked` を表示する。

## 確認質問（2〜4件）

- なし（方針はユーザー指定で確定）。

## request 反映方針

- `plan-draft -> depends_on gate -> plan-final` を標準フローとして起票し、AC とテスト要件に反映する。

## blocked 判定

- blocked ではない。
