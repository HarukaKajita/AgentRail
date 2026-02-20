# 仕様書: 2026-02-18__framework-request-to-commit-visual-guide

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 1. メタ情報 (Metadata) (必須)

- Task ID: `2026-02-18__framework-request-to-commit-visual-guide`
- タイトル: ユーザー要望から実装・コミットまでのフロー可視化資料作成
- 作成日: 2026-02-19
- 更新日: 2026-02-19
- 作成者: Codex
- 関連要望: `work/2026-02-18__framework-request-to-commit-visual-guide/request.md`

## 2. 背景と目的 (Background & Objectives) (必須)

- 背景: フレームワーク利用者が、要望提示から実装・コミットまでの全体像と各工程の意味を把握しづらい。
- 目的: フロー図と具体サンプルを備えた運用資料を追加し、初見ユーザーでも依頼方法と進行イメージを理解できるようにする。

## 3. スコープ (Scope) (必須)

### 3.1 In Scope (必須)

- docs/operations/framework-request-to-commit-visual-guide.md を新規作成する。
- 要望提示からコミットまでの工程を Mermaid フローチャートで可視化する。
- 各工程の説明、成果物、blocked/done 分岐条件を文章で整理する。
- CLI 要望サンプルと AI 応答サンプルを資料へ掲載する。
- `docs/INDEX.md` の運用セクションに新規資料リンクを追加する。

### 3.2 Out of Scope (必須)

- 既存 CI スクリプトや checker ロジックの機能変更。
- docs 全体の構成刷新。

## 4. 受入条件 (Acceptance Criteria) (必須)

- AC-001: 新規資料に Mermaid フローチャートがあり、要望提示からコミットまでの工程と分岐が表現されている。
- AC-002: 新規資料に CLI 要望サンプルと AI 応答サンプルが含まれている。
- AC-003: 新規資料が `docs/INDEX.md` から参照可能である。
- AC-004: 既存運用資料の整合が維持され、`consistency-check` が PASS する。

## 5. テスト要件 (Test Requirements) (必須)

### 5.1 単体テスト (Unit Test) (必須)

- **対象**: 新規資料の構成（見出し、図、サンプル節）
- **検証項目**: 必須要素（図/CLIサンプル/AI応答サンプル）が欠落していない
- **合格基準**: 資料単体で要素欠落がない

### 5.2 結合テスト (Integration Test) (必須)

- **対象**: `docs/INDEX.md` と新規資料の導線
- **検証項目**: INDEX から資料へリンク可能
- **合格基準**: リンク切れがない

### 5.3 回帰テスト (Regression Test) (必須)

- **対象**: 既存 docs 運用フロー
- **検証項目**: `docs-indexer` 実行後に意図しない差分が発生しない
- **合格基準**: `docs-indexer` が期待どおり PASS する

### 5.4 手動検証 (Manual Verification) (必須)

- **検証手順**:
  1. 新規資料を開いてフロー図と解説内容を確認する
  2. CLI 要望サンプルと AI 応答サンプルを確認する
  3. `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode apply` を実行する
  4. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-18__framework-request-to-commit-visual-guide` を実行する
- **期待される結果**: AC-001〜AC-004 を満たす

## 6. 影響範囲 (Impact Assessment) (必須)

- 影響ファイル/モジュール:
  - docs/operations/framework-request-to-commit-visual-guide.md
  - `docs/INDEX.md`
  - `work/2026-02-18__framework-request-to-commit-visual-guide/*`
- 影響する仕様:
  - `docs/operations/high-priority-backlog.md`
- 非機能影響:
  - 新規ユーザーのオンボーディング効率向上

## 7. 制約とリスク (Constraints & Risks) (必須)

- 制約: 図は Markdown 上で管理可能な Mermaid 形式を使用する。
- 想定リスク: 工程説明が抽象的になり、実運用で使いにくい資料になる。
- 回避策: 実際の CLI/AI 応答サンプルを含めて具体性を担保する。

## 8. 未確定事項 (Open Issues) (必須)

- CLI サンプルで扱う機能追加テーマの最終題材。

## 9. 関連資料リンク (Reference Links) (必須)

- request: `work/2026-02-18__framework-request-to-commit-visual-guide/request.md`
- investigation: `work/2026-02-18__framework-request-to-commit-visual-guide/investigation.md`
- plan: `work/2026-02-18__framework-request-to-commit-visual-guide/plan.md`
- review: `work/2026-02-18__framework-request-to-commit-visual-guide/review.md`
- docs:
  - `docs/operations/high-priority-backlog.md`
  - `docs/INDEX.md`
