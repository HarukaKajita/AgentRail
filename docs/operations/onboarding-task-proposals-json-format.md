# Onboarding Task Proposals JSON Format

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/runtime-framework-rules.md`
  - `docs/operations/runtime-installation-runbook.md`
  - `work/2026-02-20__bootstrap-onboarding-doc-tasks-for-existing-repo/spec.md`
- 理解ポイント:
  - 提案生成は高性能モデル（人間確認を挟む）で行い、適用は決定を含めずに機械的に行う。
  - 既存プロジェクトの既存 docs も提案対象に含める（update/move を表現できる必要がある）。

## 1. 目的

- 既存リポジトリ導入時の「作成すべき資料のリストアップ -> タスク化」を、再現可能な入力（JSON）として固定する。
- `tools/onboarding/apply-task-proposals.ps1` が決定を持たずに work/backlog/MEMORY を生成できるようにする。

## 2. 設計原則

1. `task_id` は提案 JSON 側で固定する（適用側で命名の決定をしない）。
2. docs 操作は `create/update/move/delete` を表現できる。
3. 受入条件とテスト要件は、後続の `spec.md`/`plan.md` に落とし込み可能な粒度で持つ。
4. 安全のため、適用は `-DryRun` 前提で計画出力（PLAN）を確認できる設計にする。

## 3. 最小スキーマ（Pattern B / 推奨）

- `schema_version`:
  - 例: `1.0.0`
- `source_context`:
  - `repo_name`: 任意（例: `example-repo`）
  - `generated_at`: ISO 8601（例: `2026-02-20T23:30:00+09:00`）
- `proposals[]`:
  - `task_id`: `YYYY-MM-DD__...` 形式を推奨（必須）
  - `title`: 1行タイトル（必須）
  - `rationale`: 背景/意図（必須）
  - `priority`: `P0|P1|P2|P3`（必須）
  - `depends_on[]`: task_id 配列（必須、空配列可）
  - `doc_actions[]`（必須、空配列不可）:
    - `kind`: `create|update|move|delete`（必須）
    - `target`: `{ type: "docs", path: "docs/..." }`（必須）
    - `change_summary[]`: 変更点の箇条書き（必須、空配列可）
  - `deliverables[]`（必須、空配列可）:
    - `{ type: "work"|"docs"|"other", path: string }`
  - `acceptance_criteria[]`（必須、空配列不可）:
    - `{ id: "AC-001", text: string }`
  - `tests[]`（必須、空配列不可）:
    - `{ kind: "unit"|"integration"|"regression"|"manual", command_or_steps: string, pass_criteria: string }`

## 4. 例（最小）

```json
{
  "schema_version": "1.0.0",
  "source_context": {
    "repo_name": "example-repo",
    "generated_at": "2026-02-20T23:30:00+09:00"
  },
  "proposals": [
    {
      "task_id": "2026-02-20__onboarding-add-docs-index-and-runbook-links",
      "title": "Onboarding: docs 導線整備",
      "rationale": "既存 docs の配置はあるが、AgentRail の INDEX/運用資料への導線が不足しているため。",
      "priority": "P1",
      "depends_on": [],
      "doc_actions": [
        {
          "kind": "update",
          "target": { "type": "docs", "path": "docs/INDEX.md" },
          "change_summary": [
            "operations セクションへ runbook を追加",
            "新規 docs の導線を追加"
          ]
        }
      ],
      "deliverables": [
        { "type": "work", "path": "work/2026-02-20__onboarding-add-docs-index-and-runbook-links/*" }
      ],
      "acceptance_criteria": [
        { "id": "AC-001", "text": "docs/INDEX.md が導線を含む" }
      ],
      "tests": [
        {
          "kind": "regression",
          "command_or_steps": "pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check",
          "pass_criteria": "PASS"
        }
      ]
    }
  ]
}
```

## 5. 関連資料リンク

- docs:
  - `docs/operations/runtime-framework-rules.md`
  - `docs/operations/runtime-installation-runbook.md`
  - `docs/operations/high-priority-backlog.md`
- work:
  - `work/2026-02-20__bootstrap-onboarding-doc-tasks-for-existing-repo/spec.md`
  - `work/2026-02-20__bootstrap-onboarding-doc-tasks-for-existing-repo/plan.md`

