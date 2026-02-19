# MEMORY

このファイルはセッション圧縮や担当交代時の引き継ぎ用メモです。  
各チェックポイント（要件確定、実装開始前、レビュー完了後）で更新してください。

## 1. 現在のタスク

- Task ID: 2026-02-19__task-commit-boundary-automation-flow
- タイトル: Commit Boundary Automation Flow
- 状態: planned
- 最終更新日時: 2026-02-19T19:37:31+09:00
- 担当: codex

## 2. 今回の目的

- 起票後・実行後などの節目コミットを標準フローへ組み込み、差分混在を防ぐ要件を task として起票する。
- 単一task差分制約と混在検知の運用要件を確定する。
- 起票完了後に差分をコミットする。

## 3. 完了済み

- `work/2026-02-19__task-commit-boundary-automation-flow/` を作成し、必須6ファイル（request/investigation/spec/plan/review/state）を作成した。
- `investigation.md` でコミット境界が未標準化で、stage混在検知が未実装である現状を確認した。
- `spec.md` で AC-001〜AC-006 とテスト要件（Unit/Integration/Regression/Manual）を確定した。
- `docs/operations/high-priority-backlog.md` に本タスクを `planned` の優先タスクとして追加した。

## 4. 重要な意思決定

- 日付: 2026-02-19
- 決定内容: コミット境界は「起票後」「実装後」「完了後」の3段階を標準とする。
- 決定内容: 単一コミットに含む差分は単一taskに閉じることを原則とし、例外は記録必須とする。
- 決定内容: 境界ルールは docs だけでなく checker/skills でも検証可能にする。
- 根拠資料:
  - `AGENTS.md`
  - `docs/operations/framework-request-to-commit-visual-guide.md`
  - `docs/operations/skills-framework-flow-guide.md`
  - `work/2026-02-19__task-commit-boundary-automation-flow/spec.md`

## 5. 未解決・ブロッカー

- なし

## 6. 次アクション

1. コミット境界ルールと命名規則を docs/skills へ反映する。
2. 単一task差分制約の混在検知を checker または commit前検証へ実装する。
3. 境界コミット運用で review/state を完了状態へ更新する。

## 7. 参照先

- `work/2026-02-19__task-commit-boundary-automation-flow/request.md`
- `work/2026-02-19__task-commit-boundary-automation-flow/investigation.md`
- `work/2026-02-19__task-commit-boundary-automation-flow/spec.md`
- `work/2026-02-19__task-commit-boundary-automation-flow/plan.md`

## 8. 引き継ぎ時チェック

- [x] `state.json` が最新か
- [x] `docs/INDEX.md` を更新済みか（既存導線ファイル更新のため追加不要）
- [x] 次アクションが実行可能な粒度か
