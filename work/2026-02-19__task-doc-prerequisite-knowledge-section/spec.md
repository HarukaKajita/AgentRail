# 仕様書: 2026-02-19__task-doc-prerequisite-knowledge-section

## 1. メタ情報 [空欄禁止]

- Task ID: `2026-02-19__task-doc-prerequisite-knowledge-section`
- タイトル: Task and Spec Docs Prerequisite Knowledge Section Standardization
- 作成日: 2026-02-19
- 更新日: 2026-02-19
- 作成者: codex
- 関連要望: `work/2026-02-19__task-doc-prerequisite-knowledge-section/request.md`

## 2. 背景と目的 [空欄禁止]

- 背景: 仕様資料と task 資料には、読み始め時点で必要な前提知識を明示する共通フォーマットがなく、理解導線が暗黙化している。
- 目的: 各資料に前提知識セクションを導入し、どの資料から読んでも参照を遡ることで十分に理解できる状態を運用として定着させる。

## 3. スコープ [空欄禁止]

### 3.1 In Scope [空欄禁止]

- 前提知識セクションの標準スキーマを定義する。
- 対象資料を明確化する。
  - `work/<task-id>/request.md`
  - `work/<task-id>/investigation.md`
  - `work/<task-id>/spec.md`
  - `work/<task-id>/plan.md`
  - `work/<task-id>/review.md`
  - `docs/specs/*.md`
- 新規 task 作成時に前提知識セクションが初期生成されるように、起票生成ロジックとテンプレート運用方針を更新する。
- 整合チェックに前提知識セクションの存在と参照妥当性の検証を追加する方針を定義する。
- 既存 active task/docs への適用方針（遡及更新順序と完了判定）を定義する。

### 3.2 Out of Scope [空欄禁止]

- `archive/` 配下の歴史資料を全面改稿すること。
- 前提知識導線の自動可視化ツール新規開発。
- task 資料以外の任意 docs 全体に一律適用すること。

## 4. 受入条件 (Acceptance Criteria / 受入条件) [空欄禁止]

- AC-001: 前提知識セクションの標準形式（見出し名、必須項目、記法）が仕様として定義される。
- AC-002: 新規 task の 5資料（request/investigation/spec/plan/review）に前提知識セクションが生成される設計が確定する。
- AC-003: 既存 active task/docs へ遡及適用する対象範囲と完了条件が定義される。
- AC-004: consistency-check に前提知識セクション検証を追加する要件（必須性、参照存在確認、エラーメッセージ）が定義される。
- AC-005: docs 導線、review 記録、state 更新の運用要件が定義される。

## 5. テスト要件 (Test Requirements / テスト要件) [空欄禁止]

### 5.1 Unit Test (Unit Test / 単体テスト) [空欄禁止]

- 対象: 前提知識セクション検証ロジック（見出し検出、必須項目検出、参照先存在判定）
- 観点:
  - セクション欠落時に FAIL になる。
  - 参照先が存在しない場合に FAIL になる。
  - 規定フォーマットを満たす場合に PASS になる。
- 合格条件: 正常系1ケース、異常系2ケース以上で期待どおりの判定結果を返す。

### 5.2 Integration Test (Integration Test / 結合テスト) [空欄禁止]

- 対象: 新規 task 起票フローと前提知識セクション初期生成
- 観点:
  - task 起票時に 5資料へ前提知識セクションが自動付与される。
  - `tools/consistency-check/check.ps1` がセクションを認識して判定できる。
- 合格条件: 生成直後の task で consistency-check が PASS する。

### 5.3 Regression Test (Regression Test / 回帰テスト) [空欄禁止]

- 対象: 既存 docs/work 運用
- 観点:
  - 既存の必須成果物チェックと docs index チェックに回帰がない。
  - 前提知識セクション追加後も task 完了判定ロジックが破綻しない。
- 合格条件:
  - `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks` が PASS。
  - `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check` が PASS。

### 5.4 Manual Verification (Manual Verification / 手動検証) [空欄禁止]

- 手順:
  1. 任意の task 資料を1つ選び、前提知識セクションの参照先を順に開く。
  2. 参照を遡って、最終的に基礎資料（例: `docs/INDEX.md`、`AGENTS.md`、関連 spec）へ到達できることを確認する。
  3. 参照チェーン上で、資料理解に必要な定義が欠落していないことを確認する。
  4. review/state への記録項目が運用ルールどおり更新されることを確認する。
- 期待結果: どの起点資料でも前提知識セクションを辿ることで理解可能状態に到達できる。

### 5.5 AC-テスト対応表 [空欄禁止]

- AC-001: Unit Test + Manual Verification-1/2
- AC-002: Integration Test
- AC-003: Integration Test + Manual Verification-1/4
- AC-004: Unit Test + Regression Test
- AC-005: Regression Test + Manual Verification-4

## 6. 影響範囲 [空欄禁止]

- 影響ファイル/モジュール:
  - `docs/templates/spec.md`
  - `docs/templates/investigation.md`
  - `docs/templates/review.md`
  - `tools/improvement-harvest/create-task.ps1`
  - `tools/consistency-check/check.ps1`
  - `work/*/request.md`
  - `work/*/investigation.md`
  - `work/*/spec.md`
  - `work/*/plan.md`
  - `work/*/review.md`
  - `docs/specs/*.md`
- 影響する仕様:
  - `docs/operations/high-priority-backlog.md`
  - `docs/INDEX.md`
- 非機能影響:
  - ドキュメント理解時間の短縮
  - 引き継ぎ容易性の向上
  - docs 品質の均一化

## 7. 制約とリスク [空欄禁止]

- 制約:
  - 前提知識セクションは機械検証可能な形式で定義する。
  - path 記載はリポジトリ相対パスを基本とする。
- 想定リスク:
  - 大量ドキュメント更新により差分量が増える。
  - 参照循環が発生し、遡及導線が分かりにくくなる。
  - checker の判定厳格化で既存タスクが一時的に FAIL する。
- 回避策:
  - 遡及更新順序を定義し、段階的に整合を取る。
  - 参照循環禁止ルールを運用に明記する。
  - エラーメッセージに修正方法を含め、fail-fast でも復旧しやすくする。

## 8. 未確定事項 [空欄禁止]

- なし。

## 9. 関連資料リンク [空欄禁止]

- request: `work/2026-02-19__task-doc-prerequisite-knowledge-section/request.md`
- investigation: `work/2026-02-19__task-doc-prerequisite-knowledge-section/investigation.md`
- plan: `work/2026-02-19__task-doc-prerequisite-knowledge-section/plan.md`
- review: `work/2026-02-19__task-doc-prerequisite-knowledge-section/review.md`
- docs:
  - `docs/operations/high-priority-backlog.md`
