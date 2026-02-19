# 仕様書: 2026-02-19__profile-version-schema-version-unification-strategy

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 1. メタ情報 [空欄禁止]

- Task ID: `2026-02-19__profile-version-schema-version-unification-strategy`
- タイトル: Profile Version Schema Version Unification Strategy
- 作成日: 2026-02-19
- 更新日: 2026-02-19
- 作成者: codex
- 関連要望: `work/2026-02-19__profile-version-schema-version-unification-strategy/request.md`

## 2. 背景と目的 [空欄禁止]

- 背景: `project.profile.yaml` には `version` と `schema_version` が共存し、同一概念の二重管理が発生している。
- 目的: `schema_version` を profile schema の唯一の正本へ統一し、`version` 依存を廃止する。
- 方針: 過去互換を維持せず、破壊的変更として統合を一括適用する。

## 3. スコープ [空欄禁止]

### 3.1 In Scope [空欄禁止]

- `project.profile.yaml` から `version` を削除し、`schema_version` のみを保持する。
- `tools/profile-validate/profile-schema.json` から `version` required key を削除し、許容 `schema_version` を `2.0.0` のみに更新する。
- `tools/profile-validate/validate.ps1` に `version` キー拒否チェックを追加する。
- policy/backlog/index/task/memory 文書を統合後状態へ更新する。

### 3.2 Out of Scope [空欄禁止]

- `consistency-check` JSON の `schema_version` 仕様変更。
- profile 以外の設定ファイルへ同一ルールを拡張する実装。

## 4. 受入条件 (Acceptance Criteria / 受入条件) [空欄禁止]

- AC-001: `project.profile.yaml` に top-level `version` が存在せず、`schema_version: "2.0.0"` が設定される。
- AC-002: `tools/profile-validate/profile-schema.json` の `required_keys` から `version` が削除され、`supported_profile_schema_versions` は `2.0.0` のみになる。
- AC-003: profile validator が `version` キーを含む profile を FAIL とし、unsupported `schema_version` も FAIL とする。
- AC-004: `docs/operations/profile-validator-schema-version-policy.md` と backlog 文書が統合後の方針に更新される。
- AC-005: `review.md` にテスト結果が記録され、`state.json` は `done` へ更新される。

## 5. テスト要件 (Test Requirements / テスト要件) [空欄禁止]

### 5.1 Unit Test (Unit Test / 単体テスト) [空欄禁止]

- 対象: `tools/profile-validate/validate.ps1` の `schema_version` 判定と `version` キー拒否判定
- 観点: 正常系 1 ケースと異常系 2 ケースが意図どおり判定される
- 合格条件: 現行 profile は PASS、`version` 混入と旧 `schema_version` は FAIL
- Unit Test-1:
  - 対象: `tools/profile-validate/validate.ps1`
  - 実施: `pwsh -NoProfile -File tools/profile-validate/validate.ps1 -ProfilePath project.profile.yaml`
  - 合格条件: `PROFILE_VALIDATE: PASS`
- Unit Test-2:
  - 対象: `version` キー拒否
  - 実施: 一時 profile に `version: 1` を挿入して validator 実行
  - 合格条件: `Forbidden top-level key is present: version` を含む FAIL
- Unit Test-3:
  - 対象: `schema_version` 互換判定
  - 実施: 一時 profile の `schema_version` を `1.0.0` に変更して validator 実行
  - 合格条件: `Unsupported schema_version` を含む FAIL

### 5.2 Integration Test (Integration Test / 結合テスト) [空欄禁止]

- 対象: task 成果物の整合検証（`tools/consistency-check/check.ps1`）
- 観点: 受入条件・テスト要件・文書参照の整合性が満たされる
- 合格条件: 対象 task の consistency-check が `PASS`
- Integration Test-1:
  - 実施: `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-19__profile-version-schema-version-unification-strategy`
  - 合格条件: `PASS` を返し、必須成果物整合が満たされる。

