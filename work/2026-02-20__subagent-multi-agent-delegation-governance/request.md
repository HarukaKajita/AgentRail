# Request: 2026-02-20__subagent-multi-agent-delegation-governance

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `docs/operations/skills-framework-flow-guide.md`
  - `docs/operations/framework-request-to-commit-visual-guide.md`
- 理解ポイント:
  - 既存フローを維持しつつ、subagent / multi_agent 活用を標準工程へ組み込む。

## 要望の原文

- 各工程で subagent/multi_agent を積極的に使用するようにスキルを改善したい。
- subagent/multi_agent へ必要コンテキストを渡し、工程対応の md ファイルへ結果を記載して親側に返却する流れにしたい。
- ただし品質低下懸念のある工程は例外化したい。

## 要望分析

- 直要求:
  - subagent / multi_agent 前提の工程運用を仕様化する。
  - 依頼コンテキスト・成果物・返却フォーマットを定義する。
  - 品質低下リスクが高い工程を例外化する。
- 潜在要求:
  - 並列化によるスループット向上。
  - 役割分担を明示して再現性を高める。
  - サブエージェント活用時も品質責任の所在を明確化する。
- 非要求:
  - 本タスク内で全スキル実装を完了すること。
  - CI での自動検査ロジック追加まで即時完了すること。

## 提案オプション

1. 全工程強制委譲:
   - すべての工程で必ず subagent / multi_agent を使う。
2. リスク例外つき標準委譲（推奨）:
   - 原則委譲、ただし高リスク工程は親エージェント固定とする。
3. 任意運用:
   - 推奨のみで強制しない。

## 推奨案

- 推奨: 2. リスク例外つき標準委譲
- 採用理由:
  - 生産性と品質を両立できる。
  - 品質責任を親エージェントに残しつつ、並列化の利点を活かせる。
- 非採用理由:
  - 1 は品質事故時の影響が大きい。
  - 3 は運用ぶれが残り、改善効果が限定される。

## 確認質問

- なし（要件確定段階で十分に方針が明確）。

## 依存関係整理

- depends_on 候補:
  - `2026-02-19__task-dependency-aware-prioritization-flow`
  - `2026-02-19__task-commit-boundary-automation-flow`
  - `2026-02-19__task-doc-prerequisite-knowledge-section`
- 不足依存:
  - なし

## 成功条件（要望レベル）

1. `work/2026-02-20__subagent-multi-agent-delegation-governance/` に必須6ファイルが作成される。
2. `spec.md` に委譲対象・例外工程・品質ゲートが検証可能な形で定義される。
3. `docs/operations/high-priority-backlog.md` に planned として優先登録される。
