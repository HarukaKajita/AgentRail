# Request: 2026-02-20__prioritize-dq002-warning-remediation

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `docs/operations/wave2-doc-quality-warning-mode.md`
  - `docs/operations/high-priority-backlog.md`
  - `MEMORY.md`
- 理解ポイント:
  - DQ-002 warning は `DocQualityMode warning` で 21 件観測されており、解消優先順の未定義が残課題。

## 要望の原文

- DQ-002 警告解消の follow-up タスクを起票する。

## 要望分析

- 直要求:
  - 21件の DQ-002 warning を解消するための着手順を定義する。
- 潜在要求:
  - docs/task owner が順序に合意できる優先度基準を明示する。
  - 連続起票できる粒度まで分割方針を固める。
- 非要求:
  - このタスク内で warning 21件を実装解消すること。

## 提案オプション（3案）

1. warning 一覧のみ作成する。
2. warning 一覧 + 優先度基準 + 分割起票順を定義する（採用）。
3. 21件を一括修正する実装タスクを即時起票する。

## 推奨案

- 採用: オプション2
- 採用理由:
  - 実装前に優先順の合意を作ることで、連鎖タスクの手戻りを抑制できる。

## 依存関係整理

- depends_on: なし
- 不足依存: なし

## 成功条件（要望レベル）

1. DQ-002 warning 21件を対象カテゴリ別に整理できる。
2. 優先度基準（must/high/medium 相当）と実施順を文書化できる。
3. 後続の実装タスク群へ接続する起票方針を定義できる。

## blocked 判定

- 現時点の不足情報はなく、`plan-ready` で進行可能。
