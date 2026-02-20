# 仕様書: 2026-02-18__ci-task-resolution-no-fallback

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 1. メタ情報 (Metadata) (必須)

- Task ID: `2026-02-18__ci-task-resolution-no-fallback`
- タイトル: CI task-id 解決の fallback 廃止と checker 実行条件分岐
- 作成日: 2026-02-18
- 更新日: 2026-02-18
- 作成者: Codex
- 関連要望: `work/2026-02-18__ci-task-resolution-no-fallback/request.md`

## 2. 背景と目的 (Background & Objectives) (必須)

- 背景: 差分0件時 fallback により無関係 task が checker 対象となり、不要な CI fail が発生しうる。
- 目的: task-id 解決を `manual` / `diff` のみに限定し、差分0件では checker を skip して誤検査を防止する。

## 3. スコープ (Scope) (必須)

### 3.1 In Scope (必須)

- `tools/ci/resolve-task-id.ps1` から fallback 分岐を除去する。
- 差分0件時の `skip` 結果出力を追加する。
- `.github/workflows/ci-framework.yml` で `skip` 時に checker 系 step を実行しない条件分岐を追加する。
- `workflow_dispatch` で `task_id` 未指定時に fail-fast する。

### 3.2 Out of Scope (必須)

- consistency-check のルール内容変更
- docs-indexer の挙動変更

## 4. 受入条件 (Acceptance Criteria) (必須)

- AC-001: push / pull_request で差分 task が 1 件ならその task を checker 対象にする。
- AC-002: push / pull_request で差分 task が 0 件なら checker 系 step を skip し、ジョブは成功終了する。
- AC-003: 差分 task が複数件なら fail-fast する。
- AC-004: `workflow_dispatch` で `task_id` 未指定なら fail-fast する。
- AC-005: `workflow_dispatch` で有効 `task_id` 指定時は checker 系 step を実行できる。

## 5. テスト要件 (Test Requirements) (必須)

### 5.1 単体テスト (Unit Test) (必須)

- **対象**: `tools/ci/resolve-task-id.ps1`
- **検証項目**: `manual` / `diff` / `skip` / `fail` 分岐
- **合格基準**: 各イベント条件で期待どおり終了コードと出力が得られる

### 5.2 結合テスト (Integration Test) (必須)

- **対象**: `.github/workflows/ci-framework.yml`
- **検証項目**: `resolve` 出力に応じた step 実行条件
- **合格基準**: `skip` 時に `scan` / `check` が実行されない

### 5.3 回帰テスト (Regression Test) (必須)

- **対象**: 既存 CI 成功パス（manual指定・差分1件）
- **検証項目**: 既存の正常ケースが維持される
- **合格基準**: 既存検証が PASS する

### 5.4 手動検証 (Manual Verification) (必須)

- **検証手順**:
  1. `workflow_dispatch` + `task_id` 指定で実行
  2. `workflow_dispatch` + `task_id` 未指定で実行
  3. push/pull_request で差分0件ケースを確認
  4. push/pull_request で差分1件ケースを確認
- **期待される結果**: AC-001〜AC-005 を満たす

## 6. 影響範囲 (Impact Assessment) (必須)

- 影響ファイル/モジュール:
  - `tools/ci/resolve-task-id.ps1`
  - `.github/workflows/ci-framework.yml`
- 影響する仕様:
  - `docs/specs/automation-tools-ci-integration-spec.md`
  - `docs/specs/automation-tools-design-spec.md`
  - `docs/decisions/20260218-ci-governance-and-task-resolution.md`
- 非機能影響:
  - CI 判定ノイズ削減
  - 判定再現性向上

## 7. 制約とリスク (Constraints & Risks) (必須)

- 制約: 既存 `resolve-task-id` 出力契約との互換を維持する。
- 想定リスク: 条件分岐ミスで checker が意図せず skip される。
- 回避策: source種別を出力し、workflow 条件を明示的にテストする。

## 8. 未確定事項 (Open Issues) (必須)

- `skip` 時のログフォーマット詳細。

## 9. 関連資料リンク (Reference Links) (必須)

- request: `work/2026-02-18__ci-task-resolution-no-fallback/request.md`
- investigation: `work/2026-02-18__ci-task-resolution-no-fallback/investigation.md`
- plan: `work/2026-02-18__ci-task-resolution-no-fallback/plan.md`
- review: `work/2026-02-18__ci-task-resolution-no-fallback/review.md`
- docs:
  - `docs/specs/automation-tools-ci-integration-spec.md`
  - `docs/specs/automation-tools-design-spec.md`
  - `docs/decisions/20260218-ci-governance-and-task-resolution.md`
