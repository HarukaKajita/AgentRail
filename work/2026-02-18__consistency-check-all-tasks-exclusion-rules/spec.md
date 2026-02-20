# 仕様書: 2026-02-18__consistency-check-all-tasks-exclusion-rules

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 1. メタ情報 (Metadata) (必須)

- Task ID: `2026-02-18__consistency-check-all-tasks-exclusion-rules`
- タイトル: Consistency Check All Tasks Exclusion Rules
- 作成日: 2026-02-18
- 更新日: 2026-02-19
- 作成者: codex
- 関連要望: `work/2026-02-18__consistency-check-all-tasks-exclusion-rules/request.md`

## 2. 背景と目的 (Background & Objectives) (必須)

- 背景: `-AllTasks` が保守対象外の legacy task も検査対象に含めるため、運用時にノイズ失敗が発生しやすい。
- 目的: archive/legacy を対象外にする明示ルールを導入し、運用対象 task の検査精度を高める。

## 3. スコープ (Scope) (必須)

### 3.1 In Scope (必須)

- `tools/consistency-check/check.ps1` の `-AllTasks` 対象抽出に除外ルールを追加する。
- 除外条件を docs へ反映し、運用基準として明文化する。
- task ドキュメント（investigation/plan/review/state）を更新する。

### 3.2 Out of Scope (必須)

- `-TaskId` / `-TaskIds` の対象判定変更。
- 除外ルールの外部設定化（config ファイル化）。
- checker rule 本体（`rule_id` 群）の追加/削除。

## 4. 受入条件 (Acceptance Criteria) (必須)

- AC-001: `-AllTasks` 実行時、ディレクトリ名が `archive` または `legacy` で始まる task ディレクトリが検査対象から除外される。
- AC-002: 除外対象以外の task ディレクトリは従来どおり検査され、失敗時は終了コード 1 になる。
- AC-003: `-TaskId` / `-TaskIds` 実行では除外ルールが適用されず、明示指定 task をそのまま検査できる。
- AC-004: `docs/specs/automation-tools-design-spec.md` に `-AllTasks` の除外条件が追記される。

## 5. テスト要件 (Test Requirements) (必須)

### 5.1 単体テスト (Unit Test) (必須)

- **対象**: `tools/consistency-check/check.ps1` の all モード対象抽出処理
- **検証項目**: `archive`/`legacy` で始まるディレクトリが除外される
- **合格基準**: `-AllTasks -OutputFormat json` の `results[].task_id` に除外ディレクトリが含まれない

### 5.2 結合テスト (Integration Test) (必須)

- **対象**: temp work root による mixed ディレクトリ検証
- **検証項目**: 除外対象は無視しつつ、通常 task の失敗は正しく FAIL になる
- **合格基準**: 除外のみなら PASS、通常 task に欠陥があれば FAIL になる

### 5.3 回帰テスト (Regression Test) (必須)

- **対象**: `-TaskId` / `-TaskIds` 実行
- **検証項目**: 明示指定モードの既存挙動を維持する
- **合格基準**: 既存 task で PASS、不存在 task で FAIL の挙動が維持される

### 5.4 手動検証 (Manual Verification) (必須)

- **検証手順**:
  1. temp work root に通常 task・`archive-*`・`legacy-*` ディレクトリを作成する
  2. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks -WorkRoot <temp-work-root> -OutputFormat json`
  3. 通常の壊れた task を追加して同コマンドを再実行する
  4. `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId does-not-exist`
- **期待される結果**: AC-001〜AC-004 を満たし、明示指定モードの回帰がない

## 6. 影響範囲 (Impact Assessment) (必須)

- 影響ファイル/モジュール:
  - `tools/consistency-check/check.ps1`
  - `docs/specs/automation-tools-design-spec.md`
  - `work/2026-02-18__consistency-check-all-tasks-exclusion-rules/*`
- 影響する仕様:
  - `docs/specs/automation-tools-ci-integration-spec.md`（必要に応じて参照追記）
- 非機能影響:
  - `-AllTasks` 実行時の運用ノイズ低減

## 7. 制約とリスク (Constraints & Risks) (必須)

- 制約: 既存 CLI 互換を維持し、追加パラメータなしで運用できる形にする。
- 想定リスク: 名前ベース除外が過剰に効くと、本来検査すべき task をスキップする可能性がある。
- 回避策: 除外対象を `archive`/`legacy` prefix のみに限定し、docs に明示する。

## 8. 未確定事項 (Open Issues) (必須)

- `disabled` など追加カテゴリの除外は別タスクで検討する。

## 9. 関連資料リンク (Reference Links) (必須)

- request: `work/2026-02-18__consistency-check-all-tasks-exclusion-rules/request.md`
- investigation: `work/2026-02-18__consistency-check-all-tasks-exclusion-rules/investigation.md`
- plan: `work/2026-02-18__consistency-check-all-tasks-exclusion-rules/plan.md`
- review: `work/2026-02-18__consistency-check-all-tasks-exclusion-rules/review.md`
- docs:
  - `docs/operations/high-priority-backlog.md`
  - `docs/specs/automation-tools-design-spec.md`
