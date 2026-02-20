# 仕様書: 2026-02-20__wave3-automate-doc-quality-metrics-report

## 記入ルール

- (必須) セクションは必ず記入する。
- N/A を使う場合は理由を明記する。
- 受入条件とテスト要件は 1 対 1 で対応付ける。

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/wave3-doc-quality-kpi-thresholds.md`
  - `work/2026-02-20__wave3-automate-doc-quality-metrics-report/request.md`
  - `work/2026-02-20__wave3-automate-doc-quality-metrics-report/investigation.md`
- 理解ポイント:
  - task11 は KPI 定義を実行可能なレポート生成処理へ落とし込む。

## 1. メタ情報 (Metadata) (必須)

- Task ID: 2026-02-20__wave3-automate-doc-quality-metrics-report
- タイトル: Wave 3: docs品質メトリクス自動集計
- 作成日: 2026-02-20
- 更新日: 2026-02-20
- 作成者: codex
- 関連要望: `work/2026-02-20__wave3-automate-doc-quality-metrics-report/request.md`

## 2. 背景と目的 (Background & Objectives) (必須)

- 背景: task10 で KPI 閾値定義は完了したが、算出が手動運用のまま。
- 目的: KPI を JSON/Markdown で自動出力し、継続観測を可能にする。

## 3. スコープ (Scope) (必須)

### 3.1 In Scope (必須)

- `tools/doc-quality/generate-kpi-report.ps1` を追加する。
- KPI レポート運用ドキュメントを追加する。
- backlog/state/MEMORY を task12 着手状態へ同期する。

### 3.2 Out of Scope (必須)

- KPI 悪化時の起票フロー実装（task12）。
- CI ワークフローへの自動実行組み込み。

## 4. 受入条件 (Acceptance Criteria) (必須)

- AC-001: `tools/doc-quality/generate-kpi-report.ps1` が `KPI-FRESH-01 / KPI-LINK-01 / KPI-COVER-01` と Guardrail を算出し、JSON/Markdown を出力できる。
- AC-002: `docs/operations/wave3-doc-quality-metrics-report-automation.md` に実行手順・出力仕様・運用手順が記載される。
- AC-003: task11 の review/state/backlog/MEMORY が次タスク `2026-02-20__wave3-connect-kpi-to-process-findings-loop` 着手状態へ同期される。

## 5. テスト要件 (Test Requirements) (必須)

### 5.1 単体テスト (Unit Test) (必須)

- **対象**:
  - `tools/doc-quality/generate-kpi-report.ps1`
  - `docs/operations/wave3-doc-quality-metrics-report-automation.md`
- **検証項目**:
  - スクリプトが JSON/Markdown を生成し、主要キーが存在する。
- **合格基準**:
  - `pwsh -NoProfile -File tools/doc-quality/generate-kpi-report.ps1 -OutputJsonFile .tmp/wave3-metrics-report.json -OutputMarkdownFile .tmp/wave3-metrics-report.md`
  - `pwsh -NoProfile -Command "$json = Get-Content -Raw '.tmp/wave3-metrics-report.json' | ConvertFrom-Json; $json.summary.overall_status; $json.source.warning_count; $json.source.rule_counts.'DQ-002'"`

### 5.2 結合テスト (Integration Test) (必須)

- **対象**: task10 KPI定義と task11 自動集計の連携。
- **検証項目**: task10 baseline と同じ指標値を再現できる。
- **合格基準**:
  - `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskIds 2026-02-20__wave3-define-doc-quality-kpi-thresholds,2026-02-20__wave3-automate-doc-quality-metrics-report -DocQualityMode warning`
  - `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__wave3-automate-doc-quality-metrics-report -DocQualityMode warning`

### 5.3 回帰テスト (Regression Test) (必須)

- **対象**: 全 task の validator 運用。
- **検証項目**: 既存 PASS を維持する。
- **合格基準**:
  - `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks -DocQualityMode warning`
  - `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks -DocQualityMode warning`
  - `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`

### 5.4 手動検証 (Manual Verification) (必須)

- **検証手順**:
  1. backlog で task11 が Completed、task12 が plan-ready になっていることを確認。
  2. MEMORY の現在タスクが task12 へ更新されていることを確認。
  3. docs/INDEX に task11 追加 docs の導線があることを確認。
- **期待される結果**: AC-001〜AC-003 を満たす。

## 6. 影響範囲 (Impact Assessment) (必須)

- 影響ファイル/モジュール:
  - `tools/doc-quality/generate-kpi-report.ps1`
  - `docs/operations/wave3-doc-quality-metrics-report-automation.md`
  - `docs/INDEX.md`
  - `docs/operations/high-priority-backlog.md`
  - `MEMORY.md`
  - `work/2026-02-20__wave3-automate-doc-quality-metrics-report/*`
- 影響する仕様:
  - `docs/operations/wave3-doc-quality-kpi-thresholds.md`
- 非機能影響:
  - KPI 観測の再現性が向上する。

## 7. 制約とリスク (Constraints & Risks) (必須)

- 制約: KPI 算出は既存 validator 出力を利用し、追加依存を導入しない。
- 想定リスク:
  - 集計スクリプトの出力 schema が将来互換を欠く。
  - stale 判定の閾値が運用実態とズレる。
- 回避策:
  - `schema_version` を JSON に含める。
  - 閾値変更時は task10 docs を正本として同期更新する。

## 8. 未確定事項 (Open Issues) (必須)

- task12 での KPI 悪化時アクションの自動起票条件。

## 9. 関連資料リンク (Reference Links) (必須)

- request: `work/2026-02-20__wave3-automate-doc-quality-metrics-report/request.md`
- investigation: `work/2026-02-20__wave3-automate-doc-quality-metrics-report/investigation.md`
- plan: `work/2026-02-20__wave3-automate-doc-quality-metrics-report/plan.md`
- review: `work/2026-02-20__wave3-automate-doc-quality-metrics-report/review.md`
- docs:
  - `docs/operations/wave3-doc-quality-kpi-thresholds.md`
  - `docs/operations/wave3-doc-quality-metrics-report-automation.md`