### 5.3 Regression Test (Regression Test / 回帰テスト) [空欄禁止]

- 対象: repository 全体の state/docs 整合（`state-validate`、`docs-indexer check`）
- 観点: 本変更が既存タスク管理と docs 導線に回帰を起こさない
- 合格条件: `state-validate` と `docs-indexer check` がともに `PASS`
- Regression Test-1:
  - 実施: `pwsh -NoProfile -File tools/state-validate/validate.ps1 -AllTasks`
  - 合格条件: `PASS`
- Regression Test-2:
  - 実施: `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`
  - 合格条件: 差分なしで `PASS`

### 5.4 Manual Verification (Manual Verification / 手動検証) [空欄禁止]

- 手順:
  1. `project.profile.yaml` に `version` が存在しないことを確認する。
  2. `docs/operations/profile-validator-schema-version-policy.md` の方針が「`schema_version` 単一運用」になっていることを確認する。
  3. `docs/operations/high-priority-backlog.md` と `docs/operations/validator-enhancement-backlog.md` の本タスク状態が `done` へ更新されていることを確認する。
  4. `docs/INDEX.md` の更新内容が反映されていることを確認する。
  5. `MEMORY.md` と `state.json` が完了状態へ更新されていることを確認する。
- 期待結果: 破壊的統合の実装・検証・記録がすべて完了している。

### 5.5 テスト設計オプション [空欄禁止]

1. 最小: 現行 profile の PASS のみ確認する。
2. 標準（採用）: PASS + `version` 混入 FAIL + unsupported `schema_version` FAIL を確認する。
3. 強化: 標準に加えて `check_consistency`、`state-validate`、`docs-indexer check` を実行する。

- 採用理由: 破壊的変更の回帰リスクを抑えつつ、過剰な検証コストを避けられるため。

### 5.6 AC-テスト対応表 [空欄禁止]

- AC-001: Unit Test-1（現行 profile PASS）
- AC-002: Unit Test-1（required key 検証） + Manual Verification-1（schema 定義確認）
- AC-003: Unit Test-2（`version` 混入 FAIL） + Unit Test-3（unsupported `schema_version` FAIL）
- AC-004: Regression Test-2（docs-indexer check） + Manual Verification-2（policy/backlog 反映確認）
- AC-005: Integration Test-1（consistency-check PASS） + Regression Test-1（state-validate PASS）

## 6. 影響範囲 [空欄禁止]

- 影響ファイル/モジュール:
  - `project.profile.yaml`
  - `tools/profile-validate/profile-schema.json`
  - `tools/profile-validate/validate.ps1`
  - `docs/templates/project-profile.md`
  - `docs/operations/profile-validator-schema-version-policy.md`
- 影響する仕様・運用資料:
  - `docs/operations/high-priority-backlog.md`
  - `docs/operations/validator-enhancement-backlog.md`
  - `docs/INDEX.md`
  - `MEMORY.md`
- 非機能影響:
  - profile 定義の曖昧性削減
  - validator 判定の一貫性向上

## 7. 制約とリスク [空欄禁止]

- 制約: 破壊的変更として旧 profile 互換を維持しない。
- 想定リスク: `version` キーを残した profile が即時 FAIL となる。
- 回避策: validator エラーメッセージを明示し、修正方法を docs へ記録する。

## 8. 未確定事項 [空欄禁止]

- なし。

## 9. 関連資料リンク [空欄禁止]

- request: `work/2026-02-19__profile-version-schema-version-unification-strategy/request.md`
- investigation: `work/2026-02-19__profile-version-schema-version-unification-strategy/investigation.md`
- plan: `work/2026-02-19__profile-version-schema-version-unification-strategy/plan.md`
- review: `work/2026-02-19__profile-version-schema-version-unification-strategy/review.md`
- docs:
  - `docs/operations/profile-validator-schema-version-policy.md`
  - `docs/operations/high-priority-backlog.md`
  - `docs/operations/validator-enhancement-backlog.md`
