# Human-Centric Doc Bank Governance

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `README.md`
  - `docs/INDEX.md`
  - `work/2026-02-20__redesign-human-centric-doc-bank-governance/spec.md`
- 理解ポイント:
  - 本資料は「再現性 + 人間理解」を同時に満たすための運用ガバナンス定義である。

## 1. 目的

- フレームワーク目的を「再現可能な開発プロセスの維持」だけでなく「人間が現状を短時間で理解できる状態の維持」まで拡張する。
- docs を単なる履歴保管ではなく、実装判断・運用判断に直接使える資料バンクとして運用する。

## 2. 運用原則

1. 網羅性 (Coverage)
   - 主要機能ごとに `目的 / 使い方 / 仕組み / 実装ファイル / 関連機能 / 関連資料` を辿れること。
2. 鮮度 (Freshness)
   - 仕様変更・実装変更・運用変更のいずれでも、同一タスク内で docs 更新を完了させること。
3. 追跡性 (Traceability)
   - 変更は `work/<task-id>/` と `docs/*` を相互リンクし、根拠を辿れること。
4. 可読性 (Readability)
   - 前提知識、用語、影響範囲、次アクションを明記し、引き継ぎ可能な文脈を残すこと。

## 3. 情報モデル

- 各機能・各運用変更は、次の観点を最低 1 つ以上の資料で説明する。
  - 目的: 何のために存在するか
  - 使い方: 利用者/運用者の実行手順
  - 仕組み: 処理フローと依存関係
  - 実装ファイル: 主要ファイルと責務
  - 関連機能: 連動する仕組み
  - 関連資料: 参照すべき docs/work
- `docs/INDEX.md` は導線の正本とし、新規・更新資料へのリンクを必ず保持する。

## 4. 更新責務

1. task owner
   - `request/investigation/spec/plan/review/state` を更新し、受入条件とテスト結果を確定する。
2. implementation owner
   - 実装差分に対応する docs を同一タスクで更新し、`docs/INDEX.md` へ導線を反映する。
3. reviewer
   - AC とテスト要件の一致、依存整合、Process Findings の妥当性を確認する。

## 5. 品質ゲート

1. Gate A: plan-ready
   - `spec.md` 空欄禁止セクション充足
   - `plan.md` の `plan-draft` と `depends_on gate` が定義済み
2. Gate B: implementation-ready
   - `depends_on` 未解決がない
   - `plan-final` が確定し、検証順序が明記されている
3. Gate C: done
   - `review.md` に AC 判定とテスト結果が記録済み
   - `docs/INDEX.md` と関連 docs が更新済み
   - `MEMORY.md` と `state.json` が最新

## 6. 段階移行方針

1. Task A: `2026-02-20__redesign-human-centric-doc-bank-governance`
   - ガバナンス定義と運用原則を確定する。
2. Task B: `2026-02-20__plan-migration-to-human-centric-doc-bank`
   - 既存資産の移行計画（inventory/gap/rollout）を定義する。
3. 実行タスク群 (future)
   - Task B の wave 分割に従い、docs と検証ルールを段階適用する。

## 7. 検証コマンド

- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskIds 2026-02-20__redesign-human-centric-doc-bank-governance,2026-02-20__plan-migration-to-human-centric-doc-bank`
- `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__redesign-human-centric-doc-bank-governance`
- `pwsh -NoProfile -File tools/docs-indexer/index.ps1 -Mode check`

## 8. ロールバック方針

- 依存整合や品質ゲートに不整合が出た場合は、`work/<task-id>/plan.md` の gate 判定と backlog 記述を再同期する。
- docs 導線に不整合が出た場合は `docs/INDEX.md` を優先修正し、参照切れを解消してから state を更新する。
