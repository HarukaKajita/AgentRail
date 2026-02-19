# Plan: 2026-02-19__profile-version-schema-version-unification-strategy

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 0. 着手前確定

### 0.1 テスト設計オプション（Rail7）

1. 最小: 現行 profile PASS のみ確認。
2. 標準（採用）: PASS + `version` 混入 FAIL + unsupported `schema_version` FAIL。
3. 強化: 標準 + consistency/state/docs の回帰チェック。

採用理由:
- 破壊的変更点（`version` 廃止）を直接検証しつつ、運用整合の回帰も同時に確認できる。

### 0.2 docs 反映オプション（Rail9）

1. 最小更新: policy のみ更新。
2. 標準更新（採用）: policy + backlog 2種 + `docs/INDEX.md` + `MEMORY.md`。
3. 詳細更新: 標準 + 関連 historical docs の全面改訂。

採用理由:
- 完了条件に必要な導線整合を満たしながら、履歴資料の意味を壊さずに更新できる。

### 0.3 推奨案

- テスト: 0.1-2 をベースに 0.1-3 の回帰チェックまで実施する。
- docs: 0.2-2 を採用する。

### 0.4 確認質問（2〜4件）

- なし。破壊的変更許容・一気通貫完了の指示が要望で明示されているため。

### 0.5 blocked 判定

- `blocked` ではない。実行前チェックと必須成果物条件を満たしている。

## 1. 対象仕様

- `work/2026-02-19__profile-version-schema-version-unification-strategy/spec.md`

## 2. Execution Commands

- profile validate(pass):
  - `pwsh -NoProfile -File tools/profile-validate/validate.ps1 -ProfilePath project.profile.yaml`
- profile validate(fail: version key):
  - `pwsh -NoProfile -Command '$tmp = Join-Path $env:TEMP ("profile-forbidden-version-" + [Guid]::NewGuid().ToString("N") + ".yaml"); $content = Get-Content -Raw project.profile.yaml; $updated = "version: 1`n" + $content; Set-Content -LiteralPath $tmp -Value $updated; & pwsh -NoProfile -File tools/profile-validate/validate.ps1 -ProfilePath $tmp; $exit = $LASTEXITCODE; Remove-Item -LiteralPath $tmp -Force; exit $exit'`
- profile validate(fail: unsupported schema_version):
  - `pwsh -NoProfile -Command '$tmp = Join-Path $env:TEMP ("profile-unsupported-schema-version-" + [Guid]::NewGuid().ToString("N") + ".yaml"); $content = Get-Content -Raw project.profile.yaml; $updated = [Regex]::Replace($content, "(?m)^schema_version:\\s*.*$", "schema_version: ""1.0.0"""); Set-Content -LiteralPath $tmp -Value $updated; & pwsh -NoProfile -File tools/profile-validate/validate.ps1 -ProfilePath $tmp; $exit = $LASTEXITCODE; Remove-Item -LiteralPath $tmp -Force; exit $exit'`
- consistency:
  - `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-19__profile-version-schema-version-unification-strategy`
- state validate:
  - `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks`
- docs index check:
  - `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`

## 3. 実施ステップ

1. task 文書（request/investigation/spec/plan）を実装前提へ更新する。
2. `project.profile.yaml` と profile validator schema/script を `schema_version` 単一運用へ変更する。
3. policy/backlog/index を統合後状態へ更新する。
4. 実行コマンドで PASS/FAIL 条件を検証し、結果を `review.md` へ記録する。
5. `state.json` を `done` に更新し、`MEMORY.md` を完了状態へ同期する。

## 4. 変更対象ファイル

- `project.profile.yaml`
- `tools/profile-validate/profile-schema.json`
- `tools/profile-validate/validate.ps1`
- `docs/templates/project-profile.md`
- `docs/operations/profile-validator-schema-version-policy.md`
- `docs/operations/high-priority-backlog.md`
- `docs/operations/validator-enhancement-backlog.md`
- `docs/INDEX.md`
- `work/2026-02-19__profile-version-schema-version-unification-strategy/request.md`
- `work/2026-02-19__profile-version-schema-version-unification-strategy/investigation.md`
- `work/2026-02-19__profile-version-schema-version-unification-strategy/spec.md`
- `work/2026-02-19__profile-version-schema-version-unification-strategy/plan.md`
- `work/2026-02-19__profile-version-schema-version-unification-strategy/review.md`
- `work/2026-02-19__profile-version-schema-version-unification-strategy/state.json`
- `MEMORY.md`

## 5. リスクとロールバック

- リスク:
  - `version` を残した profile が validator で即時失敗する。
  - docs 未更新で運用手順が旧仕様のまま残る。
- ロールバック:
  1. `project.profile.yaml` へ `version` を復帰する。
  2. `tools/profile-validate/profile-schema.json` の required key/supported version を旧定義へ戻す。
  3. `tools/profile-validate/validate.ps1` の `version` 拒否チェックを戻す。
  4. policy/backlog/index/memory を直前コミットへ戻す。

## 6. 完了判定

- `spec.md` の AC-001〜AC-005 が `review.md` で PASS になる。
- Unit/Integration/Regression/Manual の結果が `review.md` に記録される。
- docs 反映と `docs/INDEX.md` 導線が更新される。
- `state.json` が `done` で最新化される。
- `MEMORY.md` が完了状態に更新される。
