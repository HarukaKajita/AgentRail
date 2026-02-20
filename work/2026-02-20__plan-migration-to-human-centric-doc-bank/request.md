# Request: 2026-02-20__plan-migration-to-human-centric-doc-bank

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `README.md`
  - `docs/INDEX.md`
  - `docs/operations/high-priority-backlog.md`
  - `work/2026-02-20__redesign-human-centric-doc-bank-governance/spec.md`
- 理解ポイント:
  - 本タスクは再設計方針を既存 docs/tools に移行するための実行計画を定義する。

## 要望の原文

- 方針再設計の後に、既存資料や仕組みを新設計に移行する計画を起票する。
- 各段階を高精度に進行できるよう、段階計画とタスク分割を行う。

## 要望分析

- 直要求:
  - 既存 docs と運用ツールを新しい資料バンク設計へ移行する計画を作成する。
  - 段階ごとの実行順序、ゲート、タスク分割を定義する。
- 潜在要求:
  - 移行中の情報欠損や整合崩れを防ぐ監査手順を含める。
  - 人間理解指標を運用上で評価できるようにする。
- 非要求:
  - 本タスク内での移行実装完了。

## 提案オプション（3案）

1. 低負荷移行:
   - docs のみ更新し、ツール変更は後回しにする。
2. 段階移行（採用）:
   - inventory -> gap 修正 -> ルール適用 -> 検証の順で分割する。
3. 一括移行:
   - すべての docs とツールルールを単一リリースで切り替える。

## 推奨案

- 採用: オプション2（段階移行）
- 採用理由:
  - 大規模変更を監査可能な単位で進められ、回帰リスクを制御しやすい。
- 非採用理由:
  - オプション1は新方針の実効性が不十分。
  - オプション3は失敗時の影響が大きい。

## 依存関係整理

- depends_on: `2026-02-20__redesign-human-centric-doc-bank-governance`
- 依存状態: 解決済み（先行タスク `2026-02-20__redesign-human-centric-doc-bank-governance` が done）

## 成功条件（要望レベル）

1. 既存 docs/tools を新設計へ移行する段階計画とロールアウト手順が定義される。
2. 移行フェーズごとのタスク分割、受入条件、検証戦略が定義される。
3. depends_on と gate 状態が backlog/state/plan で整合する。

## blocked 判定

- 先行タスク完了前は `dependency-blocked` を維持し、完了後は `plan-ready` を経て実行計画を確定した。
