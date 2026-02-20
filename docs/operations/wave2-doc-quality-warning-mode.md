# Wave 2: Doc Quality Warning Mode

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/wave2-doc-quality-check-rules-spec.md`
  - `work/2026-02-20__wave2-implement-doc-quality-warning-mode/spec.md`
  - `tools/consistency-check/check.ps1`
  - `tools/state-validate/validate.ps1`
- 理解ポイント:
  - 本資料は docs品質ルールを warning 段階で運用するための実装と実行手順を定義する。

## 1. 目的

- DQ-001〜DQ-004 を validator へ実装し、warning として観測できるようにする。
- fail 昇格前に問題件数を把握し、段階移行リスクを可視化する。

## 2. 実装内容

1. `tools/consistency-check/check.ps1`
   - `-DocQualityMode off|warning|fail` を追加。
   - docs品質 issue を `rule_id / severity / file / reason` 形式で出力。
   - summary (`total_rules / warning_count / error_count`) を text/json の両方へ追加。
2. `tools/state-validate/validate.ps1`
   - `-DocQualityMode off|warning|fail` を追加。
   - `-AllTasks` 実行時に docs品質 warning 集計を出力。
   - fail モード時は docs品質 issue を failure として扱えるようにした。

## 3. モード定義

- `off`
  - docs品質判定をスキップする。
- `warning`（Wave 2-1 既定）
  - docs品質 issue を warning として表示する。
  - 終了コードへ影響させない。
- `fail`（Wave 2-2 で昇格予定）
  - docs品質 issue を error 扱いにし、終了コードへ反映する。

## 4. 実行コマンド

- 単一 task（warning）:
  - `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__wave2-implement-doc-quality-warning-mode -DocQualityMode warning`
  - `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__wave2-implement-doc-quality-warning-mode -DocQualityMode warning`
- 全 task（warning 集計）:
  - `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks -DocQualityMode warning`
  - `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks -DocQualityMode warning`
- fail mode スモーク:
  - `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__wave2-spec-doc-quality-check-rules -DocQualityMode fail`
  - `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__wave2-spec-doc-quality-check-rules -DocQualityMode fail`

## 5. 観測結果（導入時点）

- warning mode (`-AllTasks`) 実行時の集計:
  - `total_rules=4`
  - `warning_count=21`
  - `error_count=0`
- 主な warning:
  - DQ-002: docs 側に `docs/*` / `work/*` の双方向導線が不足する既存文書。

## 6. 後続タスクへの引き継ぎ

- `work/2026-02-20__wave2-enforce-doc-quality-fail-mode/spec.md`
  - warning 21 件の扱い（解消 or 許容）を明文化し、fail 昇格基準を定義する。
- `work/2026-02-20__wave2-align-ci-runbook-with-doc-quality-gates/spec.md`
  - CI runbook に `DocQualityMode` の運用切替手順を反映する。

## 7. ロールバック

- 影響が大きい場合は `DocQualityMode off` で一時運用し、warning 設計を再調整する。
- fail 昇格後の障害時は `warning` に戻して段階導入へ復帰する。
