# Plan: 2026-02-19__profile-validator-required-checks-source-of-truth

## 1. 対象仕様

- `work/2026-02-19__profile-validator-required-checks-source-of-truth/spec.md`

## 2. Execution Commands

- unit(pass): `pwsh -NoProfile -File tools/profile-validate/validate.ps1 -ProfilePath project.profile.yaml`
- unit(fail): `pwsh -NoProfile -Command '$tmp = Join-Path $env:TEMP ("profile-missing-review-" + [Guid]::NewGuid().ToString("N") + ".yaml"); $content = Get-Content -Raw project.profile.yaml; $updated = [Regex]::Replace($content, "(?ms)^review:\s*.*?^defaults:", "defaults:"); Set-Content -LiteralPath $tmp -Value $updated; & pwsh -NoProfile -File tools/profile-validate/validate.ps1 -ProfilePath $tmp; $exit = $LASTEXITCODE; Remove-Item -LiteralPath $tmp -Force; exit $exit'`
- consistency: `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-19__profile-validator-required-checks-source-of-truth`
- index update: `pwsh -NoProfile -File tools/docs-indexer/index.ps1`
- index check: `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`

## 3. 実施ステップ

1. `tools/profile-validate/validate.ps1` の `requiredChecks` 静的配列を source finding と照合し、置換範囲を確定する。
2. `tools/profile-validate/profile-schema.json` を新規追加し、required key path と value_type を定義する。
3. `tools/profile-validate/validate.ps1` を schema 読み込み + regex 生成方式に更新する。
4. `docs/operations` 配下へ運用手順を追記し、backlog の VE-001 状態を更新する。
5. `docs-indexer` を apply/check で実行し、`docs/INDEX.md` を同期する。
6. unit(pass/fail)・consistency-check を実行し、`review.md` と `state.json` を更新する。

## 4. 変更対象ファイル

- `tools/profile-validate/validate.ps1`
- `tools/profile-validate/profile-schema.json`（新規）
- `docs/operations/profile-validator-required-checks-source-of-truth.md`（新規）
- `docs/operations/validator-enhancement-backlog.md`
- `docs/operations/high-priority-backlog.md`
- `docs/INDEX.md`
- `work/2026-02-19__profile-validator-required-checks-source-of-truth/investigation.md`
- `work/2026-02-19__profile-validator-required-checks-source-of-truth/spec.md`
- `work/2026-02-19__profile-validator-required-checks-source-of-truth/plan.md`
- `work/2026-02-19__profile-validator-required-checks-source-of-truth/review.md`
- `work/2026-02-19__profile-validator-required-checks-source-of-truth/state.json`
- `MEMORY.md`

## 5. リスクとロールバック

- リスク: schema から生成した regex が nested key を誤判定する。
- ロールバック:
  1. `tools/profile-validate/validate.ps1` と `tools/profile-validate/profile-schema.json` を変更前に戻す。
  2. required path ごとに failing case を追加して再設計する。

## 6. 完了判定

- AC-001〜AC-004 がすべて PASS。
- `review.md` に unit/integration/regression/manual の実測結果が記録されている。
- `state.json` が `done` かつ `updated_at` が更新されている。
