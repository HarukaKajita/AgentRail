# MEMORY

このファイルはセッション圧縮や担当交代時の引き継ぎ用メモです。  
各チェックポイント（要件確定、実装開始前、レビュー完了後）で更新してください。

## 1. 現在のタスク

- Task ID: 2026-02-19__task-doc-prerequisite-knowledge-section
- タイトル: Task and Spec Docs Prerequisite Knowledge Section Standardization
- 状態: planned
- 最終更新日時: 2026-02-19T19:27:25+09:00
- 担当: codex

## 2. 今回の目的

- 仕様資料と task 資料に前提知識セクションを導入する要件を task として起票する。
- どの資料からでも参照を遡って理解できる導線を、受入条件とテスト要件として確定する。
- 起票完了後に差分をコミットする。

## 3. 完了済み

- `work/2026-02-19__task-doc-prerequisite-knowledge-section/` を作成し、必須6ファイル（request/investigation/spec/plan/review/state）を作成した。
- `investigation.md` で templates、起票生成、consistency-check の現状を調査し、前提知識セクション未整備を確認した。
- `spec.md` で AC-001〜AC-005 とテスト要件（Unit/Integration/Regression/Manual）を確定した。
- `docs/operations/high-priority-backlog.md` に本タスクを `planned` の優先タスクとして追加した。

## 4. 重要な意思決定

- 日付: 2026-02-19
- 決定内容: 前提知識セクションは docs/work の標準フォーマットとして定義し、参照を遡れる記法を必須化する。
- 決定内容: 起票生成と consistency-check の両面で前提知識セクション運用を強制する方針を採用する。
- 根拠資料:
  - `docs/templates/spec.md`
  - `tools/improvement-harvest/create-task.ps1`
  - `tools/consistency-check/check.ps1`
  - `work/2026-02-19__task-doc-prerequisite-knowledge-section/spec.md`

## 5. 未解決・ブロッカー

- なし

## 6. 次アクション

1. 前提知識セクションの標準スキーマ（見出し、必須項目、記法）を決定してテンプレートへ反映する。
2. 起票生成と consistency-check に前提知識セクション要件を実装する。
3. active docs/work への遡及更新を実施し、`review.md` と `state.json` を完了状態へ更新する。

## 7. 参照先

- `work/2026-02-19__task-doc-prerequisite-knowledge-section/request.md`
- `work/2026-02-19__task-doc-prerequisite-knowledge-section/investigation.md`
- `work/2026-02-19__task-doc-prerequisite-knowledge-section/spec.md`
- `work/2026-02-19__task-doc-prerequisite-knowledge-section/plan.md`

## 8. 引き継ぎ時チェック

- [x] `state.json` が最新か
- [x] `docs/INDEX.md` を更新済みか（既存導線ファイル更新のため追加不要）
- [x] 次アクションが実行可能な粒度か
