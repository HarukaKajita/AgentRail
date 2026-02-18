# 自己改善ループ強制方針

## 1. タイトル [空欄禁止]

- 自己改善ループ強制方針

## 2. ステータス [空欄禁止]

- Accepted

## 3. 日付 [空欄禁止]

- 2026-02-18

## 4. 背景 (Context / 背景) [空欄禁止]

- フロー漏れの発生時に、改善の気づきが task 化されず再発リスクが残った。
- 既存 CI は仕様整合中心で、改善起票の有無を検知できなかった。

## 5. 決定 (Decision / 決定内容) [空欄禁止]

- `review.md` に `Process Findings` を必須化する。
- `must/high` finding は `action_required: yes` と `linked_task_id` を必須化する。
- CI で `scan.ps1` と `consistency-check` により未起票を fail-fast する。
- follow-up task の雛形作成は `create-task.ps1` で自動化する。

## 6. 代替案 (Alternatives / 代替案) [空欄禁止]

- 案A: warning のみで起票を任意運用にする
- 案B: すべての finding を必須起票にする

## 7. 影響 (Consequences / 影響) [空欄禁止]

- メリット:
  - 改善漏れを CI で防止できる
  - フロー改善のトレーサビリティが向上する
- デメリット:
  - review 記入項目が増える
  - 軽微変更でも finding 記述が必要になる
- トレードオフ:
  - 開発速度より再発防止を優先する

## 8. 関連資料 [空欄禁止]

- spec: `docs/specs/self-improvement-loop-spec.md`
- investigation: `docs/investigations/self-improvement-loop-investigation.md`
- review: `work/2026-02-18__self-improvement-loop-enforcement/review.md`
