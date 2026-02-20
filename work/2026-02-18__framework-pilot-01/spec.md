# 仕様書: 2026-02-18__framework-pilot-01

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 1. メタ情報 (Metadata) (必須)

- Task ID: `2026-02-18__framework-pilot-01`
- タイトル: 手動運用開始パイロット
- 作成日: 2026-02-18
- 更新日: 2026-02-18
- 作成者: Codex
- 関連要望: `work/2026-02-18__framework-pilot-01/request.md`

## 2. 背景と目的 (Background & Objectives) (必須)

- 背景: 手動運用骨格は導入済みだが、実タスク未実施のため運用妥当性が未検証。
- 目的: profile 未設定を解消し、実タスク 1 件を完了させて運用成立を証明する。

## 3. スコープ (Scope) (必須)

### 3.1 In Scope (必須)

- `project.profile.yaml` の必須項目実値化
- `work/2026-02-18__framework-pilot-01/` の成果物 6 ファイル作成
- docs への昇格資料作成
- `docs/INDEX.md` 更新
- 自動化基盤仕様の文書化（実装なし）

### 3.2 Out of Scope (必須)

- `docs-indexer` 実装
- `consistency-check` 実装
- CI パイプライン構築

## 4. 受入条件 (Acceptance Criteria) (必須)

- AC-001: `project.profile.yaml` に `TODO_SET_ME` が残っていない。
- AC-002: `work/2026-02-18__framework-pilot-01/` に必須 6 ファイルが存在し、空欄禁止項目が記入済み。
- AC-003: `docs/specs/framework-pilot-01-spec.md` と `docs/investigations/framework-pilot-01-investigation.md` が作成されている。
- AC-004: `docs/specs/automation-tools-design-spec.md` が作成され、I/O と失敗条件と受入基準が記載されている。
- AC-005: `docs/INDEX.md` が新規資料を参照している。

## 5. テスト要件 (Test Requirements) (必須)

### 5.1 単体テスト (Unit Test) (必須)

- **対象**: 必須ファイル存在チェック
- **検証項目**: 新規追加・更新対象ファイルの漏れ
- **合格基準**: 仕様対象ファイルがすべて存在する

### 5.2 結合テスト (Integration Test) (必須)

- **対象**: `work/`, `docs/`, `MEMORY.md` の相互参照
- **検証項目**: request/investigation/spec/plan/review のリンク整合
- **合格基準**: 参照パスが実在し、破綻していない

### 5.3 回帰テスト (Regression Test) (必須)

- **対象**: 既存の手動運用関連ファイル
- **検証項目**: 既存ルールの欠損が発生していないか
- **合格基準**: `AGENTS.md`, `CLAUDE.md`, `docs/templates/*` の必須方針が維持されている

### 5.4 手動検証 (Manual Verification) (必須)

- **検証手順**:
  1. `project.profile.yaml` を確認して必須キー値があることを確認
  2. `work/2026-02-18__framework-pilot-01/` の 6 ファイルを確認
  3. `docs/INDEX.md` に新規資料導線が追加されていることを確認
  4. `docs/specs/automation-tools-design-spec.md` の必須項目を確認
- **期待される結果**: AC-001〜AC-005 がすべて満たされる

## 6. 影響範囲 (Impact Assessment) (必須)

- 影響ファイル/モジュール:
  - `project.profile.yaml`
  - `MEMORY.md`
  - `docs/INDEX.md`
  - `work/2026-02-18__framework-pilot-01/*`
  - `docs/specs/*`
  - `docs/investigations/*`
- 影響する仕様:
  - AgentRail 手動運用ルール
- 非機能影響:
  - ドキュメント量が増えるが、追跡可能性が向上する

## 7. 制約とリスク (Constraints & Risks) (必須)

- 制約: 自動化実装は行わず、仕様定義までに限定する
- 想定リスク: profile コマンドが将来の実行環境に合わない可能性
- 回避策: 自動化基盤実装前に profile 再評価タスクを必須化する

## 8. 未確定事項 (Open Issues) (必須)

- 自動化基盤の実装言語（PowerShell/Python/Node）の最終決定
- CI 実行基盤（GitHub Actions など）の採用可否

## 9. 関連資料リンク (Reference Links) (必須)

- request: `work/2026-02-18__framework-pilot-01/request.md`
- investigation: `work/2026-02-18__framework-pilot-01/investigation.md`
- plan: `work/2026-02-18__framework-pilot-01/plan.md`
- review: `work/2026-02-18__framework-pilot-01/review.md`
- docs:
  - `docs/specs/framework-pilot-01-spec.md`
  - `docs/investigations/framework-pilot-01-investigation.md`
  - `docs/specs/automation-tools-design-spec.md`
