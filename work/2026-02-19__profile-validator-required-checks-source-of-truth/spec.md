# 仕様書: 2026-02-19__profile-validator-required-checks-source-of-truth

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 1. メタ情報 (Metadata) (必須)

- Task ID: `2026-02-19__profile-validator-required-checks-source-of-truth`
- タイトル: Profile Validator Required Checks Source Of Truth
- 作成日: 2026-02-19
- 更新日: 2026-02-19
- 作成者: codex
- 関連要望: `work/2026-02-19__profile-validator-required-checks-source-of-truth/request.md`

## 2. 背景と目的 (Background & Objectives) (必須)

- 背景: source task の finding F-001 では、`tools/profile-validate/validate.ps1` の `requiredChecks` 静的配列が profile 拡張時の更新漏れリスクを持つと指摘された。
- 目的: required key 定義を schema ファイルへ集約し、validator の source of truth を明確化する。

## 3. スコープ (Scope) (必須)

### 3.1 In Scope (必須)

- `tools/profile-validate/profile-schema.json` を追加し、required key path を定義する。
- `tools/profile-validate/validate.ps1` が schema 読み込み型で検証するよう更新する。
- schema 更新手順を docs に追記し、`docs/INDEX.md` を同期する。

### 3.2 Out of Scope (必須)

- `tools/consistency-check/check.ps1` の profile_required_keys ロジック統合。
- `project.profile.yaml` への schema version フィールド追加（VE-002 で対応）。

## 4. 受入条件 (Acceptance Criteria) (必須)

- AC-001: `tools/profile-validate/validate.ps1` から `requiredChecks` 静的配列を廃止し、`tools/profile-validate/profile-schema.json` の required key 定義を参照して検証できる。
- AC-002: 現在の `project.profile.yaml` に対して `pwsh -NoProfile -File tools/profile-validate/validate.ps1 -ProfilePath project.profile.yaml` が PASS する。
- AC-003: required key を欠落させた一時 profile では validator が FAIL し、`Missing required key path` を出力する。
- AC-004: schema 定義の運用手順が docs へ追加され、`docs/INDEX.md` から参照できる。

## 5. テスト要件 (Test Requirements) (必須)

### 5.1 単体テスト (Unit Test) (必須)

- **対象**: `tools/profile-validate/validate.ps1`
- **検証項目**: schema の required key path（scalar/container）を regex に変換して判定できる。
- **合格基準**: 正常 profile で PASS、欠落 profile で FAIL し、判定結果が AC-002/AC-003 と一致する。

### 5.2 結合テスト (Integration Test) (必須)

- **対象**: `tools/consistency-check/check.ps1` と task 文書一式
- **検証項目**: 実装後ドキュメント状態で consistency-check が PASS する。
- **合格基準**: `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-19__profile-validator-required-checks-source-of-truth` が PASS。

### 5.3 回帰テスト (Regression Test) (必須)

- **対象**: docs インデックス同期フロー
- **検証項目**: docs 追加後もインデクサーの check モードが PASS する。
- **合格基準**: `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check` が PASS。

### 5.4 手動検証 (Manual Verification) (必須)

- **検証手順**:
  1. `pwsh -NoProfile -File tools/profile-validate/validate.ps1 -ProfilePath project.profile.yaml` を実行する。
  2. `project.profile.yaml` から `review.required_checks` を削除した一時ファイルを作成し validator を実行する。
  3. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-19__profile-validator-required-checks-source-of-truth` を実行する。
  4. `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check` を実行する。
- **期待される結果**: 手順 1 は PASS、手順 2 は FAIL（`Missing required key path: review.required_checks` を含む）、手順 3・4 は PASS。

## 6. 影響範囲 (Impact Assessment) (必須)

- 影響ファイル/モジュール:
  - `tools/profile-validate/validate.ps1`
  - `tools/profile-validate/profile-schema.json`（新規）
  - `docs/operations/profile-validator-required-checks-source-of-truth.md`（新規）
  - `docs/operations/validator-enhancement-backlog.md`
  - `docs/operations/high-priority-backlog.md`
  - `docs/INDEX.md`
- 影響する仕様:
  - `docs/operations/validator-enhancement-backlog.md`
- 非機能影響:
  - required key 定義変更時の保守手順が明確になる。

## 7. 制約とリスク (Constraints & Risks) (必須)

- 制約: PowerShell 標準機能のみを利用し、追加依存を導入しない。
- 想定リスク: regex 生成ロジックが YAML のインデント差異に弱い。
- 回避策: scalar/container 判定を schema で明示し、欠落ケースの FAIL テストを review に記録する。

## 8. 未確定事項 (Open Issues) (必須)

- `consistency-check` 側の required key 定義統合は次フェーズで検討する。

## 9. 関連資料リンク (Reference Links) (必須)

- request: `work/2026-02-19__profile-validator-required-checks-source-of-truth/request.md`
- investigation: `work/2026-02-19__profile-validator-required-checks-source-of-truth/investigation.md`
- plan: `work/2026-02-19__profile-validator-required-checks-source-of-truth/plan.md`
- review: `work/2026-02-19__profile-validator-required-checks-source-of-truth/review.md`
- docs:
  - `docs/operations/profile-validator-required-checks-source-of-truth.md`
  - `docs/operations/validator-enhancement-backlog.md`
  - `docs/operations/high-priority-backlog.md`
