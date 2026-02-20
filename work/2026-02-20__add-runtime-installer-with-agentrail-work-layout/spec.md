# 仕様書: 2026-02-20__add-runtime-installer-with-agentrail-work-layout

## 記入ルール

- `[空欄禁止]` セクションは必ず記入する。
- N/A を使う場合は理由を明記する。
- 受入条件とテスト要件は 1 対 1 で対応付ける。

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `work/2026-02-20__add-runtime-installer-with-agentrail-work-layout/request.md`
  - `work/2026-02-20__add-runtime-installer-with-agentrail-work-layout/investigation.md`
- 理解ポイント:
  - 単一リポジトリ方針を維持し、外部利用への分離強化を優先する。

## 1. メタ情報 [空欄禁止]

- Task ID: 2026-02-20__add-runtime-installer-with-agentrail-work-layout
- タイトル: .agentrail/work 前提の runtime インストーラ導入
- 作成日: 2026-02-20
- 更新日: 2026-02-20
- 作成者: codex
- 関連要望: work/2026-02-20__add-runtime-installer-with-agentrail-work-layout/request.md

## 2. 背景と目的 [空欄禁止]

- 背景: 外部利用時に framework 開発資産と runtime 必要資産が混在する。
- 目的: 外部利用時の成果物を .agentrail/work に統一し、導入をスクリプト化する。

## 3. スコープ [空欄禁止]

### 3.1 In Scope [空欄禁止]

- tools/runtime/install-runtime.ps1 の追加
- .agentrail/work を既定 task_root とする導入フロー
- project.profile.yaml の runtime_root/task_root 拡張

### 3.2 Out of Scope [空欄禁止]

- 既存全ツールのパス解決改修
- package レジストリ配布

## 4. 受入条件 (Acceptance Criteria / 受入条件) [空欄禁止]

- AC-001: `tools/runtime/install-runtime.ps1` が追加され、runtime 配布物を導入先へ展開できる。
- AC-002: installer 実行時に `.agentrail/work` が作成され、導入先 `project.profile.yaml` の `workflow.task_root` が `.agentrail/work` に調整される。
- AC-003: installer の dry-run が提供され、上書き対象ファイルと生成ディレクトリを事前確認できる。

## 5. テスト要件 (Test Requirements / テスト要件) [空欄禁止]

### 5.1 Unit Test (Unit Test / 単体テスト) [空欄禁止]

- 対象: `tools/runtime/install-runtime.ps1` の引数解析・profile 更新ロジック
- 観点: `-DryRun` で計画のみ出力し、`-TargetRoot` に対する相対パス処理が正しく行われる
- 合格条件: dry-run 実行でエラーなく計画を表示する

### 5.2 Integration Test (Integration Test / 結合テスト) [空欄禁止]

- 対象: `tools/runtime/export-runtime.ps1` + `tools/runtime/install-runtime.ps1`
- 観点: runtime 生成物を一時導入先へ展開し、`.agentrail/work` と profile 更新が成立する
- 合格条件: 一時導入先で `.agentrail/work` と更新済み `project.profile.yaml` を確認できる

### 5.3 Regression Test (Regression Test / 回帰テスト) [空欄禁止]

- 対象: 既存の work と docs 運用フロー
- 観点: 従来の task チェック・CI チェックを壊さない
- 合格条件: `tools/state-validate/validate.ps1` と `tools/consistency-check/check.ps1` が対象 task で PASS する

### 5.4 Manual Verification (Manual Verification / 手動検証) [空欄禁止]

- 手順: 一時ディレクトリを導入先にして installer の dry-run → apply を実行する
- 期待結果: AC-001 / AC-002 / AC-003 を満たす

## 6. 影響範囲 [空欄禁止]

- 影響ファイル/モジュール: task 目的に関係する tools, README.md, AGENTS.md, docs/operations
- 影響する仕様: 分離運用、導入手順、パス解決規約
- 非機能影響: 外部導入の再現性と保守性が向上する

## 7. 制約とリスク [空欄禁止]

- 制約: 単一リポジトリ構成を維持する
- 想定リスク:
  - 既存利用者のパス前提と衝突する
  - インストール先競合時に上書き事故が起きる
- 回避策: 段階タスク化と depends_on gate により変更影響を局所化する

## 8. 未確定事項 [空欄禁止]

- package 化の実施タイミングは未定。移行は別 task で判断する。

## 9. 関連資料リンク [空欄禁止]

- request: work/2026-02-20__add-runtime-installer-with-agentrail-work-layout/request.md
- investigation: work/2026-02-20__add-runtime-installer-with-agentrail-work-layout/investigation.md
- plan: work/2026-02-20__add-runtime-installer-with-agentrail-work-layout/plan.md
- review: work/2026-02-20__add-runtime-installer-with-agentrail-work-layout/review.md
- docs:
  - `docs/operations/high-priority-backlog.md`
  - `docs/operations/runtime-installation-runbook.md`

