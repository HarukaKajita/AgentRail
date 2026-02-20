# Wave 3: KPI Report Execution Calendar

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/wave3-doc-quality-kpi-thresholds.md`
  - `docs/operations/wave3-doc-quality-metrics-report-automation.md`
  - `docs/operations/wave3-kpi-process-findings-loop.md`
  - `work/2026-02-20__define-kpi-report-execution-calendar/spec.md`
- 理解ポイント:
  - KPI 定義と集計スクリプトは実装済みのため、本資料は実行タイミングと運用責務を固定する。

## 1. 目的

- KPI レポート実行タイミング（週次/リリース前/臨時）を運用カレンダーとして固定する。
- 実行担当、証跡保存、Process Findings 反映の責務を明確化する。

## 2. 実行カレンダー

| 種別 | トリガー | 実行タイミング (JST) | 必須出力 | 完了条件 |
| --- | --- | --- | --- | --- |
| 週次定例 | 週次監視 | 毎週月曜 10:00 | `<report-json-path>`, `<report-markdown-path>` | `summary.overall_status` を `review.md` へ反映 |
| リリース前 | RC 作成前 | リリース予定日の 3 営業日前 17:00 まで | 同上 | `yellow/red` の場合、当日中に follow-up task 起票 |
| 臨時実行 | Guardrail 逸脱/大規模 docs 更新 | イベント発生から 24 時間以内 | 同上 | Process Findings に `action_required` 判定を記録 |

## 3. 役割分担

- Execution Owner:
  - KPI レポート生成コマンドを実行し、出力を保管する。
- Review Owner:
  - `review.md` の Process Findings へ結果を転記し、必要時に `create-task` を実行する。
- Backup Owner:
  - Execution Owner が実行できない場合に代行し、`MEMORY.md` に引き継ぎ記録を残す。

## 4. 実行手順

1. KPI レポート生成

```powershell
pwsh -NoProfile -File tools/doc-quality/generate-kpi-report.ps1 \
  -OutputJsonFile <report-json-path> \
  -OutputMarkdownFile <report-markdown-path>
```

2. Process Findings テンプレート生成

```powershell
pwsh -NoProfile -File tools/doc-quality/generate-finding-template.ps1 \
  -SourceTaskId <task-id> \
  -ReportJsonPath <report-json-path>
```

3. `work/<task-id>/review.md` の `## 6. Process Findings` へ反映
4. `yellow/red` の場合は同日中に `tools/improvement-harvest/create-task.ps1` で follow-up task を起票
5. `docs/operations/high-priority-backlog.md` と `MEMORY.md` を同期

## 5. エスカレーション

- `overall_status=red`:
  - 24 時間以内に follow-up task を起票し、`severity=high` で登録する。
- `overall_status=yellow` が 2 週連続:
  - 次回週次まで待たずに臨時実行を追加し、原因を分解して task 化する。
- `overall_status=green`:
  - 起票は不要。`review.md` に観測結果のみ記録する。

## 6. 証跡管理

- 実行ログ:
  - `work/<task-id>/review.md` の Process Findings
- 進行管理:
  - `docs/operations/high-priority-backlog.md`
  - `MEMORY.md`
- 注意:
  - 固定 `.tmp/*` を参照資料へ書かず、実行時引数 `<report-json-path>` を記録する。

## 7. ロールバック

- 実行タイミングが運用と合わない場合は、次週次レビューで時刻のみ調整する。
- ただし「週次」「リリース前」「臨時」の 3 区分自体は維持する。

## 8. 関連リンク

- docs:
  - `docs/operations/wave3-doc-quality-kpi-thresholds.md`
  - `docs/operations/wave3-doc-quality-metrics-report-automation.md`
  - `docs/operations/wave3-kpi-process-findings-loop.md`
- work:
  - `work/2026-02-20__define-kpi-report-execution-calendar/spec.md`
  - `work/2026-02-20__run-wave3-doc-operations-review/spec.md`
