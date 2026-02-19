# Request: 2026-02-19__existing-docs-prerequisites-retrofit

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `work/2026-02-19__task-doc-prerequisite-knowledge-section/spec.md`
  - `docs/operations/high-priority-backlog.md`
- 理解ポイント:
  - 前提知識セクション標準化の運用要件は定義済みであり、本タスクは既存資料への遡及適用が対象である。

## 要望の原文

- 「前提知識セクションを資料に追加する仕様を実装したが、既存資料にはまだ追加していないのではないか」
- 「起票して要件確定までして優先順で進めて」

## 要望分析

- 直要求:
  - 既存資料への前提知識セクション遡及適用タスクを起票する。
  - request・investigation・spec を確定し、実装着手可能な状態にする。
  - 高優先バックログ上で優先順位を明示する。
- 潜在要求:
  - 既存資料をどこから読んでも遡って理解できる状態に統一する。
  - 優先順に実施して大規模更新のリスクを分割管理する。
- 非要求:
  - 本タスク内で既存資料全件の実更新を完了すること。
  - archive/legacy の履歴資料まで一括適用すること。

## 提案オプション

1. 最小適用:
   - planned / in_progress / blocked の active task 文書だけを対象にする。
2. バランス適用（推奨）:
   - `docs/`（archive/legacy 除く）と `work/` の task 文書（archive/legacy 除く）を優先度付きで段階適用する。
3. 全量一括適用:
   - archive/legacy を含む全 markdown へ一括で前提知識セクションを追加する。

## 推奨案

- 推奨: 2. バランス適用
- 採用理由:
  - 読解導線の改善効果を最大化しつつ、差分量をフェーズ分割で管理できる。
  - 既存 checker 運用との整合（active task 必須）を保ちながら対象を拡張できる。
- 非採用理由:
  - 1 は既存 docs の未整備が残り、要望達成が不十分。
  - 3 は履歴資料改変のコストとリスクが大きい。

## 確認質問

- なし（本タスクは要件確定までを優先し、実装時の詳細順序は plan で確定する）。

## 依存関係整理

- depends_on 候補:
  - `2026-02-19__task-doc-prerequisite-knowledge-section`（前提知識セクション標準仕様）
- 不足依存:
  - なし

## 成功条件（要望レベル）

1. `work/2026-02-19__existing-docs-prerequisites-retrofit/` に必須6ファイルが作成される。
2. `spec.md` に優先度付きの適用対象・受入条件・テスト要件が確定する。
3. `docs/operations/high-priority-backlog.md` で `planned` タスクとして優先順に登録される。
