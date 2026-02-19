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
- 品質懸念を受けて方針変更:
  - `request / investigation / spec / plan-draft` までを単一 subagent/multi_agent に任せる。
  - 親が再検討して問題ない場合のみ次工程とコミットを許可する。

## 要望分析

- 直要求:
  - 委譲範囲を `request / investigation / spec / plan-draft` に限定して仕様化する。
  - 4工程を単一委譲エージェントで処理する契約を定義する。
  - 親再検討 `pass` 前の kickoff commit 実行を禁止する。
  - 親再検討 `pass` 前の次工程着手とコミット禁止を定義する。
- 潜在要求:
  - 並列化によるスループット向上。
  - 役割分担を明示して再現性を高める。
  - サブエージェント活用時も品質責任の所在を明確化する。
- 非要求:
  - 本タスク内で全スキル実装を完了すること。
  - CI での自動検査ロジック追加まで即時完了すること。

## 提案オプション

1. 4工程限定委譲（推奨）:
   - `request / investigation / spec / plan-draft` を単一委譲エージェントへ任せる。
2. 全工程強制委譲:
   - すべての工程で必ず subagent / multi_agent を使う。
3. 委譲停止:
   - 全工程を親エージェント固定に戻す。

## 推奨案

- 推奨: 1. 4工程限定委譲
- 採用理由:
  - 品質懸念のある下流工程を親固定にできる。
  - 上流4工程は委譲により初動速度を確保できる。
  - 親再検討を kickoff/コミット前提条件にできる。
- 非採用理由:
  - 2 は品質事故時の影響が大きい。
  - 3 は作業速度の改善効果が得られない。

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
2. `spec.md` に `request / investigation / spec / plan-draft` 限定委譲と親再検討ゲートが検証可能な形で定義される。
3. `docs/operations/high-priority-backlog.md` に planned として優先登録される。
