# Request: 2026-02-20__plan-draft-before-kickoff-commit-flow

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `docs/operations/framework-request-to-commit-visual-guide.md`
  - `docs/operations/skills-framework-flow-guide.md`
- 理解ポイント:
  - 起票境界コミットの前提として `plan-draft` を先に確定する運用へ統一する。

## 要望の原文

- 起票コミットの前に plan-draft があるのと、後に plan-draft があるのはどちらが良いか。
- 「plan-draft を先に作って起票コミットに含める」方針に修正したい。
- その方針に修正するタスクを起票し、コミット後に実装まで進めてほしい。

## 要望分析

- 直要求:
  - `plan-draft` を起票境界コミットより前に置くフローへ修正する。
  - 既存資料の前後関係不整合を解消する。
- 潜在要求:
  - 依存解決や計画の判断根拠を起票コミット時点で固定する。
  - 起票後に計画が増えることで履歴が分裂するリスクを下げる。
- 非要求:
  - 外部 PM ツール連携。
  - CI 実行基盤の大規模改修。

## 提案オプション（3案）

1. 現行維持:
   - `request / investigation / spec` のみで kickoff し、その後に `plan-draft` を作る。
2. `plan-draft` 先行（採用）:
   - `request / investigation / spec / plan-draft` を確定してから kickoff する。
3. `plan-final` 先行:
   - 依存ゲート前に final 計画まで確定して kickoff する。

## 推奨案

- 採用: オプション2（`plan-draft` 先行）
- 採用理由:
  - 起票時点で依存調査の前提計画が固定され、判断根拠を追跡しやすい。
  - `plan-final` は gate pass 後のため、draft と final の役割分離が維持される。
- 非採用理由:
  - オプション1は履歴が分断される。
  - オプション3は依存未解決時の手戻りを増やす。

## 依存関係整理

- depends_on:
  - `2026-02-19__task-commit-boundary-automation-flow`
  - `2026-02-19__task-dependency-aware-prioritization-flow`
  - `2026-02-20__dependency-gate-before-plan-flow`
- 不足依存:
  - なし（すべて done）

## 成功条件（要望レベル）

1. フロー資料で `plan-draft -> kickoff commit -> depends_on gate -> plan-final` の順序が明確化される。
2. 起票境界コミットの定義に `plan-draft` 先行が明示される。
3. task 資料・backlog・memory の整合が保たれた状態で実装完了できる。

## blocked 判定

- blocked ではない。
