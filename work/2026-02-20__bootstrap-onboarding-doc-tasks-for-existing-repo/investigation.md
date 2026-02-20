# 調査: 2026-02-20__bootstrap-onboarding-doc-tasks-for-existing-repo

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `framework.runtime.manifest.yaml`
  - `docs/operations/runtime-framework-rules.md`
  - `docs/operations/runtime-installation-runbook.md`
  - `tools/runtime/install-runtime.ps1`
  - `tools/consistency-check/check.ps1`
- 理解ポイント:
  - runtime 導入直後の外部リポジトリには、AgentRail の基本ツールと最小 docs seed はあるが、プロジェクト固有の資料整備は未着手。

## 1. 調査対象 [空欄禁止]

- 既存実装（runtime export/install、docs seed、consistency/state validate）を前提に、導入直後のオンボーディングを支援する「棚卸し -> 提案 -> タスク化」機能をどう追加するか。

## 2. 仮説 (Hypothesis / 仮説) [空欄禁止]

- 仮説:
  - 「高度な情報整理」は AI に任せ、スクリプトは決定を含めずに次の 3 工程へ分割すると運用が安定する。
    1. 収集: 既存リポジトリ全体から、判断に必要な情報をロス少なく束ねる（安全で決定なし）。
    2. 提案: 収集結果を入力に、高性能モデルで「作成すべき資料」と「起票すべきタスク」を構造化出力する（人間確認を挟む）。
    3. 適用: 提案 JSON を読み、work/backlog/MEMORY を機械的に生成・更新する（決定なしで再現可能）。

## 3. 調査方法 (Observation Method / 観測方法) [空欄禁止]

- 参照資料:
  - `framework.runtime.manifest.yaml`（外部導入物の範囲）
  - `tools/runtime/install-runtime.ps1`（導入時に何が更新されるか）
  - `docs/templates/*`（task docs の形）
  - `tools/consistency-check/check.ps1`（整合性の判定条件）
- 実施した確認:
  - runtime は `docs/templates` と最小限の `docs/` seed（`docs/INDEX.md`、`docs/README.md`、`docs/operations/high-priority-backlog.md`）を導入する。
  - 既存の自動起票スクリプトは `tools/improvement-harvest/create-task.ps1` があるが、改善 finding 前提のため汎用オンボーディング起票にはそのまま適用しにくい。

## 4. 調査結果 (Observations / 観測結果) [空欄禁止]

- 外部導入直後の最短ゴールは「資料整備をタスク化し、AgentRail の workflow（request->investigation->spec->plan）に乗せる」だが、現状はその“タスクの種”を作る導線がない。
- `tools/runtime/install-runtime.ps1` は導入先の `project.profile.yaml` を更新し、workflow.task_root を `.agentrail/work`、workflow.runtime_root を `.agentrail` に寄せる（導入後のパス解決は profile 起点で統一できる）。
- `consistency-check` / `state-validate` は work/docs の整合をチェックできるため、オンボーディング起票もこの検証に乗せるのが合理的。

## 5. 結論 (Conclusion / 結論) [空欄禁止]

- 機能追加は「AI 前提の情報整理」と「機械的な反映」を分離して設計するのが最も安全で再現性が高い。
- 実装の中心は次の 2 スクリプト + 1 運用 docs になる。
  - 収集: tools/onboarding/collect-existing-repo-context.ps1（既存リポジトリをスキャンして context を生成）
  - 適用: tools/onboarding/apply-task-proposals.ps1（提案 JSON から work/backlog/MEMORY を生成）
  - 運用:（高性能モデルでの提案生成の手順と出力フォーマットを固定する docs）

## 6. 未解決事項 [空欄禁止]

- 提案 JSON のスキーマ（最低限: title/description/priority/depends_on/task_id 命名の扱い）をどこまで厳格化するか。
- 既存プロジェクトに “既に docs がある” 場合の扱い（既存 docs の再配置・リンク整備を提案に含めるか）。
- 生成するタスク ID の粒度（1ファイル=1タスク/カテゴリ単位/段階（Wave）単位）。

## 7. 次アクション [空欄禁止]

1. 受入条件として「収集」「適用」「検証」を分離した AC/テスト要件を `spec.md` に確定する。
2. `plan.md` の `plan-draft` に、実装順序と検証手順（収集->提案->適用）を明記する。

## 8. 関連リンク [空欄禁止]

- request: `work/2026-02-20__bootstrap-onboarding-doc-tasks-for-existing-repo/request.md`
- spec: `work/2026-02-20__bootstrap-onboarding-doc-tasks-for-existing-repo/spec.md`
