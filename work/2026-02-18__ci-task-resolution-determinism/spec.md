# 仕様書: 2026-02-18__ci-task-resolution-determinism

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 1. メタ情報 (Metadata) (必須)

- Task ID: `2026-02-18__ci-task-resolution-determinism`
- タイトル: CI 対象 task-id 決定性強化
- 作成日: 2026-02-18
- 更新日: 2026-02-18
- 作成者: Codex
- 関連要望: `work/2026-02-18__ci-task-resolution-determinism/request.md`

## 2. 背景と目的 (Background & Objectives) (必須)

- 背景: 現在の CI は `work/` の最新更新1件を対象に checker を実行している。
- 目的: 変更差分ベースで task-id を安定決定し、誤った task を検査するリスクを下げる。

## 3. スコープ (Scope) (必須)

### 3.1 In Scope (必須)

- PR / push の変更差分から `work/<task-id>/` を抽出
- 抽出 task-id が1件なら採用
- 抽出結果が0件なら定義済みフォールバック
- 抽出結果が複数件なら失敗
- workflow_dispatch 入力による手動指定の優先適用

### 3.2 Out of Scope (必須)

- checker 本体の検査項目変更
- 複数 task の同時検査実装（別タスクで対応）

## 4. 受入条件 (Acceptance Criteria) (必須)

- AC-001: 変更差分から task-id を1件抽出できる場合、その task-id を採用する。
- AC-002: 複数 task-id が抽出された場合、CI を失敗させる。
- AC-003: task-id 抽出が0件の場合のみフォールバック方式を使う。
- AC-004: workflow_dispatch で明示された task-id がある場合は最優先で採用する。
- AC-005: 仕様更新が `docs/specs/` と `docs/INDEX.md` に反映される。

## 5. テスト要件 (Test Requirements) (必須)

### 5.1 単体テスト (Unit Test) (必須)

- **対象**: task-id 抽出ロジック
- **検証項目**: 0件/1件/複数件の判定
- **合格基準**: 各ケースで期待どおりの分岐になる

### 5.2 結合テスト (Integration Test) (必須)

- **対象**: GitHub Actions workflow
- **検証項目**: 抽出結果を checker step に受け渡せる
- **合格基準**: resolved_task_id output が正しく設定される

### 5.3 回帰テスト (Regression Test) (必須)

- **対象**: 既存 CI step（docs-indexer / index diff / checker）
- **検証項目**: 新ロジック導入後も従来チェックが実行される
- **合格基準**: 既存 successful path が維持される

### 5.4 手動検証 (Manual Verification) (必須)

- **検証手順**:
  1. 単一 task 変更PRの想定差分で解決結果を確認
  2. 複数 task 変更PRの想定差分で失敗することを確認
  3. workflow_dispatch 入力で task-id 上書きを確認
- **期待される結果**: AC-001〜AC-004 を満たす

## 6. 影響範囲 (Impact Assessment) (必須)

- 影響ファイル/モジュール:
  - `.github/workflows/ci-framework.yml`
  - `docs/specs/automation-tools-ci-integration-spec.md`
- 影響する仕様:
  - `docs/specs/automation-tools-design-spec.md`
- 非機能影響:
  - CI 判定の再現性が向上する

## 7. 制約とリスク (Constraints & Risks) (必須)

- 制約: GitHub Actions イベント情報（base/head SHA）に依存する
- 想定リスク: 差分取得失敗時に task-id を決定できない
- 回避策: 明示入力を最優先し、解決不能時は失敗させる

## 8. 未確定事項 (Open Issues) (必須)

- push イベントで `before` SHA が無効な場合は、差分抽出を行わずフォールバック（`work/` ディレクトリ名降順先頭）を採用する

## 9. 関連資料リンク (Reference Links) (必須)

- request: `work/2026-02-18__ci-task-resolution-determinism/request.md`
- investigation: `work/2026-02-18__ci-task-resolution-determinism/investigation.md`
- plan: `work/2026-02-18__ci-task-resolution-determinism/plan.md`
- review: `work/2026-02-18__ci-task-resolution-determinism/review.md`
- docs:
  - `docs/specs/automation-tools-design-spec.md`
  - `docs/specs/automation-tools-ci-integration-spec.md`
