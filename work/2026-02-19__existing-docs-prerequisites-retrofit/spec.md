# 仕様書: 2026-02-19__existing-docs-prerequisites-retrofit

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `work/2026-02-19__existing-docs-prerequisites-retrofit/request.md`
  - `work/2026-02-19__existing-docs-prerequisites-retrofit/investigation.md`
  - `work/2026-02-19__task-doc-prerequisite-knowledge-section/spec.md`
- 理解ポイント:
  - 既存資料への遡及適用対象を優先順で定義し、段階実装できる仕様にする。

## 1. メタ情報 (Metadata) (必須)

- Task ID: `2026-02-19__existing-docs-prerequisites-retrofit`
- タイトル: Existing Docs Prerequisites Retrofit
- 作成日: 2026-02-19
- 更新日: 2026-02-19
- 作成者: codex
- 関連要望: `work/2026-02-19__existing-docs-prerequisites-retrofit/request.md`
- 依存タスク: `2026-02-19__task-doc-prerequisite-knowledge-section`

## 2. 背景と目的 (Background & Objectives) (必須)

- 背景: 前提知識セクションの標準仕様は導入済みだが、既存資料には未適用が多数残っている。
- 目的: 既存資料へ前提知識セクションを優先度順で遡及適用し、どの資料から読み始めても遡って理解できる導線を整備する。

## 3. スコープ (Scope) (必須)

### 3.1 In Scope (必須)

- `docs/` 配下 markdown（archive/legacy を除く）への前提知識セクション適用。
- `work/` 配下 task 文書（archive/legacy を除く）への前提知識セクション適用。
- 優先度フェーズを以下で固定する。
  - P1: `docs/operations`、`docs/INDEX.md`、active task（planned / in_progress / blocked）文書
  - P2: `docs/specs`、`docs/investigations`、`docs/decisions`、`docs/README.md`
  - P3: 完了済み task 文書（`work/<task-id>/*.md`）
- 各セクションの参照パスはローカル実在パスのみを許可する。

### 3.2 Out of Scope (必須)

- `archive` / `legacy` 配下資料の改変。
- 前提知識セクション以外の大規模リライト。
- checker ルール追加（本タスクでは文書更新を主対象とする）。

## 4. 受入条件 (Acceptance Criteria) (必須)

- AC-001: 対象範囲（archive/legacy 除外）の棚卸し結果と優先度フェーズ（P1-P3）が task 文書で確定している。
- AC-002: P1 対象の全資料に `## 前提知識` セクションが追加され、少なくとも1件の有効ローカル参照パスを含む。
- AC-003: P2 対象の全資料に `## 前提知識` セクションが追加され、参照先が実在する。
- AC-004: P3 対象の全資料に `## 前提知識` セクションが追加され、参照先が実在する。
- AC-005: 更新後に `tools/consistency-check/check.ps1 -AllTasks`、`tools/state-validate/validate.ps1 -AllTasks`、`tools/docs-indexer/index.ps1 -Mode check` が PASS する。
- AC-006: 変更内容が `review.md`、`docs/operations/high-priority-backlog.md`、`MEMORY.md` に反映される。

## 5. テスト要件 (Test Requirements) (必須)

### 5.1 単体テスト (Unit Test) (必須)

- **対象**: 各 markdown 文書の前提知識セクション記述
- **検証項目**:
  - `## 前提知識` 見出しが存在する。
  - セクション内に少なくとも1件のローカル参照パスがある。
  - 参照パスが実在する。
- **合格基準**: P1-P3 の各対象で上記3観点を満たす。

### 5.2 結合テスト (Integration Test) (必須)

- **対象**: task 文書と checker の整合
- **検証項目**:
  - `tools/consistency-check/check.ps1 -TaskId 2026-02-19__existing-docs-prerequisites-retrofit` が PASS。
  - 参照パス解決と related links 検証が PASS。
- **合格基準**: 対象 task の consistency-check が PASS。

### 5.3 回帰テスト (Regression Test) (必須)

- **対象**: framework 全体整合
- **検証項目**:
  - `tools/consistency-check/check.ps1 -AllTasks`
  - `tools/state-validate/validate.ps1 -AllTasks`
  - `tools/docs-indexer/index.ps1 -Mode check`
- **合格基準**: 上記3コマンドがすべて PASS。

### 5.4 手動検証 (Manual Verification) (必須)

- **検証手順**:
  1. P1 の任意資料から前提知識参照先へ辿り、理解可能か確認する。
  2. P2 の任意資料から前提知識参照先へ辿り、理解可能か確認する。
  3. P3 の任意資料から前提知識参照先へ辿り、理解可能か確認する。
  4. archive/legacy が更新対象外として維持されていることを確認する。
- **期待される結果**:
  - すべての手順で参照先が存在し、資料理解の前提が明示されている。

### 5.5 AC-テスト要件対応表 (必須)

- AC-001: Unit Test + Manual Verification-4
- AC-002: Unit Test + Manual Verification-1
- AC-003: Unit Test + Manual Verification-2
- AC-004: Unit Test + Manual Verification-3
- AC-005: Integration Test + Regression Test
- AC-006: Integration Test + Regression Test

## 6. 影響範囲 (Impact Assessment) (必須)

- 影響ファイル/モジュール:
  - `docs/**/*.md`（archive/legacy 除外）
  - `work/*/*.md`（archive/legacy 除外）
  - `docs/operations/high-priority-backlog.md`
  - `work/2026-02-19__existing-docs-prerequisites-retrofit/*`
  - `MEMORY.md`
- 影響する仕様:
  - `work/2026-02-19__task-doc-prerequisite-knowledge-section/spec.md`
  - `docs/operations/skills-framework-flow-guide.md`
- 非機能影響:
  - 文書可読性・オンボーディング効率の向上
  - 大量文書更新に伴うレビュー負荷の増加

## 7. 制約とリスク (Constraints & Risks) (必須)

- 制約: archive/legacy は更新対象外。
- 想定リスク: 大量更新時にリンク切れや記載揺れが発生する可能性。
- 回避策: 優先度フェーズごとに小分けで検証し、各フェーズ完了時に checker を実行する。

## 8. 未確定事項 (Open Issues) (必須)

- なし。

## 9. 関連資料リンク (Reference Links) (必須)

- request: `work/2026-02-19__existing-docs-prerequisites-retrofit/request.md`
- investigation: `work/2026-02-19__existing-docs-prerequisites-retrofit/investigation.md`
- plan: `work/2026-02-19__existing-docs-prerequisites-retrofit/plan.md`
- review: `work/2026-02-19__existing-docs-prerequisites-retrofit/review.md`
- docs:
  - `docs/operations/high-priority-backlog.md`
  - `docs/operations/skills-framework-flow-guide.md`
  - `docs/templates/spec.md`
