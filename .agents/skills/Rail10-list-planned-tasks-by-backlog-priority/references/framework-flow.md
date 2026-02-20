# Framework Flow Guardrails

この資料は、スキルが AgentRail の固定ワークフローに従うための共通ガイド。

## 1. 固定ワークフロー順序

1. 要望整理 (`request.md`)
2. 調査 (`investigation.md`)
3. 要件確定 (`spec.md`)
4. 実装計画ドラフト (`plan-draft`)
5. 依存解決確認（depends_on gate）
6. 実装計画確定 (`plan-final`)
7. 実装
8. テスト
9. レビュー (`review.md`)
10. 資料更新 (`docs/INDEX.md` と関連資料)
11. 記憶更新 (`MEMORY.md` と `state.json`)

順序を飛ばして進めない。

## 2. 実装前チェック

以下のいずれかが未充足なら実装に進まない。

- `project.profile.yaml` が存在し必須キーが埋まっている。
- `work/<task-id>/request.md` がある。
- `work/<task-id>/spec.md` の(必須)項目が埋まっている。
- `work/<task-id>/plan.md` がある（`plan-draft` を含む）。
- `work/<task-id>/state.json` が最新。

## 3. ブロック条件

次の条件を検出したら `state=blocked` を提案し、`blocking_issues` を明示する。

- `spec.md` の(必須)項目が未記入。
- `spec.md` のテスト要件が抽象的。
- `plan.md` が `spec.md` を参照していない。
- `plan-final` 確定前に実装へ進もうとしている。
- docs 更新後に `docs/INDEX.md` が未更新。
- profile の必須キー不足。

## 4. 完了条件

`done` 判定は次の全条件を満たす場合のみ。

- `spec.md` の受入条件を満たす。
- テスト要件の実施結果が `review.md` にある。
- 変更点に対応する docs が更新済み。
- `docs/INDEX.md` に導線がある。
- `MEMORY.md` と `state.json` が最新。
