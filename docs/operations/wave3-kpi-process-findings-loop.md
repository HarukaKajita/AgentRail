# Wave 3: KPI Process Findings Loop

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/wave3-doc-quality-kpi-thresholds.md`
  - `docs/operations/wave3-doc-quality-metrics-report-automation.md`
  - `docs/operations/wave3-kpi-report-execution-calendar.md`
  - `tools/doc-quality/generate-kpi-report.ps1`
  - `tools/doc-quality/generate-finding-template.ps1`
  - `tools/improvement-harvest/create-task.ps1`
  - `work/2026-02-20__wave3-connect-kpi-to-process-findings-loop/spec.md`
- 理解ポイント:
  - KPI 観測結果を Process Findings と follow-up task 起票へ接続する運用定義。

## 1. 目的

- KPI レポートの悪化を放置せず、`review.md -> create-task -> backlog` へ必ず接続する。
- Wave 3 完了後も docs品質改善ループを継続可能にする。

## 2. 入出力

- 入力:
  - `<report-json-path>`（`generate-kpi-report.ps1 -OutputJsonFile` の出力）
  - source task の `work/<task-id>/review.md`
- 出力:
  - Process Findings 追記テンプレート
  - 必要時の follow-up task 起票コマンド

## 3. 判定テーブル

| overall_status | severity | action_required | 必須アクション |
| --- | --- | --- | --- |
| green | low | no | finding 記録のみ |
| yellow | medium | yes | 改善 task を起票 |
| red | high | yes | 即時に改善 task を起票 |

## 4. 標準フロー

1. KPI レポート生成

```powershell
pwsh -NoProfile -File tools/doc-quality/generate-kpi-report.ps1 \
  -OutputJsonFile <report-json-path> \
  -OutputMarkdownFile <report-markdown-path>
```

2. Finding テンプレート生成

```powershell
pwsh -NoProfile -File tools/doc-quality/generate-finding-template.ps1 \
  -SourceTaskId <task-id> \
  -ReportJsonPath <report-json-path>
```

3. `work/<task-id>/review.md` の `## 6. Process Findings` へ貼り付け
4. `action_required=yes` の場合は `create-task` を実行

```powershell
pwsh -NoProfile -File tools/improvement-harvest/create-task.ps1 \
  -SourceTaskId <task-id> \
  -FindingId <finding-id> \
  -Title "<improvement title>" \
  -Severity <must|high|medium|low> \
  -Category quality \
  -TaskId <new-task-id>
```

5. `docs/operations/high-priority-backlog.md` と `MEMORY.md` を同一変更で同期
6. task の `investigation.md` / `review.md` では固定 `.tmp/*` を参照資料に書かず、実行引数として `<report-json-path>` を記録する

## 5. review.md 記載テンプレート

```markdown
### 6.x Finding F-KPI-001
- finding_id: F-KPI-001
- category: quality
- severity: medium
- summary: Doc quality KPI report status is yellow.
- evidence: report=<report-json-path>; generated_at=2026-02-20T18:55:24+09:00; kpis=...
- action_required: yes
- linked_task_id: 2026-02-20__<new-task-id>
```

## 6. 失敗時の扱い

- `generate-kpi-report` が失敗した場合:
  - `consistency-check -AllTasks -DocQualityMode warning` の失敗要因を先に解消する。
- `create-task` が失敗した場合:
  - `finding_id/category/severity/action_required/linked_task_id` の必須値を見直す。

## 7. ロールバック

- 自動テンプレート出力が不適切な場合は、手動で Process Findings を記載して起票する。
- ただし `yellow/red` の `action_required=yes` は維持する。

## 8. 関連リンク

- docs:
  - `docs/operations/wave3-doc-quality-kpi-thresholds.md`
  - `docs/operations/wave3-doc-quality-metrics-report-automation.md`
  - `docs/operations/wave3-kpi-report-execution-calendar.md`
- work:
  - `work/2026-02-20__wave3-connect-kpi-to-process-findings-loop/spec.md`
  - `work/2026-02-20__wave3-automate-doc-quality-metrics-report/spec.md`
