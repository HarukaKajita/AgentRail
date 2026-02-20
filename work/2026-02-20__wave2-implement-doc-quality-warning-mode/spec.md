# 仕様書: 2026-02-20__wave2-implement-doc-quality-warning-mode

## 記入ルール

- (必須) セクションは必ず記入する。
- N/A を使う場合は理由を明記する。
- 受入条件とテスト要件は 1 対 1 で対応付ける。

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/wave2-doc-quality-check-rules-spec.md`
  - `work/2026-02-20__wave2-implement-doc-quality-warning-mode/request.md`
  - `work/2026-02-20__wave2-implement-doc-quality-warning-mode/investigation.md`
- 理解ポイント:
  - 本タスクは Wave 2-1 として docs 品質チェックを warning 段階へ導入し、fail 段階へ接続する。

## 1. メタ情報 (Metadata) (必須)

- Task ID: 2026-02-20__wave2-implement-doc-quality-warning-mode
- タイトル: Wave 2: docs品質チェック warning 導入
- 作成日: 2026-02-20
- 更新日: 2026-02-20
- 作成者: codex
- 関連要望: `work/2026-02-20__wave2-implement-doc-quality-warning-mode/request.md`

## 2. 背景と目的 (Background & Objectives) (必須)

- 背景: docs 品質ルール（DQ-001〜DQ-004）は設計済みだが、validator への段階導入が未実装だった。
- 目的: `consistency-check` と `state-validate` に warning モードを実装し、ルール違反を観測可能にする。

## 3. スコープ (Scope) (必須)

### 3.1 In Scope (必須)

- `tools/consistency-check/check.ps1` へ `-DocQualityMode off|warning|fail` を追加する。
- `tools/state-validate/validate.ps1` へ `-DocQualityMode off|warning|fail` を追加する。
- warning 集計の出力（`rule_id / severity / file / reason` と `total_rules / warning_count / error_count`）を追加する。
- warning mode の運用手順を docs 化し、backlog/state/MEMORY を同期する。

### 3.2 Out of Scope (必須)

- CI の既定実行を fail モードへ切り替えること。
- warning 21 件の完全解消。

## 4. 受入条件 (Acceptance Criteria) (必須)

- AC-001: `tools/consistency-check/check.ps1` が `DocQualityMode=warning` で docs品質結果を warning として出力し、終了コードを変えない。
- AC-002: `tools/state-validate/validate.ps1` が `DocQualityMode=warning` で docs品質結果を warning として出力し、終了コードを変えない。
- AC-003: `DocQualityMode=fail` を指定した場合に docs品質問題を error として扱える実装が提供される。
- AC-004: `docs/operations/wave2-doc-quality-warning-mode.md`、`docs/operations/high-priority-backlog.md`、`MEMORY.md`、task資料が同期される。

## 5. テスト要件 (Test Requirements) (必須)

### 5.1 単体テスト (Unit Test) (必須)

- **対象**: `tools/consistency-check/check.ps1`, `tools/state-validate/validate.ps1`
- **検証項目**: `DocQualityMode` パラメータと warning summary 出力が機能する。
- **合格基準**:
  - `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__wave2-implement-doc-quality-warning-mode -DocQualityMode warning` が PASS。
  - `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__wave2-implement-doc-quality-warning-mode -DocQualityMode warning` が PASS。

### 5.2 結合テスト (Integration Test) (必須)

- **対象**: `2026-02-20__wave2-spec-doc-quality-check-rules` と本 task の接続。
- **検証項目**: 依存タスクの仕様に沿った warning mode 実装と docs 連携。
- **合格基準**:
  - `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskIds 2026-02-20__wave2-spec-doc-quality-check-rules,2026-02-20__wave2-implement-doc-quality-warning-mode -DocQualityMode warning` が PASS。

### 5.3 回帰テスト (Regression Test) (必須)

- **対象**: 全 task 検証フロー。
- **検証項目**: warning mode 導入後も既存の必須 FAIL 判定が崩れない。
- **合格基準**:
  - `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks -DocQualityMode warning` が PASS。
  - `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks -DocQualityMode warning` が PASS。
  - `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check` が PASS。

### 5.4 手動検証 (Manual Verification) (必須)

- **検証手順**:
  1. warning summary の `total_rules / warning_count / error_count` を確認する。
  2. `DocQualityMode=fail` で単一 task を実行し、インタフェース互換を確認する。
  3. backlog で本 task が done、次 task が plan-ready へ遷移していることを確認する。
- **期待される結果**: AC-001〜AC-004 を満たす。

## 6. 影響範囲 (Impact Assessment) (必須)

- 影響ファイル/モジュール:
  - `tools/consistency-check/check.ps1`
  - `tools/state-validate/validate.ps1`
  - `docs/operations/wave2-doc-quality-warning-mode.md`
  - `docs/operations/high-priority-backlog.md`
  - `work/2026-02-20__wave2-implement-doc-quality-warning-mode/*`
  - `MEMORY.md`
- 影響する仕様:
  - `docs/operations/wave2-doc-quality-check-rules-spec.md`
- 非機能影響:
  - docs 品質問題の可観測性が向上し、fail 昇格前の運用判断が可能になる。

## 7. 制約とリスク (Constraints & Risks) (必須)

- 制約: warning 段階では終了コードへ影響させない。
- 想定リスク:
  - warning が多い状態のまま fail 昇格すると CI が不安定化する。
  - DQ-002（docs/work 双方向参照）の既存不足が一度に顕在化する。
- 回避策:
  - warning 件数を記録し、後続 `wave2-enforce` で fail 適用条件を定義する。

## 8. 未確定事項 (Open Issues) (必須)

- fail モード昇格時の許容 warning 件数と移行閾値（後続 task で確定）。

## 9. 関連資料リンク (Reference Links) (必須)

- request: `work/2026-02-20__wave2-implement-doc-quality-warning-mode/request.md`
- investigation: `work/2026-02-20__wave2-implement-doc-quality-warning-mode/investigation.md`
- plan: `work/2026-02-20__wave2-implement-doc-quality-warning-mode/plan.md`
- review: `work/2026-02-20__wave2-implement-doc-quality-warning-mode/review.md`
- docs:
  - `docs/operations/wave2-doc-quality-check-rules-spec.md`
  - `docs/operations/wave2-doc-quality-warning-mode.md`
  - `docs/operations/high-priority-backlog.md`
