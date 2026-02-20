# Request: 2026-02-20__fix-wave3-investigation-broken-tmp-reference

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `work/2026-02-20__wave3-connect-kpi-to-process-findings-loop/investigation.md`
  - `tools/consistency-check/check.ps1`
  - `docs/operations/high-priority-backlog.md`
- 理解ポイント:
  - 現在の `-AllTasks -DocQualityMode warning` で `link_targets_exist` が FAIL している。

## 要望の原文

- DQ-002 以外で検出された起票すべき問題をタスク化する。

## 要望分析

- 直要求:
  - 一時出力パス参照に起因するリンク不整合を解消する。
- 潜在要求:
  - `.tmp` 削除後でも全体 consistency-check が安定して PASS する状態に戻す。
- 非要求:
  - KPI ロジックそのものの再設計。

## 提案オプション（3案）

1. 参照切れ箇所を手修正する。
2. 参照切れ箇所を修正し、同種記述の再発防止ルールを追加する（採用）。
3. 一時ファイルを常時生成する運用へ戻す。

## 推奨案

- 採用: オプション2
- 採用理由:
  - 恒久対策として記述ルールまで残せるため、再発率を下げられる。

## 依存関係整理

- depends_on: なし
- 不足依存: なし

## 成功条件（要望レベル）

1. 当該 task の調査資料でローカル参照不整合が解消される。
2. `-AllTasks -DocQualityMode warning` で DQ-002 以外の FAIL が発生しない。
3. 同種の記述ガイドを明文化できる。

## blocked 判定

- 依存なしのため `plan-ready`。
