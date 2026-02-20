# 仕様書: 2026-02-20__bootstrap-onboarding-doc-tasks-for-existing-repo

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `docs/operations/runtime-framework-rules.md`
  - `docs/operations/runtime-installation-runbook.md`
  - `tools/runtime/install-runtime.ps1`
  - `tools/consistency-check/check.ps1`
- 理解ポイント:
  - 「高度な情報整理」は AI が得意だが、スクリプトに意思決定を混ぜると再現性が落ちる。
  - 収集（決定なし）/ 提案（高性能モデル + 人間確認）/ 適用（決定なし）に分離して運用する。

## 1. メタ情報 (Metadata) (必須)

- Task ID: 2026-02-20__bootstrap-onboarding-doc-tasks-for-existing-repo
- タイトル: 既存リポジトリ導入時の資料棚卸し・タスク起票ブートストラップ
- 作成日: 2026-02-20
- 更新日: 2026-02-20
- 作成者: codex
- 関連要望: `work/2026-02-20__bootstrap-onboarding-doc-tasks-for-existing-repo/request.md`

## 2. 背景と目的 (Background & Objectives) (必須)

- 背景:
  - 既存プロジェクトへ AgentRail runtime を導入しても「何の資料が不足しているか」「どの順でタスク化すべきか」はプロジェクト依存で判断が難しい。
  - 一方で、その判断ができないと AgentRail の workflow に乗せて開発を開始できない（整合性が崩れやすい）。
- 目的:
  - 既存リポジトリ全体の棚卸し結果を、AI が整理しやすい形式で収集できるようにする。
  - 整理結果（提案）を work/backlog/MEMORY へ再現可能に反映し、AgentRail に沿った開発の起点を作る。

## 3. スコープ (Scope) (必須)

### 3.1 In Scope (必須)

- 収集スクリプトを追加する:
  - 例: tools/onboarding/collect-existing-repo-context.ps1
  - 出力: artifacts/onboarding/context.md と artifacts/onboarding/context.json（いずれか、または両方）
- 適用スクリプトを追加する:
  - 例: tools/onboarding/apply-task-proposals.ps1
  - 入力: artifacts/onboarding/task-proposals.json
  - 出力: `work/<task-id>/*`（必須6ファイル）と `docs/operations/high-priority-backlog.md` / `MEMORY.md` 更新
- 収集 -> 提案 -> 適用の運用手順（導入者向け）を docs に追加する（ファイル名は実装時に確定する）。

### 3.2 Out of Scope (必須)

- AI による提案そのものをスクリプト内で自動実行すること（API鍵・課金・意思決定が絡むため分離する）。
- 導入先プロジェクトのプロダクトコードや既存ドキュメントを自動で改変すること（提案は可、適用は別タスク化）。

## 4. 受入条件 (Acceptance Criteria) (必須)

- AC-001: 収集スクリプトが既存リポジトリをスキャンし、AI/人間が判断できる最小セットの context を生成できる（決定を含まない）。
- AC-002: 適用スクリプトが提案 JSON を読み、work/backlog/MEMORY を生成・更新し、生成されたタスク群が `consistency-check` / `state-validate` を PASS できる。

## 5. テスト要件 (Test Requirements) (必須)

### 5.1 単体テスト (Unit Test) (必須)

- **対象**: `tools/onboarding/*`
- **検証項目**: 入力パスや必須ファイル不足時に安全に FAIL し、エラーメッセージが再現可能である
- **合格基準**:
  - `-DryRun` 相当の実行でファイル作成を行わず、計画（PLAN）が出力される

### 5.2 結合テスト (Integration Test) (必須)

- **対象**: ダミー導入先ディレクトリ（最小の `project.profile.yaml` と `docs/` seed を含む）
- **検証項目**: 収集 ->（提案JSON配置）-> 適用の一連で work/backlog/MEMORY が生成される
- **合格基準**:
  - 生成後に `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId <generated-task-id> -DocQualityMode warning` が PASS

### 5.3 回帰テスト (Regression Test) (必須)

- **対象**: AgentRail runtime の既存ツール群
- **検証項目**: 既存の export/install や validator の挙動を壊さない
- **合格基準**:
  - `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check` が PASS
  - `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks -DocQualityMode warning` が PASS

### 5.4 手動検証 (Manual Verification) (必須)

- **検証手順**:
  1. 既存プロジェクトへ runtime を導入する（`docs/operations/runtime-installation-runbook.md` を参照）
  2. 収集スクリプトを実行し、context が出力されることを確認する
  3. 高性能モデルで提案 JSON を生成し、適用スクリプトでタスクが起票されることを確認する
- **期待される結果**:
  - 導入直後に「やるべき資料整備」がタスクとして一覧化され、AgentRail workflow の起点ができる

## 6. 影響範囲 (Impact Assessment) (必須)

- 影響ファイル/モジュール:
  - `tools/onboarding/*`（新規）
  - `docs/operations/high-priority-backlog.md`（運用導線）
  - `MEMORY.md`（次アクション）
- 影響する仕様:
  - `docs/operations/runtime-framework-rules.md`
  - `docs/operations/runtime-installation-runbook.md`
- 非機能影響:
  - 大規模リポジトリでも安全に走るよう、収集量（深さ・サイズ）と出力を制御する必要がある

## 7. 制約とリスク (Constraints & Risks) (必須)

- 制約:
  - 外部導入先では追加依存なし（PowerShell 標準）で動作させる。
  - API鍵やネットワーク前提の自動判断をスクリプトへ埋め込まない（決定は AI + 人間確認へ分離）。
- 想定リスク:
  - context が過多/過少で、提案品質が不安定になる。
  - 適用スクリプトが過剰にファイルを生成し、差分がノイズ化する。
- 回避策:
  - context 出力は構造化（JSON）+ 人間可読（MD）の二重化を基本とし、サイズ制限やサンプリングを設ける。
  - 適用は `-DryRun` を必須にし、生成物は allowlist 的に限定する。

## 8. 未確定事項 (Open Issues) (必須)

- 提案 JSON の optional 項目（例: 既存 docs の move 方針や、優先度の細分化）をどこまで許容するか。
- 「高度な情報整理」に使うモデル選定ポリシーの記述場所（docs と profile のどちらを正本にするか）。

## 9. 関連資料リンク (Reference Links) (必須)

- request: `work/2026-02-20__bootstrap-onboarding-doc-tasks-for-existing-repo/request.md`
- investigation: `work/2026-02-20__bootstrap-onboarding-doc-tasks-for-existing-repo/investigation.md`
- plan: `work/2026-02-20__bootstrap-onboarding-doc-tasks-for-existing-repo/plan.md`
- review: `work/2026-02-20__bootstrap-onboarding-doc-tasks-for-existing-repo/review.md`
- docs:
  - `docs/operations/runtime-framework-rules.md`
  - `docs/operations/runtime-installation-runbook.md`
  - `docs/operations/framework-request-to-commit-visual-guide.md`
  - `docs/operations/onboarding-task-proposals-json-format.md`
