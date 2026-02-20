# Request: 2026-02-20__bootstrap-onboarding-doc-tasks-for-existing-repo

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/runtime-framework-rules.md`
  - `docs/operations/runtime-installation-runbook.md`
  - `docs/operations/framework-request-to-commit-visual-guide.md`
  - `docs/operations/high-priority-backlog.md`
- 理解ポイント:
  - 既存リポジトリへ AgentRail runtime を導入した直後は「何を資料化すべきか」「どの順でタスク化すべきか」が不明確になりやすい。
  - この要望は、導入直後にプロジェクト全体を棚卸しし、必要資料の作成タスクへ落とし込むオンボーディング支援を追加するもの。

## 要望の原文

- 既存のプロジェクトに AgentRail を導入する際に、プロジェクト全体を確認して、作成するべき資料をリストアップしてタスク化する機能を追加したい。
- 既存の実装を基に、資料を作成して整合性を保ってから AgentRail に沿った開発を進められるようにする為に必須。
- 高度な情報整理能力が求められるので、それに適したモデルで実行されるようにしたい。

## 要望分析

- 直要求:
  - 既存リポジトリの現状をスキャンし、作成すべき資料候補を列挙できる。
  - 列挙結果をタスク化し、AgentRail の `work/` と backlog/MEMORY を整合させられる。
- 潜在要求:
  - 「高度な情報整理」はルールベースだけでは限界があるため、AI（高性能モデル）を前提にした安全な分業（収集 -> 提案 -> 適用）フローが必要。
  - 導入先でも `consistency-check` / `state-validate` / `docs-indexer` を回せる状態に早期到達したい。
- 非要求:
  - 導入先プロジェクトのアプリ/プロダクト実装を勝手に変更すること。
  - リポジトリ固有の意思決定を自動で確定すること（提案と確認を優先する）。

## 成功条件（要望レベル）

1. 既存リポジトリの情報を安全に収集し、オンボーディング用の「資料作成/整備」タスクリストを生成できる。
2. 生成された提案（人間 or AI による）を、work/backlog/MEMORY へ機械的に反映できる。
3. 情報整理フェーズは高性能モデルで実行しやすい形（入力束ね・出力形式固定）になる。

## blocked 判定

- depends_on はなし。`plan-ready` で起票する。

