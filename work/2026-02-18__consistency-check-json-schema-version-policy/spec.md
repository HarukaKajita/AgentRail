# 仕様書: 2026-02-18__consistency-check-json-schema-version-policy

## 1. メタ情報 [空欄禁止]

- Task ID: `2026-02-18__consistency-check-json-schema-version-policy`
- タイトル: Consistency Check JSON Schema Version Policy
- 作成日: 2026-02-18
- 更新日: 2026-02-19
- 作成者: codex
- 関連要望: `work/2026-02-18__consistency-check-json-schema-version-policy/request.md`

## 2. 背景と目的 [空欄禁止]

- 背景: `consistency-check` の JSON 出力にはスキーマバージョン情報がなく、将来の形式変更時に利用側が互換判定を行いづらい。
- 目的: JSON 出力へ `schema_version` を追加し、互換ポリシーを明文化して拡張時の運用判断を標準化する。

## 3. スコープ [空欄禁止]

### 3.1 In Scope [空欄禁止]

- `tools/consistency-check/check.ps1` の JSON 出力（single/multi 両モード）へ `schema_version` を追加する。
- JSON スキーマ互換ポリシー（major/minor/patch の運用ルール）を docs に追記する。
- 関連 task ドキュメント（investigation/plan/review/state）を更新する。

### 3.2 Out of Scope [空欄禁止]

- text 出力のフォーマット変更。
- JSON の既存フィールド名変更や削除。
- 新規ルール（`rule_id`）追加。

## 4. 受入条件 (Acceptance Criteria / 受入条件) [空欄禁止]

- AC-001: `-OutputFormat json` 実行時、single/multi いずれの JSON 出力にもトップレベル `schema_version` が含まれる。
- AC-002: `schema_version` は `tools/consistency-check/check.ps1` 内の単一定数で管理され、single/multi で同一値が出力される。
- AC-003: `-OutputFormat text` の既存出力（`CHECK_RESULT` 行と failure 表現）および終了コード挙動が維持される。
- AC-004: `docs/specs/phase2-automation-spec.md` に JSON スキーマ互換ポリシー（互換追加=minor、破壊変更=major）が追記される。

## 5. テスト要件 (Test Requirements / テスト要件) [空欄禁止]

### 5.1 Unit Test (Unit Test / 単体テスト) [空欄禁止]

- 対象: `tools/consistency-check/check.ps1` の JSON payload 組み立て処理
- 観点: single/multi 両モードで `schema_version` が必須項目として出力される
- 合格条件: `ConvertFrom-Json` 後に `schema_version` が空でなく、single/multi で一致する

### 5.2 Integration Test (Integration Test / 結合テスト) [空欄禁止]

- 対象: `-OutputFormat json -OutputFile <path>` 実行
- 観点: 標準出力 JSON とファイル保存 JSON の双方に `schema_version` が含まれる
- 合格条件: 標準出力と保存ファイルの `schema_version` が一致する

### 5.3 Regression Test (Regression Test / 回帰テスト) [空欄禁止]

- 対象: 既存 text モード実行（`-TaskId`）
- 観点: `CHECK_RESULT` / failure 行フォーマットと終了コードが従来互換である
- 合格条件: 正常 task で PASS(0)、異常 task で FAIL(1) の挙動が維持される

### 5.4 Manual Verification (Manual Verification / 手動検証) [空欄禁止]

- 手順:
  1. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-18__project-profile-schema-validation -OutputFormat json`
  2. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskIds 2026-02-18__project-profile-schema-validation,does-not-exist -OutputFormat json`
  3. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-18__project-profile-schema-validation -OutputFormat json -OutputFile .tmp/schema-check.json`
  4. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId does-not-exist`
- 期待結果: AC-001〜AC-004 を満たし、text モード回帰がない

## 6. 影響範囲 [空欄禁止]

- 影響ファイル/モジュール:
  - `tools/consistency-check/check.ps1`
  - `docs/specs/phase2-automation-spec.md`
  - `work/2026-02-18__consistency-check-json-schema-version-policy/*`
- 影響する仕様:
  - `docs/specs/phase2-ci-integration-spec.md`（必要なら参照追記）
- 非機能影響:
  - JSON 利用側の将来拡張互換判定が容易になる

## 7. 制約とリスク [空欄禁止]

- 制約: 既存 JSON 利用を壊さないため、追加項目のみで対応する。
- 想定リスク: 版番号方針が曖昧だと将来更新時に運用差異が出る。
- 回避策: docs に versioning policy を明文化し、更新時の判断基準を固定する。

## 8. 未確定事項 [空欄禁止]

- `schema_version` 初期値は `1.0.0` とするが、patch 増分をいつ利用するかは運用規約に従う。

## 9. 関連資料リンク [空欄禁止]

- request: `work/2026-02-18__consistency-check-json-schema-version-policy/request.md`
- investigation: `work/2026-02-18__consistency-check-json-schema-version-policy/investigation.md`
- plan: `work/2026-02-18__consistency-check-json-schema-version-policy/plan.md`
- review: `work/2026-02-18__consistency-check-json-schema-version-policy/review.md`
- docs:
  - `docs/operations/high-priority-backlog.md`
  - `docs/specs/phase2-automation-spec.md`
