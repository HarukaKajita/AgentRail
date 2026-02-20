# Request: 2026-02-20__wave0-inventory-human-centric-doc-coverage

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/human-centric-doc-bank-governance.md`
  - `docs/operations/human-centric-doc-bank-migration-plan.md`
  - `docs/operations/high-priority-backlog.md`
- 理解ポイント:
  - Wave 0: must対象の資料棚卸しと欠落マップ作成 は wave 計画に基づく実行タスクである。

## 要望の原文

- must対象資料の棚卸しと欠落カテゴリ（目的/使い方/仕組み/実装/関連）の可視化を行う。
- wave 計画の依存順序を維持し、品質ゲートを満たす成果物を作成する。

## 要望分析

- 直要求:
  - Wave 0: must対象の資料棚卸しと欠落マップ作成 の成果物を定義し、task 一式へ反映する。
  - depends_on と gate 状態を明確化する。
- 潜在要求:
  - `docs` / `work` の相互参照を維持し、後続 wave へ引き継げる情報を残す。
- 非要求:
  - 後続 wave の実装完了。

## 提案オプション（3案）

1. 最小実行:
   - 最低限の成果物のみ作成する。
2. 標準実行（採用）:
   - 受入条件・テスト要件・依存整合まで同時に確定する。
3. 拡張実行:
   - 後続 wave の内容まで先行実装する。

## 推奨案

- 採用: オプション2（標準実行）
- 採用理由:
  - 依存順序を守りながら、完了判定に必要な品質証跡を残せる。

## 依存関係整理

- depends_on: 2026-02-20__plan-migration-to-human-centric-doc-bank
- 依存状態: 解決済み

## 成功条件（要望レベル）

1. Wave 0: must対象の資料棚卸しと欠落マップ作成 の成果物が task 資料と関連 docs に明文化される。
2. depends_on と gate 状態が backlog/state/plan で整合する。
3. 後続 task が参照可能な形で引き継ぎ情報が記録される。

## blocked 判定

- 依存解決済みのため plan-ready。


