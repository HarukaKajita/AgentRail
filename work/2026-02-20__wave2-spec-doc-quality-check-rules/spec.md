# 仕様書: 2026-02-20__wave2-spec-doc-quality-check-rules

## 記入ルール

- (必須) セクションは必ず記入する。
- N/A を使う場合は理由を明記する。
- 受入条件とテスト要件は 1 対 1 で対応付ける。

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `docs/operations/wave1-doc-work-cross-link-normalization.md`
  - `work/2026-02-20__wave2-spec-doc-quality-check-rules/request.md`
  - `work/2026-02-20__wave2-spec-doc-quality-check-rules/investigation.md`
- 理解ポイント:
  - Wave 2 は docs 品質チェックを warning/fail へ段階導入するため、先に仕様を固定する。

## 1. メタ情報 (Metadata) (必須)

- Task ID: 2026-02-20__wave2-spec-doc-quality-check-rules
- タイトル: Wave 2: docs品質チェックルール設計
- 作成日: 2026-02-20
- 更新日: 2026-02-20
- 作成者: codex
- 関連要望: `work/2026-02-20__wave2-spec-doc-quality-check-rules/request.md`

## 2. 背景と目的 (Background & Objectives) (必須)

- 背景: Wave 1 で docs/work 導線が整ったため、品質チェックを機械判定へ接続する必要がある。
- 目的: consistency-check / state-validate に追加する docs 品質チェック仕様を定義する。

## 3. スコープ (Scope) (必須)

### 3.1 In Scope (必須)

- docs 品質チェック対象ルールの定義（導線・前提知識・関連リンク・更新同期）。
- warning/fail 段階導入方針の定義。
- CI 反映前提の判定基準を定義。

### 3.2 Out of Scope (必須)

- 実装コードの fail 有効化（後続タスク）。
- KPI 可視化（Wave 3）。

## 4. 受入条件 (Acceptance Criteria) (必須)

- AC-001: docs 品質チェック仕様が `docs/operations/wave2-doc-quality-check-rules-spec.md` に定義される。
- AC-002: depends_on/backlog/state/plan が整合し、warning 導入タスクへ引き継げる。

## 5. テスト要件 (Test Requirements) (必須)

### 5.1 単体テスト (Unit Test) (必須)

- **対象**: `work/2026-02-20__wave2-spec-doc-quality-check-rules` の request/investigation/spec/plan/review/state
- **検証項目**: 空欄禁止セクション、依存、成果物定義の整合
- **合格基準**: consistency-check -TaskId 2026-02-20__wave2-spec-doc-quality-check-rules が PASS

### 5.2 結合テスト (Integration Test) (必須)

- **対象**: depends_on で接続される task 間の整合
- **検証項目**: depends_on 記述と backlog 表示が一致
- **合格基準**: 依存 task + 本 task の consistency-check が PASS

### 5.3 回帰テスト (Regression Test) (必須)

- **対象**: 全 task の state / consistency 運用
- **検証項目**: 既存完了タスクの PASS を維持
- **合格基準**: state-validate -AllTasks と consistency-check -AllTasks が PASS

### 5.4 手動検証 (Manual Verification) (必須)

- **検証手順**: 仕様 docs のルール一覧と段階導入順を目視確認
- **期待される結果**: AC-001 と AC-002 を満たす

## 6. 影響範囲 (Impact Assessment) (必須)

- 影響ファイル/モジュール: `docs/operations/wave2-doc-quality-check-rules-spec.md`, `work/2026-02-20__wave2-spec-doc-quality-check-rules/*`, `docs/operations/high-priority-backlog.md`, `docs/INDEX.md`, `MEMORY.md`
- 影響する仕様: human-centric docs migration wave 計画
- 非機能影響: docs 品質判定の再現性向上

## 7. 制約とリスク (Constraints & Risks) (必須)

- 制約: depends_on 未解決時は dependency-blocked を維持する。
- 想定リスク:
  - ルール過剰で運用コストが増える
  - docs 導線更新漏れ
- 回避策: warning -> fail の段階導入でリスクを制御する。

## 8. 未確定事項 (Open Issues) (必須)

- fail モード昇格の具体閾値は warning 運用結果で再調整する。

## 9. 関連資料リンク (Reference Links) (必須)

- request: `work/2026-02-20__wave2-spec-doc-quality-check-rules/request.md`
- investigation: `work/2026-02-20__wave2-spec-doc-quality-check-rules/investigation.md`
- plan: `work/2026-02-20__wave2-spec-doc-quality-check-rules/plan.md`
- review: `work/2026-02-20__wave2-spec-doc-quality-check-rules/review.md`
- `docs/operations/wave2-doc-quality-check-rules-spec.md`
- `docs/operations/wave1-doc-work-cross-link-normalization.md`
- `docs/operations/high-priority-backlog.md`
