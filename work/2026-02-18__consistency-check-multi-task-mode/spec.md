# 仕様書: 2026-02-18__consistency-check-multi-task-mode

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 1. メタ情報 [空欄禁止]

- Task ID: `2026-02-18__consistency-check-multi-task-mode`
- タイトル: consistency-check 複数 task 走査モード
- 作成日: 2026-02-18
- 更新日: 2026-02-18
- 作成者: Codex
- 関連要望: `work/2026-02-18__consistency-check-multi-task-mode/request.md`

## 2. 背景と目的 [空欄禁止]

- 背景: checker は `-TaskId` 必須で単一対象しか検査できない。
- 目的: 複数 task 一括検査を可能にし、運用時の見逃しを減らす。

## 3. スコープ [空欄禁止]

### 3.1 In Scope [空欄禁止]

- `-TaskIds`（複数指定）モード追加
- `-AllTasks`（`work/` 全走査）モード追加
- task 単位の PASS/FAIL 集計出力
- 単一 `-TaskId` モードとの後方互換維持

### 3.2 Out of Scope [空欄禁止]

- JSON 出力対応（別タスク）
- rule 追加や削除

## 4. 受入条件 (Acceptance Criteria / 受入条件) [空欄禁止]

- AC-001: `-TaskId` 既存挙動が維持される。
- AC-002: `-TaskIds` で複数 task を順次検査できる。
- AC-003: `-AllTasks` で `work/` 配下 task を検査できる。
- AC-004: いずれか task が FAIL の場合、終了コード 1 となる。
- AC-005: 実行結果に task ごとの PASS/FAIL サマリが含まれる。

## 5. テスト要件 (Test Requirements / テスト要件) [空欄禁止]

### 5.1 Unit Test (Unit Test / 単体テスト) [空欄禁止]

- 対象: パラメータセット分岐
- 観点: `-TaskId` / `-TaskIds` / `-AllTasks` が競合なく動作する
- 合格条件: 想定外組み合わせを拒否し、正しい分岐で実行される

### 5.2 Integration Test (Integration Test / 結合テスト) [空欄禁止]

- 対象: 複数 task 検査実行
- 観点: 各 task の検査結果集計と終了コード
- 合格条件: 失敗を含むと終了コード 1 になる

### 5.3 Regression Test (Regression Test / 回帰テスト) [空欄禁止]

- 対象: 既存単一 task 検査
- 観点: 現行 CI 手順が壊れない
- 合格条件: `-TaskId` モードで従来と同結果

### 5.4 Manual Verification (Manual Verification / 手動検証) [空欄禁止]

- 手順:
  1. `-TaskId` で 1 task を検査
  2. `-TaskIds` で 2 task を検査
  3. `-AllTasks` で全 task を検査
- 期待結果: AC-001〜AC-005 を満たす

## 6. 影響範囲 [空欄禁止]

- 影響ファイル/モジュール:
  - `tools/consistency-check/check.ps1`
  - `.github/workflows/ci-framework.yml`
- 影響する仕様:
  - `docs/specs/automation-tools-design-spec.md`
  - `docs/specs/automation-tools-ci-integration-spec.md`
- 非機能影響:
  - 実行時間が増加する可能性がある

## 7. 制約とリスク [空欄禁止]

- 制約: PowerShell 実装を維持する
- 想定リスク: `-AllTasks` で古い未整備 task による失敗が増える
- 回避策: 除外対象ルールまたは baseline task の整備方針を定義する

## 8. 未確定事項 [空欄禁止]

- `-AllTasks` の除外条件（archived / disabled task など）

## 9. 関連資料リンク [空欄禁止]

- request: `work/2026-02-18__consistency-check-multi-task-mode/request.md`
- investigation: `work/2026-02-18__consistency-check-multi-task-mode/investigation.md`
- plan: `work/2026-02-18__consistency-check-multi-task-mode/plan.md`
- review: `work/2026-02-18__consistency-check-multi-task-mode/review.md`
- docs:
  - `docs/specs/automation-tools-design-spec.md`
  - `docs/specs/automation-tools-ci-integration-spec.md`
