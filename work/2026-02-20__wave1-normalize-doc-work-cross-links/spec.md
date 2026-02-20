# 仕様書: 2026-02-20__wave1-normalize-doc-work-cross-links

## 記入ルール

- [空欄禁止] セクションは必ず記入する。
- N/A を使う場合は理由を明記する。
- 受入条件とテスト要件は 1 対 1 で対応付ける。

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `docs/operations/wave1-core-docs-human-centric-migration.md`
  - `docs/operations/wave1-operations-docs-human-centric-migration.md`
  - `docs/operations/high-priority-backlog.md`
  - `work/2026-02-20__wave1-normalize-doc-work-cross-links/request.md`
  - `work/2026-02-20__wave1-normalize-doc-work-cross-links/investigation.md`
- 理解ポイント:
  - Wave 1 normalize は docs/work 双方向リンクの表記ゆれ解消を担当する。

## 1. メタ情報 [空欄禁止]

- Task ID: 2026-02-20__wave1-normalize-doc-work-cross-links
- タイトル: Wave 1: docs-work 相互リンク正規化
- 作成日: 2026-02-20
- 更新日: 2026-02-20
- 作成者: codex
- 関連要望: `work/2026-02-20__wave1-normalize-doc-work-cross-links/request.md`

## 2. 背景と目的 [空欄禁止]

- 背景: Wave 1 core/operations 移行で docs が増え、相互参照の表記ゆれが発生しやすくなっている。
- 目的: docs と work の相互参照を統一し、参照切れを解消する。

## 3. スコープ [空欄禁止]

### 3.1 In Scope [空欄禁止]

- docs/work 相互リンクの表記ルールを明文化する。
- 主要 migration docs へ統一表記を適用する。
- 正規化結果 docs を追加し、後続 Wave 2 へ引き継ぐ。
- review と検証結果の記録。

### 3.2 Out of Scope [空欄禁止]

- validator 実装変更（Wave 2 で対応）。
- KPI 自動集計（Wave 3 で対応）。

## 4. 受入条件 (Acceptance Criteria / 受入条件) [空欄禁止]

- AC-001: docs/work 相互リンクの表記ルールと正規化結果が `docs/operations/wave1-doc-work-cross-link-normalization.md` に記録される。
- AC-002: depends_on と backlog/state/plan の整合が維持され、Wave 2 仕様タスクを plan-ready に更新できる。

## 5. テスト要件 (Test Requirements / テスト要件) [空欄禁止]

### 5.1 Unit Test (Unit Test / 単体テスト) [空欄禁止]

- 対象: `work/2026-02-20__wave1-normalize-doc-work-cross-links` の request/investigation/spec/plan/review/state
- 観点: 空欄禁止セクション、依存、成果物定義の整合
- 合格条件: consistency-check -TaskId 2026-02-20__wave1-normalize-doc-work-cross-links が PASS

### 5.2 Integration Test (Integration Test / 結合テスト) [空欄禁止]

- 対象: depends_on で接続される task 間の整合
- 観点: depends_on 記述と backlog 表示が一致
- 合格条件: 依存 task + 本 task の consistency-check が PASS

### 5.3 Regression Test (Regression Test / 回帰テスト) [空欄禁止]

- 対象: 全 task の state / consistency 運用
- 観点: 既存完了タスクの PASS を維持
- 合格条件: state-validate -AllTasks と consistency-check -AllTasks が PASS

### 5.4 Manual Verification (Manual Verification / 手動検証) [空欄禁止]

- 手順: 正規化対象 docs の links 表記が統一されていることを目視確認する
- 期待結果: AC-001 と AC-002 を満たす

## 6. 影響範囲 [空欄禁止]

- 影響ファイル/モジュール: `docs/operations/wave1-core-docs-human-centric-migration.md`, `docs/operations/wave1-operations-docs-human-centric-migration.md`, `docs/operations/wave1-doc-work-cross-link-normalization.md`, `docs/operations/high-priority-backlog.md`, `work/2026-02-20__wave1-normalize-doc-work-cross-links/*`, `docs/INDEX.md`, `MEMORY.md`
- 影響する仕様: human-centric docs migration wave 計画
- 非機能影響: 参照追跡の一貫性向上、レビュー効率向上

## 7. 制約とリスク [空欄禁止]

- 制約: depends_on 未解決時は dependency-blocked を維持する。
- 想定リスク:
  - 表記統一ルールが曖昧で再び揺れが発生する
  - docs 導線更新漏れ
- 回避策: ルールと具体例を同一 docs に記録し、対象ファイルへ反映する。

## 8. 未確定事項 [空欄禁止]

- Wave 2 で追加される品質チェック項目と cross-link ルールの結合方式。

## 9. 関連資料リンク [空欄禁止]

- request: `work/2026-02-20__wave1-normalize-doc-work-cross-links/request.md`
- investigation: `work/2026-02-20__wave1-normalize-doc-work-cross-links/investigation.md`
- plan: `work/2026-02-20__wave1-normalize-doc-work-cross-links/plan.md`
- review: `work/2026-02-20__wave1-normalize-doc-work-cross-links/review.md`
- `docs/operations/wave1-doc-work-cross-link-normalization.md`
- `docs/operations/wave1-core-docs-human-centric-migration.md`
- `docs/operations/wave1-operations-docs-human-centric-migration.md`
- `docs/operations/high-priority-backlog.md`
