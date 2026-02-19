# Plan: 2026-02-19__profile-version-schema-version-unification-strategy

## 1. 対象仕様

- `work/2026-02-19__profile-version-schema-version-unification-strategy/spec.md`

## 2. Execution Commands

- consistency: `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-19__profile-version-schema-version-unification-strategy`
- index update: `pwsh -NoProfile -File tools/docs-indexer/index.ps1`
- profile validate: `pwsh -NoProfile -File tools/profile-validate/validate.ps1 -ProfilePath project.profile.yaml`

## 3. 実施ステップ

1. `version` と `schema_version` の現行役割を棚卸しする。
2. 正本を `schema_version` とする移行案を phase 単位で定義する。
3. validator の warning/fail 切替条件を定義する。
4. docs・backlog・task 記録を更新する。
5. consistency-check を実行して起票成果物の整合を確認する。

## 4. 変更対象ファイル

- `work/2026-02-19__profile-version-schema-version-unification-strategy/request.md`
- `work/2026-02-19__profile-version-schema-version-unification-strategy/investigation.md`
- `work/2026-02-19__profile-version-schema-version-unification-strategy/spec.md`
- `work/2026-02-19__profile-version-schema-version-unification-strategy/plan.md`
- `work/2026-02-19__profile-version-schema-version-unification-strategy/review.md`
- `work/2026-02-19__profile-version-schema-version-unification-strategy/state.json`
- `docs/operations/high-priority-backlog.md`
- `docs/operations/validator-enhancement-backlog.md`
- `MEMORY.md`

## 5. リスクとロールバック

- リスク: 統合方針が抽象的すぎると実装段階で再検討が発生する。
- ロールバック: 方針を phase 単位で分割し、判断不能項目は未確定事項へ戻す。

## 6. 完了判定

- AC-001〜AC-004 が `review.md` で PASS になる。
- `state.json` が `planned` で起票完了状態を示す。
- `tools/consistency-check/check.ps1` が PASS する。
