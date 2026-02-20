# Existing Repo Onboarding: Document Inventory Runbook

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `docs/operations/runtime-installation-runbook.md`
  - `docs/operations/onboarding-task-proposals-json-format.md`
  - `docs/operations/high-priority-backlog.md`
- 理解ポイント:
  - 収集（決定なし）/ 提案（高性能モデル + 人間確認）/ 適用（決定なし）に分離して、再現可能性を維持する。


## 1. 目的

- AgentRail runtime を既存リポジトリへ導入した直後に、「作成/更新/移動/削除すべき docs」を棚卸しし、タスクとして起票できる状態にする。

## 2. 事前条件

1. 既存リポジトリへ runtime 導入が完了している（`docs/operations/runtime-installation-runbook.md`）。
2. `project.profile.yaml` の `workflow.task_root` / `workflow.docs_root` が正しい。

## 3. 手順（Step-by-step）

### 3.1 Context 収集（決定なし）

1. 導入先リポジトリのルートへ移動する。
2. 収集スクリプトを `-DryRun` で実行し、出力先を確認する。

```powershell
pwsh -NoProfile -File tools/onboarding/collect-existing-repo-context.ps1 `
  -RepoRoot . `
  -OutputDir artifacts/onboarding `
  -DryRun
```

3. Dry-Run の出力が妥当なら通常実行し、`artifacts/onboarding/context.json` / `context.md` を生成する。

```powershell
pwsh -NoProfile -File tools/onboarding/collect-existing-repo-context.ps1 `
  -RepoRoot . `
  -OutputDir artifacts/onboarding
```

期待結果:
- `artifacts/onboarding/context.json` / `artifacts/onboarding/context.md` が生成される。

### 3.2 提案 JSON 生成（高性能モデル + 人間確認）

1. `artifacts/onboarding/context.json` と `context.md` を入力として、提案 JSON（Pattern B）を作成する。
2. 出力は `docs/operations/onboarding-task-proposals-json-format.md` に従い、`task_id` は提案 JSON 側で固定する。
3. 生成後、必ず人間がレビューし、依存関係（`depends_on`）と docs 操作（`doc_actions`）が妥当か確認する。

期待結果:
- `artifacts/onboarding/task-proposals.json` が作成される。

### 3.3 提案の適用（決定なし）

1. `-DryRun` で PLAN を確認する（ファイルは生成しない）。

```powershell
pwsh -NoProfile -File tools/onboarding/apply-task-proposals.ps1 `
  -RepoRoot . `
  -ProposalsPath artifacts/onboarding/task-proposals.json `
  -DryRun
```

2. PLAN が妥当なら適用する（`work/*`、`docs/operations/high-priority-backlog.md`、`MEMORY.md`、`docs/INDEX.md` を更新する）。

```powershell
pwsh -NoProfile -File tools/onboarding/apply-task-proposals.ps1 `
  -RepoRoot . `
  -ProposalsPath artifacts/onboarding/task-proposals.json `
  -Owner unassigned
```

期待結果:
- `work/<task-id>/{request,investigation,spec,plan,review,state.json}` が生成される。
- `docs/operations/high-priority-backlog.md` に planned タスクが追加される。
- `docs/INDEX.md` が filesystem と同期される（docs-indexer apply）。

### 3.4 検証（導入先で PASS を確認）

起票後に、最低限次を実行する。

```powershell
pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check
pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks -DocQualityMode warning
```

期待結果:
- `docs-indexer: PASS`
- `consistency-check: PASS`

## 4. 以降の進め方

1. `docs/operations/high-priority-backlog.md` の最上位 `plan-ready` タスクから着手する。
2. 各タスクは `AGENTS.md` の固定ワークフロー（request -> investigation -> spec -> plan-draft -> gate -> plan-final -> implementation）で進行する。

## 5. 関連資料リンク

- docs:
  - `docs/operations/runtime-installation-runbook.md`
  - `docs/operations/onboarding-task-proposals-json-format.md`
  - `docs/operations/high-priority-backlog.md`
- tools:
  - `tools/onboarding/collect-existing-repo-context.ps1`
  - `tools/onboarding/apply-task-proposals.ps1`

