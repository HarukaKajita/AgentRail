# 仕様書: 2026-02-20__wave1-migrate-operations-docs-to-human-centric-model

## 記入ルール

- [空欄禁止] セクションは必ず記入する。
- N/A を使う場合は理由を明記する。
- 受入条件とテスト要件は 1 対 1 で対応付ける。

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `docs/operations/wave0-inventory-human-centric-doc-coverage.md`
  - `docs/operations/wave0-doc-ownership-and-update-matrix.md`
  - `docs/operations/wave1-core-docs-human-centric-migration.md`
  - `work/2026-02-20__wave1-migrate-operations-docs-to-human-centric-model/request.md`
  - `work/2026-02-20__wave1-migrate-operations-docs-to-human-centric-model/investigation.md`
- 理解ポイント:
  - operations docs 補完は Wave 1 normalize task の前提であり、docs 群の説明粒度を揃える。

## 1. メタ情報 [空欄禁止]

- Task ID: 2026-02-20__wave1-migrate-operations-docs-to-human-centric-model
- タイトル: Wave 1: operations主要資料を情報モデルへ移行
- 作成日: 2026-02-20
- 更新日: 2026-02-20
- 作成者: codex
- 関連要望: `work/2026-02-20__wave1-migrate-operations-docs-to-human-centric-model/request.md`

## 2. 背景と目的 [空欄禁止]

- 背景: Wave 0 棚卸しで operations docs のカテゴリ不足が明らかになった。
- 目的: `docs/operations` の主要資料へ「目的/使い方/仕組み/実装/関連」導線を補完する。

## 3. スコープ [空欄禁止]

### 3.1 In Scope [空欄禁止]

- 主要 operations docs の導線補完（runbook/guide/rules/backlog）。
- 補完内容をまとめた migration 記録 docs の追加。
- review と検証結果の記録。

### 3.2 Out of Scope [空欄禁止]

- validator 実装変更（Wave 2 で対応）。
- docs/work cross-link の最終正規化（Wave 1 normalize で対応）。

## 4. 受入条件 (Acceptance Criteria / 受入条件) [空欄禁止]

- AC-001: 主要 operations docs に人間理解導線が追加され、カテゴリ不足が補完される。
- AC-002: 移行結果が `docs/operations/wave1-operations-docs-human-centric-migration.md` と task 資料に記録され、depends_on/backlog/state/plan が整合する。

## 5. テスト要件 (Test Requirements / テスト要件) [空欄禁止]

### 5.1 Unit Test (Unit Test / 単体テスト) [空欄禁止]

- 対象: `work/2026-02-20__wave1-migrate-operations-docs-to-human-centric-model` の request/investigation/spec/plan/review/state
- 観点: 空欄禁止セクション、依存、成果物定義の整合
- 合格条件: consistency-check -TaskId 2026-02-20__wave1-migrate-operations-docs-to-human-centric-model が PASS

### 5.2 Integration Test (Integration Test / 結合テスト) [空欄禁止]

- 対象: depends_on で接続される task 間の整合
- 観点: depends_on 記述と backlog 表示が一致
- 合格条件: 依存 task + 本 task の consistency-check が PASS

### 5.3 Regression Test (Regression Test / 回帰テスト) [空欄禁止]

- 対象: 全 task の state / consistency 運用
- 観点: 既存完了タスクの PASS を維持
- 合格条件: state-validate -AllTasks と consistency-check -AllTasks が PASS

### 5.4 Manual Verification (Manual Verification / 手動検証) [空欄禁止]

- 手順: 対象 operations docs に追加した導線セクションと migration 記録 docs を確認
- 期待結果: AC-001 と AC-002 を満たす

## 6. 影響範囲 [空欄禁止]

- 影響ファイル/モジュール: `docs/operations/ci-failure-runbook.md`, `docs/operations/framework-request-to-commit-visual-guide.md`, `docs/operations/runtime-framework-rules.md`, `docs/operations/high-priority-backlog.md`, `docs/operations/wave1-operations-docs-human-centric-migration.md`, `work/2026-02-20__wave1-migrate-operations-docs-to-human-centric-model/*`, `docs/INDEX.md`, `MEMORY.md`
- 影響する仕様: human-centric docs migration wave 計画
- 非機能影響: 運用資料の理解時間短縮、参照経路の明確化

## 7. 制約とリスク [空欄禁止]

- 制約: depends_on 未解決時は dependency-blocked を維持する。
- 想定リスク:
  - 各 docs の記述粒度が揃わず、読者体験が不統一になる
  - docs 導線更新漏れ
- 回避策: 共通カテゴリ軸で追記し、詳細は migration 記録 docs に集約する。

## 8. 未確定事項 [空欄禁止]

- cross-link の最終整理は Wave 1 normalize task で実施する。

## 9. 関連資料リンク [空欄禁止]

- request: `work/2026-02-20__wave1-migrate-operations-docs-to-human-centric-model/request.md`
- investigation: `work/2026-02-20__wave1-migrate-operations-docs-to-human-centric-model/investigation.md`
- plan: `work/2026-02-20__wave1-migrate-operations-docs-to-human-centric-model/plan.md`
- review: `work/2026-02-20__wave1-migrate-operations-docs-to-human-centric-model/review.md`
- `docs/operations/wave1-operations-docs-human-centric-migration.md`
- `docs/operations/high-priority-backlog.md`
- `docs/operations/ci-failure-runbook.md`
- `docs/operations/framework-request-to-commit-visual-guide.md`
- `docs/operations/runtime-framework-rules.md`
