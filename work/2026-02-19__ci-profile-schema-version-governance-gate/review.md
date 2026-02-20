# Review: 2026-02-19__ci-profile-schema-version-governance-gate

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `work/2026-02-19__ci-profile-schema-version-governance-gate/request.md`
  - `work/2026-02-19__ci-profile-schema-version-governance-gate/spec.md`
- 理解ポイント:
  - 本資料に入る前に、task の目的・受入条件・依存関係を把握する。
## 1. レビュー対象

- `tools/profile-validate/check-schema-governance.ps1`
- `.github/workflows/ci-framework.yml`
- `docs/operations/profile-validator-schema-version-policy.md`
- `docs/specs/automation-tools-ci-integration-spec.md`
- `docs/operations/ci-failure-runbook.md`
- `docs/INDEX.md`
- `docs/operations/high-priority-backlog.md`
- `docs/operations/validator-enhancement-backlog.md`
- `work/2026-02-19__ci-profile-schema-version-governance-gate/state.json`

## 2. 受入条件評価

- AC-001: PASS（base/head 比較で PASS/FAIL 判定する governance script を追加）
- AC-002: PASS（schema 変更かつ `schema_version` 不変のケースで FAIL を確認）
- AC-003: PASS（breaking change + major 未増分のケースで FAIL を確認）
- AC-004: PASS（`schema_version` が supported list 外のケースで FAIL を確認）
- AC-005: PASS（`ci-framework.yml` に governance step を追加し、validator 前に fail-fast 実行）
- AC-006: PASS（policy/spec/runbook/index に運用更新を反映）

## 3. テスト結果

### Unit Test

- 実施内容:
  - `pwsh -NoProfile -File tools/profile-validate/check-schema-governance.ps1 -RepoRoot . -BaseSha HEAD~1 -HeadSha HEAD`（現行差分では schema 未変更で PASS）
  - `pwsh -NoProfile -Command "$tempRoot = Join-Path $env:TEMP ('schema-gov-test-' + [Guid]::NewGuid().ToString('N')); git clone --no-local . $tempRoot | Out-Null; git -C $tempRoot config user.email 'ci@example.com'; git -C $tempRoot config user.name 'CI'; $base = (& git -C $tempRoot rev-parse HEAD).Trim(); function Save-Json { param([string]$path, [object]$obj) ($obj | ConvertTo-Json -Depth 20) | Set-Content -LiteralPath $path -NoNewline }; $schemaPath = Join-Path $tempRoot 'tools/profile-validate/profile-schema.json'; git -C $tempRoot checkout -b case-r001 $base | Out-Null; $o = Get-Content -Raw $schemaPath | ConvertFrom-Json; $o.required_keys = @($o.required_keys | Select-Object -Skip 1); Save-Json -path $schemaPath -obj $o; git -C $tempRoot add tools/profile-validate/profile-schema.json | Out-Null; git -C $tempRoot commit -m 'case r001' | Out-Null; $head1 = (& git -C $tempRoot rev-parse HEAD).Trim(); pwsh -NoProfile -File tools/profile-validate/check-schema-governance.ps1 -RepoRoot $tempRoot -BaseSha $base -HeadSha $head1 | Out-Null; $exit1 = $LASTEXITCODE; git -C $tempRoot checkout -B case-r004 $base | Out-Null; $o = Get-Content -Raw $schemaPath | ConvertFrom-Json; $o.required_keys = @($o.required_keys | Select-Object -Skip 1); $o.schema_version = '2.0.1'; $o.supported_profile_schema_versions = @('2.0.0', '2.0.1'); Save-Json -path $schemaPath -obj $o; git -C $tempRoot add tools/profile-validate/profile-schema.json | Out-Null; git -C $tempRoot commit -m 'case r004' | Out-Null; $head2 = (& git -C $tempRoot rev-parse HEAD).Trim(); pwsh -NoProfile -File tools/profile-validate/check-schema-governance.ps1 -RepoRoot $tempRoot -BaseSha $base -HeadSha $head2 | Out-Null; $exit2 = $LASTEXITCODE; git -C $tempRoot checkout -B case-r003 $base | Out-Null; $o = Get-Content -Raw $schemaPath | ConvertFrom-Json; $o.schema_version = '9.9.9'; Save-Json -path $schemaPath -obj $o; git -C $tempRoot add tools/profile-validate/profile-schema.json | Out-Null; git -C $tempRoot commit -m 'case r003' | Out-Null; $head3 = (& git -C $tempRoot rev-parse HEAD).Trim(); pwsh -NoProfile -File tools/profile-validate/check-schema-governance.ps1 -RepoRoot $tempRoot -BaseSha $base -HeadSha $head3 | Out-Null; $exit3 = $LASTEXITCODE; Write-Output ('UNIT_CASE_EXIT_CODES: {0},{1},{2}' -f $exit1, $exit2, $exit3); Remove-Item -LiteralPath $tempRoot -Recurse -Force"`
  - 結果確認: `UNIT_CASE_EXIT_CODES: 1,1,1`
- 結果: PASS

### Integration Test

- 実施内容:
  - `rg -n "Enforce profile schema governance|check-schema-governance.ps1" .github/workflows/ci-framework.yml`
  - `.github/workflows/ci-framework.yml` で `Run docs-indexer` の次に `Enforce profile schema governance` step が存在し、`pull_request` / `push` の base/head を渡すことを確認。
- 結果: PASS

### Regression Test

- 実施内容:
  - `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-19__ci-profile-schema-version-governance-gate`
  - `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks`
  - `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks`
  - `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`
  - `pwsh -NoProfile -File tools/profile-validate/validate.ps1 -ProfilePath project.profile.yaml`
- 結果: PASS

### Manual Verification

- 実施内容:
  1. `schema_version` 据え置きで schema を変更したケースが R-001 で FAIL することを確認。
  2. breaking change なのに major 未増分（例: `2.0.0 -> 2.0.1`）の場合に R-004 で FAIL することを確認。
  3. `schema_version` を supported list から外した場合に R-003 で FAIL することを確認。
  4. policy/spec/runbook/index に governance 運用が追記されていることを確認。
- 結果: PASS

## 4. 指摘事項

- 重大: なし
- 改善提案:
  - 将来的に governance script の fixture ベース自動テストを追加すると、判定ロジックの回帰をさらに早期検出できる。

## 5. 結論

- CI profile schema governance gate を導入し、受入条件 AC-001〜AC-006 を満たした。
- 本タスクは `done` 判定で問題ない。

## 6. プロセス改善案 (Process Findings) (必須)

### 6.1 Finding F-001

- finding_id: F-001
- category: ci
- severity: low
- summary: profile schema version governance を CI fail-fast step として定着できた。
- evidence: `tools/profile-validate/check-schema-governance.ps1` を追加し、workflow・policy・runbook を同期更新した。
- action_required: no
- linked_task_id: none

