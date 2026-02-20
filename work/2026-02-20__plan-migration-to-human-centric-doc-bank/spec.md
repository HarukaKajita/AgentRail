# 仕様書: 2026-02-20__plan-migration-to-human-centric-doc-bank

## 記入ルール

- `[空欄禁止]` セクションは必ず記入する。
- N/A を使う場合は理由を明記する。
- 受入条件とテスト要件は 1 対 1 で対応付ける。

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `docs/operations/high-priority-backlog.md`
  - `work/2026-02-20__plan-migration-to-human-centric-doc-bank/request.md`
  - `work/2026-02-20__plan-migration-to-human-centric-doc-bank/investigation.md`
  - `work/2026-02-20__redesign-human-centric-doc-bank-governance/spec.md`
- 理解ポイント:
  - 本タスクは移行「実装」ではなく、移行「計画」を高精度に定義する。

## 1. メタ情報 [空欄禁止]

- Task ID: 2026-02-20__plan-migration-to-human-centric-doc-bank
- タイトル: 人間理解中心資料バンクへの既存資産移行計画を起票
- 作成日: 2026-02-20
- 更新日: 2026-02-20
- 作成者: codex
- 関連要望: `work/2026-02-20__plan-migration-to-human-centric-doc-bank/request.md`

## 2. 背景と目的 [空欄禁止]

- 背景: 方針再設計だけでは運用に定着しないため、既存 docs と仕組みを段階移行する実行設計が必要。
- 目的: 移行対象の棚卸し、フェーズ分割、依存順序、品質ゲート、ロールバックを定義する。

## 3. スコープ [空欄禁止]

### 3.1 In Scope [空欄禁止]

- 既存 docs/運用仕組みの移行対象分類（must/should/later）を定義する。
- 移行フェーズ（Inventory, Gap Fix, Rule Apply, Automation Expand）を定義する。
- フェーズごとのタスク分割・ゲート条件・受入条件を定義する。
- 移行時の検証戦略と rollback 戦略を定義する。

### 3.2 Out of Scope [空欄禁止]

- docs 全件の実改修。
- consistency-check/state-validate の実装拡張。

## 4. 受入条件 (Acceptance Criteria / 受入条件) [空欄禁止]

- AC-001: 既存資産を新設計へ移行する段階計画（フェーズ、成果物、ゲート、ロールバック）が task 資料と `docs/operations/human-centric-doc-bank-migration-plan.md` に明記される。
- AC-002: depends_on と backlog/state/plan の整合が維持され、Task A 完了後に着手できる状態になる。

## 5. テスト要件 (Test Requirements / テスト要件) [空欄禁止]

### 5.1 Unit Test (Unit Test / 単体テスト) [空欄禁止]

- 対象: 本 task の request/investigation/spec/plan/review/state
- 観点: 移行フェーズ、依存、ゲート、成果物が明記されている
- 合格条件: 本 task の `consistency-check` が PASS

### 5.2 Integration Test (Integration Test / 結合テスト) [空欄禁止]

- 対象: Task A と Task B の依存連携
- 観点: Task B の depends_on が Task A と一致し、backlog 表記と一致する
- 合格条件: Task A + Task B 指定の `consistency-check` が PASS

### 5.3 Regression Test (Regression Test / 回帰テスト) [空欄禁止]

- 対象: 全 task の状態整合と docs index 運用
- 観点: 既存運用を壊さず新規起票が整合する
- 合格条件: `state-validate -AllTasks` と `consistency-check -AllTasks` が PASS

### 5.4 Manual Verification (Manual Verification / 手動検証) [空欄禁止]

- 手順: backlog と MEMORY を確認し、進行順序が Task A -> Task B で明示されていることを確認する
- 期待結果: AC-001 と AC-002 を満たす

## 6. 影響範囲 [空欄禁止]

- 影響ファイル/モジュール: `work/2026-02-20__plan-migration-to-human-centric-doc-bank/*`, `docs/operations/human-centric-doc-bank-migration-plan.md`, `docs/operations/high-priority-backlog.md`, `MEMORY.md`
- 影響する仕様: docs 移行計画、タスク依存ルール、段階ゲート運用
- 非機能影響: 移行時の可視性、監査性、合意形成速度が向上する

## 7. 制約とリスク [空欄禁止]

- 制約: Task A 完了までは実行計画を確定しても実装着手しない
- 想定リスク:
  - フェーズ分割が粗く、実行時に再分割コストが増える
  - 指標定義が曖昧で移行完了判定が不明確になる
- 回避策: 各フェーズに完了条件・入力・出力・rollback を明記する

## 8. 未確定事項 [空欄禁止]

- 自動評価に組み込む最終 KPI 指標の閾値

## 9. 関連資料リンク [空欄禁止]

- request: `work/2026-02-20__plan-migration-to-human-centric-doc-bank/request.md`
- investigation: `work/2026-02-20__plan-migration-to-human-centric-doc-bank/investigation.md`
- plan: `work/2026-02-20__plan-migration-to-human-centric-doc-bank/plan.md`
- review: `work/2026-02-20__plan-migration-to-human-centric-doc-bank/review.md`
- docs:
  - `docs/operations/human-centric-doc-bank-migration-plan.md`
  - `docs/operations/high-priority-backlog.md`
