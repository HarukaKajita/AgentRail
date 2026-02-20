# Request: 2026-02-20__add-runtime-installer-with-agentrail-work-layout

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `docs/operations/high-priority-backlog.md`
- 理解ポイント:
  - 外部利用時に開発用資産を混在させない構成を優先する。

## 要望の原文

- 外部利用時の成果物は .agentrail/work に統一する。
- 配布は当面 dist/runtime コピー方式とし、将来の package 化も見据える。
- AGENTS.md の runtime 必須記述は別ファイルへ分離し、AGENTS.md は要旨とリンクを保持する。

## 要望分析

- 直要求:
  - 外部利用時の成果物を .agentrail/work に統一し、導入をスクリプト化する。
  - 単一リポジトリ運用のまま分離強化を実現する。
- 潜在要求:
  - 外部導入の初期化と更新を手作業に依存させない。
  - package 化へ移行可能な境界を初期段階から確保する。
- 非要求:
  - Core/Dogfood のリポジトリ分割。

## 提案オプション（3案）

1. 最小変更:
   - 現行運用を維持し、必要時に手動で不要物を除外する。
2. バランス（採用）:
   - runtime 配布境界を定義し、導入手順とパス解決を段階的に統一する。
3. 先行投資:
   - 直ちに package 化まで実装して配布方式を一本化する。

## 推奨案

- 採用: オプション2（バランス）
- 採用理由:
  - 直近の混在問題を止血しつつ、将来の package 化移行余地を残せる。
- 非採用理由:
  - オプション1は再発防止が弱い。
  - オプション3は現時点でスコープ過大。

## 依存関係整理

- depends_on: `2026-02-20__define-runtime-manifest-and-export-flow`
- 依存状態: 未解決（先行タスク完了待ち）

## 成功条件（要望レベル）

1. work/2026-02-20__add-runtime-installer-with-agentrail-work-layout/spec.md に具体要件と受入条件が定義される。
2. work/2026-02-20__add-runtime-installer-with-agentrail-work-layout/plan.md に plan-draft / depends_on gate / plan-final が定義される。
3. 依存タスクと優先度情報が docs/operations/high-priority-backlog.md と整合する。

## blocked 判定

- 起票時点では planned。plan-final 確定前に depends_on gate を実施する。

