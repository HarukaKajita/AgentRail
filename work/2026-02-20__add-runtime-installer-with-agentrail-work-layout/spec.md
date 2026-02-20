# 仕様書: 2026-02-20__add-runtime-installer-with-agentrail-work-layout

## 記入ルール

- `(必須)` セクションは必ず記入する。
- N/A を使う場合は理由を明記する。
- 受入条件とテスト要件は 1 対 1 で対応付ける。

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `work/2026-02-20__add-runtime-installer-with-agentrail-work-layout/request.md`
  - `work/2026-02-20__add-runtime-installer-with-agentrail-work-layout/investigation.md`
- 理解ポイント:
  - 単一リポジトリ方針を維持し、外部利用への分離強化を優先する。

## 1. メタ情報 (Metadata) (必須)

- Task ID: 2026-02-20__add-runtime-installer-with-agentrail-work-layout
- タイトル: .agentrail/work 前提の runtime インストーラ導入
- 作成日: 2026-02-20
- 更新日: 2026-02-20
- 作成者: codex
- 関連要望: work/2026-02-20__add-runtime-installer-with-agentrail-work-layout/request.md

## 2. 背景と目的 (Background & Objectives) (必須)

- 背景: 外部利用時に framework 開発資産と runtime 必要資産が混在する。
- 目的: 外部利用時の成果物を .agentrail/work に統一し、導入をスクリプト化する。

## 3. スコープ (Scope) (必須)

### 3.1 In Scope (必須)

- tools/runtime/install-runtime.ps1 の追加
- .agentrail/work を既定 task_root とする導入フロー
- project.profile.yaml の runtime_root/task_root 拡張

### 3.2 Out of Scope (必須)

- 既存全ツールのパス解決改修
- package レジストリ配布

## 4. 受入条件 (Acceptance Criteria) (必須)

- AC-001: `tools/runtime/install-runtime.ps1` が追加され、runtime 配布物を導入先へ展開できる。
- AC-002: installer 実行時に `.agentrail/work` が作成され、導入先 `project.profile.yaml` の `workflow.task_root` が `.agentrail/work` に調整される。
- AC-003: installer の dry-run が提供され、上書き対象ファイルと生成ディレクトリを事前確認できる。

## 5. テスト要件 (Test Requirements) (必須)

### 5.1 単体テスト (Unit Test) (必須)

- **対象**: `tools/runtime/install-runtime.ps1` の引数解析・profile 更新ロジック
- **検証項目**: `-DryRun` で計画のみ出力し、`-TargetRoot` に対する相対パス処理が正しく行われる
- **合格基準**: dry-run 実行でエラーなく計画を表示する

### 5.2 結合テスト (Integration Test) (必須)

- **対象**: `tools/runtime/export-runtime.ps1` + `tools/runtime/install-runtime.ps1`
- **検証項目**: runtime 生成物を一時導入先へ展開し、`.agentrail/work` と profile 更新が成立する
- **合格基準**: 一時導入先で `.agentrail/work` と更新済み `project.profile.yaml` を確認できる

### 5.3 回帰テスト (Regression Test) (必須)

- **対象**: 既存の work と docs 運用フロー
- **検証項目**: 従来の task チェック・CI チェックを壊さない
- **合格基準**: `tools/state-validate/validate.ps1` と `tools/consistency-check/check.ps1` が対象 task で PASS する

### 5.4 手動検証 (Manual Verification) (必須)

- **検証手順**: 一時ディレクトリを導入先にして installer の dry-run → apply を実行する
- **期待される結果**: AC-001 / AC-002 / AC-003 を満たす

## 6. 影響範囲 (Impact Assessment) (必須)

- 影響ファイル/モジュール: task 目的に関係する tools, README.md, AGENTS.md, docs/operations
- 影響する仕様: 分離運用、導入手順、パス解決規約
- 非機能影響: 外部導入の再現性と保守性が向上する

## 7. 制約とリスク (Constraints & Risks) (必須)

- 制約: 単一リポジトリ構成を維持する
- 想定リスク:
  - 既存利用者のパス前提と衝突する
  - インストール先競合時に上書き事故が起きる
- 回避策: 段階タスク化と depends_on gate により変更影響を局所化する

## 8. 未確定事項 (Open Issues) (必須)

- package 化の実施タイミングは未定。移行は別 task で判断する。

## 9. 関連資料リンク (Reference Links) (必須)

- request: work/2026-02-20__add-runtime-installer-with-agentrail-work-layout/request.md
- investigation: work/2026-02-20__add-runtime-installer-with-agentrail-work-layout/investigation.md
- plan: work/2026-02-20__add-runtime-installer-with-agentrail-work-layout/plan.md
- review: work/2026-02-20__add-runtime-installer-with-agentrail-work-layout/review.md
- docs:
  - `docs/operations/high-priority-backlog.md`
  - `docs/operations/runtime-installation-runbook.md`

