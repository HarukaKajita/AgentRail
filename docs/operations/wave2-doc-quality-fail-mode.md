# Wave 2: Doc Quality Fail Mode

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/wave2-doc-quality-warning-mode.md`
  - `work/2026-02-20__wave2-enforce-doc-quality-fail-mode/spec.md`
  - `.github/workflows/ci-framework.yml`
- 理解ポイント:
  - 本資料は warning 導入済みの docs品質チェックを fail 判定へ昇格する運用を定義する。

## 1. 目的

- docs品質 issue を PR 時点で fail として検知する。
- 既存 warning 運用を壊さない段階適用で fail 強制を開始する。

## 2. 適用方針

1. 全体検証（`-AllTasks`）:
   - `DocQualityMode=warning` を維持する。
   - 理由: 導入時点で warning が 21 件残るため。
2. 変更対象 task 検証:
   - `DocQualityMode=fail` を適用する。
   - 対象: CI の `resolved_task_id` で検証する task。

## 3. CI 実装

- `.github/workflows/ci-framework.yml` の実行順序:
  1. `tools/state-validate/validate.ps1 -AllTasks -DocQualityMode warning`
  2. `tools/ci/resolve-task-id.ps1`
  3. `tools/state-validate/validate.ps1 -TaskId $taskId -DocQualityMode fail`
  4. `tools/consistency-check/check.ps1 -TaskId $taskId -DocQualityMode fail`

## 4. 判定ルール

- fail mode では DQ issue が error 扱いになる。
- 最低出力項目:
  - `rule_id`
  - `severity=error`
  - `file`
  - `reason`
- 集計項目:
  - `total_rules`
  - `warning_count`
  - `error_count`

## 5. 導入時点の残課題

- warning mode 全体実行で `warning_count=21`。
- 主因: DQ-002（docs/work 双方向導線不足）の既存資料。
- 解消先:
  - `work/2026-02-20__wave2-align-ci-runbook-with-doc-quality-gates/spec.md`
  - `work/2026-02-20__wave3-define-doc-quality-kpi-thresholds/spec.md`

## 6. 実行コマンド

- fail mode（対象 task）:
  - `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId <task-id> -DocQualityMode fail`
  - `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId <task-id> -DocQualityMode fail`
- warning mode（全体）:
  - `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks -DocQualityMode warning`
  - `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks -DocQualityMode warning`

## 7. ロールバック

- fail mode 適用で業務影響が大きい場合:
  1. CI の対象 task step を `DocQualityMode warning` に戻す。
  2. warning 一覧を優先度付きで再計画する。
  3. runbook に暫定運用を明記して再昇格条件を定義する。
