# DQ-002 Warning Remediation Priority Plan

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/wave2-doc-quality-warning-mode.md`
  - `docs/operations/wave3-doc-quality-kpi-thresholds.md`
  - `work/2026-02-20__prioritize-dq002-warning-remediation/spec.md`
- 理解ポイント:
  - 本資料は DQ-002 warning 21件の「実装修正順」を決めるための運用計画であり、修正実装そのものは後続タスクで行う。

## 1. 目的

- DQ-002 warning 21件を影響度順で解消する実行順を定義する。
- 修正の分割単位と完了判定を先に固定し、実装タスクを連続起票しやすくする。

## 2. 観測サマリ（2026-02-20 時点）

- 集計コマンド:
  - `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks -DocQualityMode warning -OutputFormat json`
- 観測値:
  - `dq002_count=21`
- ファイル集中度:
  - `docs/specs/automation-tools-design-spec.md`: 12件
  - `docs/operations/profile-validator-schema-version-policy.md`: 3件
  - 上記以外6ファイル: 各1件

## 3. 優先度基準

| Priority | 判定基準 | 対応方針 |
| --- | --- | --- |
| P1 | 複数 task に波及する共通 docs（影響 task >= 3） | 最優先で導線補完 |
| P2 | 運用ポリシー docs（影響 task 2-3） | P1 完了後に連続対応 |
| P3 | 個別 docs（影響 task 1） | P2 完了後にバッチ対応 |

## 4. 分割実装順

1. Wave A (P1):
   - `docs/specs/automation-tools-design-spec.md`（12件）
2. Wave B (P2):
   - `docs/operations/profile-validator-schema-version-policy.md`（3件）
3. Wave C (P3):
   - `docs/investigations/self-improvement-loop-investigation.md`
   - `docs/operations/profile-validator-required-checks-source-of-truth.md`
   - `docs/operations/runtime-distribution-export-guide.md`
   - `docs/operations/runtime-installation-runbook.md`
   - `docs/operations/state-history-strategy.md`
   - `docs/operations/state-validator-done-docs-index-consistency.md`

## 5. 起票ルール

1. Wave 単位で task を分割起票する。
2. 各 task の受入条件に `dq002_count` の減少量を明記する。
3. 実装後は下記の順で検証する。
   - `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId <task-id> -DocQualityMode warning`
   - `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId <task-id> -DocQualityMode warning`
   - `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks -DocQualityMode warning -OutputFormat json`

## 6. 完了判定

- Wave A/B/C を順次完了し、`DQ-002` warning が 0 件になる。
- `docs/operations/high-priority-backlog.md` と `MEMORY.md` で進捗を同期する。

## 7. 関連リンク

- docs:
  - `docs/operations/high-priority-backlog.md`
  - `docs/operations/wave2-doc-quality-warning-mode.md`
- work:
  - `work/2026-02-20__prioritize-dq002-warning-remediation/spec.md`
  - `work/2026-02-20__prioritize-dq002-warning-remediation/review.md`
  - `work/2026-02-20__dq002-wave-a-fix-automation-tools-design-spec-links/spec.md`
  - `work/2026-02-20__dq002-wave-b-fix-profile-validator-schema-policy-links/spec.md`
  - `work/2026-02-20__dq002-wave-c-fix-remaining-doc-links/spec.md`

## 8. 実施結果（2026-02-20）

- Wave A: 完了（`dq002_count` 21 -> 9）
- Wave B: 完了（`dq002_count` 9 -> 6）
- Wave C: 完了（`dq002_count` 6 -> 0）
- 最終結果:
  - `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks -DocQualityMode warning -OutputFormat json`
  - `doc_quality.warning_count=0`
