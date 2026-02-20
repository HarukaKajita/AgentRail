# Request: 2026-02-20__wave2-implement-doc-quality-warning-mode

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/wave2-doc-quality-check-rules-spec.md`
  - `docs/operations/high-priority-backlog.md`
  - `tools/consistency-check/check.ps1`
  - `tools/state-validate/validate.ps1`
- 理解ポイント:
  - 本タスクは Wave 2-1 として docs 品質チェックを warning モードで段階導入する実装タスクである。

## 要望の原文

- docs 品質チェックを warning モードで段階導入する。
- wave 計画の依存順序を維持し、品質ゲートを満たす成果物を作成する。

## 要望分析

- 直要求:
  - `consistency-check` / `state-validate` に docs 品質チェックの warning 集計を追加する。
  - warning を CI 失敗にしない段階導入モードを実装する。
- 潜在要求:
  - fail モード昇格（後続タスク）へ接続できる同一出力スキーマを整備する。
  - warning 件数の観測結果を運用 docs に残す。
- 非要求:
  - fail モードを既定化すること。

## 提案オプション（3案）

1. 最小実装:
   - `consistency-check` のみ warning 表示を追加する。
2. 標準実装（採用）:
   - `consistency-check` と `state-validate` の両方に `-DocQualityMode` を実装し、同一の summary 出力を導入する。
3. 拡張実装:
   - CI 既定値まで fail に切り替える。

## 推奨案

- 採用: オプション2（標準実装）
- 採用理由:
  - Wave 2-2 の fail 昇格へ同一インタフェースで接続でき、運用リスクを抑えられるため。

## 依存関係整理

- depends_on: `2026-02-20__wave2-spec-doc-quality-check-rules`
- 依存状態: 解決済み（`2026-02-20__wave2-spec-doc-quality-check-rules[done]`）

## 成功条件（要望レベル）

1. `tools/consistency-check/check.ps1` に docs品質 warning モードが実装される。
2. `tools/state-validate/validate.ps1` に docs品質 warning モードが実装される。
3. 実装仕様と運用手順が docs に記録され、後続 fail モードタスクへ引き継げる。

## blocked 判定

- 依存解決済みのため plan-ready で進行する。
