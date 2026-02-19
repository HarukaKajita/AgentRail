# 仕様書: 2026-02-19__profile-version-schema-version-unification-strategy

## 1. メタ情報 [空欄禁止]

- Task ID: `2026-02-19__profile-version-schema-version-unification-strategy`
- タイトル: Profile Version Schema Version Unification Strategy
- 作成日: 2026-02-19
- 更新日: 2026-02-19
- 作成者: codex
- 関連要望: `work/2026-02-19__profile-version-schema-version-unification-strategy/request.md`

## 2. 背景と目的 [空欄禁止]

- 背景: `project.profile.yaml` では `version` と `schema_version` が共存し、将来の正本フィールドが未確定。
- 目的: 統合方針（正本・移行・廃止判定）を定義し、実装時の判断基準を固定する。

## 3. スコープ [空欄禁止]

### 3.1 In Scope [空欄禁止]

- `version` と `schema_version` の役割分担を最終決定する。
- 移行フェーズ（warning/fail/削除）の基準を定義する。
- validator・profile・docs の更新順序を決定する。

### 3.2 Out of Scope [空欄禁止]

- 本タスク内での実際の削除実装。
- profile 以外の設定ファイルへ同様ルールを適用する設計変更。

## 4. 受入条件 (Acceptance Criteria / 受入条件) [空欄禁止]

- AC-001: 正本フィールドを `schema_version` とする方針が明文化される。
- AC-002: `version` 廃止までの段階的移行ルール（期間またはメジャー基準）が定義される。
- AC-003: validator 実装の遷移仕様（warning/fail 切替条件）が定義される。
- AC-004: 方針が backlog と task 文書に反映され、着手可能状態になる。

## 5. テスト要件 (Test Requirements / テスト要件) [空欄禁止]

### 5.1 Unit Test (Unit Test / 単体テスト) [空欄禁止]

- 対象: 方針文書に定義する validator 判定ルール
- 観点: 旧形式・新形式・混在形式の3ケース判定基準が定義されている。
- 合格条件: 各ケースの期待結果（pass/warn/fail）が曖昧なく記述される。

### 5.2 Integration Test (Integration Test / 結合テスト) [空欄禁止]

- 対象: `tools/profile-validate/validate.ps1` と `project.profile.yaml` 更新計画
- 観点: 実装順序が CI 破壊なく適用できる手順になっている。
- 合格条件: 適用順序（schema更新→validator更新→profile更新）が明示される。

### 5.3 Regression Test (Regression Test / 回帰テスト) [空欄禁止]

- 対象: 既存運用ドキュメントと backlog
- 観点: 新方針追加で既存導線が壊れない。
- 合格条件: `docs/operations/high-priority-backlog.md` と `docs/operations/validator-enhancement-backlog.md` が整合する。

### 5.4 Manual Verification (Manual Verification / 手動検証) [空欄禁止]

- 手順:
  1. 方針案の正本・移行・廃止基準を spec に記載する。
  2. 実装順序とロールバックを plan に記載する。
  3. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-19__profile-version-schema-version-unification-strategy` を実行する。
- 期待結果: 方針文書が実装可能粒度で定義され、consistency-check が PASS する。

## 6. 影響範囲 [空欄禁止]

- 影響ファイル/モジュール:
  - `project.profile.yaml`
  - `tools/profile-validate/validate.ps1`
  - `tools/profile-validate/profile-schema.json`
  - `docs/templates/project-profile.md`
  - `docs/operations/profile-validator-schema-version-policy.md`
- 影響する仕様:
  - `docs/operations/high-priority-backlog.md`
  - `docs/operations/validator-enhancement-backlog.md`
- 非機能影響:
  - 互換性判断の一貫性向上

## 7. 制約とリスク [空欄禁止]

- 制約: 既存リポジトリの `project.profile.yaml` 互換を維持しながら移行する。
- 想定リスク: 移行フェーズ定義が曖昧だと運用で判断が分岐する。
- 回避策: phase ごとの exit condition を数値または明示条件で記載する。

## 8. 未確定事項 [空欄禁止]

- 廃止フェーズで `version` を hard fail に切り替えるタイミング。

## 9. 関連資料リンク [空欄禁止]

- request: `work/2026-02-19__profile-version-schema-version-unification-strategy/request.md`
- investigation: `work/2026-02-19__profile-version-schema-version-unification-strategy/investigation.md`
- plan: `work/2026-02-19__profile-version-schema-version-unification-strategy/plan.md`
- review: `work/2026-02-19__profile-version-schema-version-unification-strategy/review.md`
- docs:
  - `docs/operations/high-priority-backlog.md`
  - `docs/operations/validator-enhancement-backlog.md`
  - `docs/operations/profile-validator-schema-version-policy.md`
