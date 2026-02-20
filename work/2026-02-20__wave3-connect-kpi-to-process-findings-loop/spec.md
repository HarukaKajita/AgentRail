# 仕様書: 2026-02-20__wave3-connect-kpi-to-process-findings-loop

## 記入ルール

- (必須) セクションは必ず記入する。
- N/A を使う場合は理由を明記する。
- 受入条件とテスト要件は 1 対 1 で対応付ける。

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/wave3-doc-quality-kpi-thresholds.md`
  - `docs/operations/wave3-doc-quality-metrics-report-automation.md`
  - `work/2026-02-20__wave3-connect-kpi-to-process-findings-loop/request.md`
  - `work/2026-02-20__wave3-connect-kpi-to-process-findings-loop/investigation.md`
- 理解ポイント:
  - task12 は KPI 観測と改善起票を実運用として閉じる Wave 3 最終工程。

## 1. メタ情報 (Metadata) (必須)

- Task ID: 2026-02-20__wave3-connect-kpi-to-process-findings-loop
- タイトル: Wave 3: KPI と Process Findings 連携
- 作成日: 2026-02-20
- 更新日: 2026-02-20
- 作成者: codex
- 関連要望: `work/2026-02-20__wave3-connect-kpi-to-process-findings-loop/request.md`

## 2. 背景と目的 (Background & Objectives) (必須)

- 背景: task11 で KPI 自動集計は実装済みだが、悪化時の改善接続ルールが未固定。
- 目的: KPI status を Process Findings と follow-up task 起票へ接続する運用を確立する。

## 3. スコープ (Scope) (必須)

### 3.1 In Scope (必須)

- `docs/operations/wave3-kpi-process-findings-loop.md` の追加。
- `tools/doc-quality/generate-finding-template.ps1` の追加。
- backlog/state/MEMORY の Wave 3 完了同期。

### 3.2 Out of Scope (必須)

- CI 上での自動起票実行。
- DQ-002 既存 warning 21 件の一括修正。

## 4. 受入条件 (Acceptance Criteria) (必須)

- AC-001: `docs/operations/wave3-kpi-process-findings-loop.md` に status別 decision table、標準フロー、review 記載テンプレート、create-task コマンドが明記される。
- AC-002: `tools/doc-quality/generate-finding-template.ps1` が KPI report JSON から finding テンプレートを text/json で生成できる。
- AC-003: backlog/state/MEMORY が Wave 3 完了状態へ同期され、優先タスク一覧に未完了が残らない。

## 5. テスト要件 (Test Requirements) (必須)

### 5.1 単体テスト (Unit Test) (必須)

- **対象**:
  - `tools/doc-quality/generate-finding-template.ps1`
  - `docs/operations/wave3-kpi-process-findings-loop.md`
- **検証項目**:
  - text/json で required keys を生成できる。
- **合格基準**:
  - `pwsh -NoProfile -File tools/doc-quality/generate-finding-template.ps1 -SourceTaskId 2026-02-20__wave3-connect-kpi-to-process-findings-loop -ReportJsonPath .tmp/wave3-metrics-report.json`
  - `pwsh -NoProfile -File tools/doc-quality/generate-finding-template.ps1 -SourceTaskId 2026-02-20__wave3-connect-kpi-to-process-findings-loop -ReportJsonPath .tmp/wave3-metrics-report.json -OutputFormat json`

### 5.2 結合テスト (Integration Test) (必須)

- **対象**: task11 report と task12 loop 接続。
- **検証項目**: report 生成と finding 生成の連携。
- **合格基準**:
  - `pwsh -NoProfile -File tools/doc-quality/generate-kpi-report.ps1 -OutputJsonFile .tmp/wave3-metrics-report.json -OutputMarkdownFile .tmp/wave3-metrics-report.md`
  - `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskIds 2026-02-20__wave3-automate-doc-quality-metrics-report,2026-02-20__wave3-connect-kpi-to-process-findings-loop -DocQualityMode warning`
  - `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__wave3-connect-kpi-to-process-findings-loop -DocQualityMode warning`

### 5.3 回帰テスト (Regression Test) (必須)

- **対象**: 全 task の validator 運用。
- **検証項目**: Wave 3 完了後も PASS を維持する。
- **合格基準**:
  - `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks -DocQualityMode warning`
  - `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks -DocQualityMode warning`
  - `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`

### 5.4 手動検証 (Manual Verification) (必須)

- **検証手順**:
  1. backlog の `優先タスク一覧` が空で、task12 が Completed に移動していることを確認。
  2. MEMORY が Wave 3 完了後の次アクションへ更新されていることを確認。
  3. docs/INDEX に loop doc 導線が追加されていることを確認。
- **期待される結果**: AC-001〜AC-003 を満たす。

## 6. 影響範囲 (Impact Assessment) (必須)

- 影響ファイル/モジュール:
  - `tools/doc-quality/generate-finding-template.ps1`
  - `docs/operations/wave3-kpi-process-findings-loop.md`
  - `docs/operations/high-priority-backlog.md`
  - `docs/INDEX.md`
  - `MEMORY.md`
  - `work/2026-02-20__wave3-connect-kpi-to-process-findings-loop/*`
- 影響する仕様:
  - `docs/operations/wave3-doc-quality-kpi-thresholds.md`
  - `docs/operations/wave3-doc-quality-metrics-report-automation.md`
- 非機能影響:
  - KPI 悪化時の対応遅延を防止し、改善ループの再現性が向上する。

## 7. 制約とリスク (Constraints & Risks) (必須)

- 制約: 新規処理は補助スクリプトに留め、自動起票は人間レビューを挟む。
- 想定リスク:
  - report path 取り違えで誤った finding が生成される。
  - linked_task_id 設定漏れで scan に失敗する。
- 回避策:
  - runbook に標準コマンドと記載テンプレートを明記する。

## 8. 未確定事項 (Open Issues) (必須)

- 次 wave（または次施策）の優先タスク選定。

## 9. 関連資料リンク (Reference Links) (必須)

- request: `work/2026-02-20__wave3-connect-kpi-to-process-findings-loop/request.md`
- investigation: `work/2026-02-20__wave3-connect-kpi-to-process-findings-loop/investigation.md`
- plan: `work/2026-02-20__wave3-connect-kpi-to-process-findings-loop/plan.md`
- review: `work/2026-02-20__wave3-connect-kpi-to-process-findings-loop/review.md`
- docs:
  - `docs/operations/wave3-kpi-process-findings-loop.md`
  - `docs/operations/wave3-doc-quality-kpi-thresholds.md`
  - `docs/operations/wave3-doc-quality-metrics-report-automation.md`
