# State History Strategy

## 決定

state history は `state.json` に保持せず、Git 履歴へ外部化する。

## 方針

- `state.json` は最新スナップショット専用とする。
- `history` / `state_history` キーは `state.json` に含めない。
- 履歴確認は `git log` と差分で行う。

## 検証ルール

`tools/state-validate/validate.ps1` は `history` または `state_history` キーを検出した場合に FAIL する。

## 履歴確認コマンド例

- 単一タスク: `git log --oneline -- work/<task-id>/state.json`
- 差分確認: `git log -p -- work/<task-id>/state.json`

## 例外運用

- 将来、専用 history artifact を導入する場合は別 task で仕様を追加し、本資料を更新する。
