# Plan: 2026-02-19__profile-validator-schema-version-field

## 1. 対象仕様

- `work/2026-02-19__profile-validator-schema-version-field/spec.md`

## 2. Execution Commands

- profile validate(pass): `pwsh -NoProfile -File tools/profile-validate/validate.ps1 -ProfilePath project.profile.yaml`
- profile validate(fail): `pwsh -NoProfile -Command '$tmp = Join-Path $env:TEMP ("profile-unsupported-schema-version-" + [Guid]::NewGuid().ToString("N") + ".yaml"); $content = Get-Content -Raw project.profile.yaml; $updated = [Regex]::Replace($content, "(?m)^schema_version:\s*.*$", "schema_version: ""9.9.9"""); Set-Content -LiteralPath $tmp -Value $updated; & pwsh -NoProfile -File tools/profile-validate/validate.ps1 -ProfilePath $tmp; $exit = $LASTEXITCODE; Remove-Item -LiteralPath $tmp -Force; exit $exit'`
- consistency: `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-19__profile-validator-schema-version-field`
- index update: `pwsh -NoProfile -File tools/docs-indexer/index.ps1`
- index check: `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`

## 3. 実施ステップ

1. source finding の根拠を確認し、`schema_version` 導入の互換方針を確定する。
2. `project.profile.yaml` / `tools/profile-validate/profile-schema.json` / `tools/profile-validate/validate.ps1` を更新する。
3. 正常系/異常系で profile validator の PASS/FAIL を確認する。
4. docs / backlog / review / state / MEMORY を更新する。
5. consistency-check と docs-indexer check で完了条件を検証する。

## 4. 変更対象ファイル

- `project.profile.yaml`
- `tools/profile-validate/profile-schema.json`
- `tools/profile-validate/validate.ps1`
- `docs/templates/project-profile.md`
- `docs/operations/profile-validator-schema-version-policy.md`（新規）
- `docs/operations/validator-enhancement-backlog.md`
- `docs/operations/high-priority-backlog.md`
- `docs/INDEX.md`
- `work/2026-02-19__profile-validator-schema-version-field/investigation.md`
- `work/2026-02-19__profile-validator-schema-version-field/spec.md`
- `work/2026-02-19__profile-validator-schema-version-field/plan.md`
- `work/2026-02-19__profile-validator-schema-version-field/review.md`
- `work/2026-02-19__profile-validator-schema-version-field/state.json`
- `MEMORY.md`

## 5. リスクとロールバック

- リスク: 非互換判定が厳しすぎると既存 profile 運用を誤ってブロックする。
- ロールバック:
  1. `schema_version` 互換判定ロジックを切り戻す。
  2. 先に docs でポリシーのみ確定し、コード導入を再計画する。

## 6. 完了判定

- AC-001〜AC-004 がすべて PASS。
- `review.md` に互換 version 判定の正常系/異常系結果が記録されている。
- `state.json` が `done` に更新されている。
