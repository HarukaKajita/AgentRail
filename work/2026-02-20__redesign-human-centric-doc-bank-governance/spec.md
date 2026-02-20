# 仕様書: 2026-02-20__redesign-human-centric-doc-bank-governance

## 記入ルール

- `(必須)` セクションは必ず記入する。
- N/A を使う場合は理由を明記する。
- 受入条件とテスト要件は 1 対 1 で対応付ける。

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `README.md`
  - `docs/INDEX.md`
  - `work/2026-02-20__redesign-human-centric-doc-bank-governance/request.md`
  - `work/2026-02-20__redesign-human-centric-doc-bank-governance/investigation.md`
- 理解ポイント:
  - 目的はワークフロー再現性を維持しつつ、人間理解を最優先で追従可能にする運用へ拡張すること。

## 1. メタ情報 (Metadata) (必須)

- Task ID: 2026-02-20__redesign-human-centric-doc-bank-governance
- タイトル: 人間理解中心の資料バンク方針へ再設計する計画起票
- 作成日: 2026-02-20
- 更新日: 2026-02-20
- 作成者: codex
- 関連要望: `work/2026-02-20__redesign-human-centric-doc-bank-governance/request.md`

## 2. 背景と目的 (Background & Objectives) (必須)

- 背景: Agent の開発速度に対して、人間側がプロジェクト状態を追跡するための明示的な情報設計が不足している。
- 目的: 「人間が理解しやすく網羅的な資料バンク」をフレームワーク目的として定義し、運用原則・品質ゲート・段階移行方針を確定する。

## 3. スコープ (Scope) (必須)

### 3.1 In Scope (必須)

- フレームワーク目的文の拡張方針（再現性 + 人間理解）を定義する。
- 資料バンクの情報モデル（目的/使い方/仕組み/実装ファイル/関連機能/関連資料）を定義する。
- 変更時に資料が常時更新されるための運用責務と品質ゲートを定義する。
- 移行計画タスクの分割方針と依存関係を確定する。

### 3.2 Out of Scope (必須)

- 既存 docs 全件の即時改訂。
- 新情報モデルへの一括自動変換実装。

## 4. 受入条件 (Acceptance Criteria) (必須)

- AC-001: 方針再設計の計画（目的、情報モデル、更新責務、品質ゲート、段階分割）が task 資料と `docs/operations/human-centric-doc-bank-governance.md` に明文化される。
- AC-002: 移行計画タスク `2026-02-20__plan-migration-to-human-centric-doc-bank` が起票され、依存関係が backlog/state/plan で整合する。

## 5. テスト要件 (Test Requirements) (必須)

### 5.1 単体テスト (Unit Test) (必須)

- **対象**: task 成果物 6 ファイルの記述整合
- **検証項目**: 空欄禁止セクション、依存表記、関連リンクが欠落しない
- **合格基準**: `consistency-check` で対象 task が PASS

### 5.2 結合テスト (Integration Test) (必須)

- **対象**: 方針再設計タスクと移行計画タスクの依存関係
- **検証項目**: Task B が Task A を depends_on として保持し、backlog 表示と一致する
- **合格基準**: 2 task 同時指定の `consistency-check` が PASS

### 5.3 回帰テスト (Regression Test) (必須)

- **対象**: 既存 framework 運用ルール
- **検証項目**: 既存 task 検証と docs index 運用を壊さない
- **合格基準**: `state-validate -AllTasks` と `consistency-check -AllTasks` が PASS

### 5.4 手動検証 (Manual Verification) (必須)

- **検証手順**: backlog と MEMORY の記載を確認し、段階的進行順序（再設計 -> 移行）が明示されていることを確認する
- **期待される結果**: AC-001 と AC-002 を満たす

## 6. 影響範囲 (Impact Assessment) (必須)

- 影響ファイル/モジュール: `work/2026-02-20__redesign-human-centric-doc-bank-governance/*`, `work/2026-02-20__plan-migration-to-human-centric-doc-bank/*`, `docs/operations/human-centric-doc-bank-governance.md`, `docs/operations/high-priority-backlog.md`, `MEMORY.md`
- 影響する仕様: フレームワーク目的定義、資料バンク運用方針、タスク分割方針
- 非機能影響: 人間による理解速度、引き継ぎ容易性、変更追跡性が向上する

## 7. 制約とリスク (Constraints & Risks) (必須)

- 制約: 単一リポジトリ運用と既存 SSOT ルールを維持したまま段階移行する
- 想定リスク:
  - 設計のみ先行して運用へ定着しない
  - 資料品質ゲートが過剰になり開発速度を阻害する
- 回避策: タスク分割で段階検証し、PoC フェーズを設けて負荷を計測する

## 8. 未確定事項 (Open Issues) (必須)

- 品質指標の厳密なしきい値（例: 更新遅延日数、網羅率基準）は移行計画タスクで決定する

## 9. 関連資料リンク (Reference Links) (必須)

- request: `work/2026-02-20__redesign-human-centric-doc-bank-governance/request.md`
- investigation: `work/2026-02-20__redesign-human-centric-doc-bank-governance/investigation.md`
- plan: `work/2026-02-20__redesign-human-centric-doc-bank-governance/plan.md`
- review: `work/2026-02-20__redesign-human-centric-doc-bank-governance/review.md`
- docs:
  - `docs/operations/human-centric-doc-bank-governance.md`
  - `docs/operations/high-priority-backlog.md`
