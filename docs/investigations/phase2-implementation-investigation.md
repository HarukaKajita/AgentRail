# Phase 2 実装調査記録

## 調査目的

Phase 2 仕様を実装へ落とすための構造と失敗条件を確定する。

## 主な観測

- docs 管理カテゴリは `templates/specs/decisions/investigations` の4領域
- task 成果物は `work/<task-id>/` 6ファイルで固定
- profile に自動化コマンドキーが未存在

## 結論

- PowerShell 2スクリプト構成を採用する
- INDEX は部分更新し、手動セクションを維持する
- checker は task 指定型とし、終了コード契約を固定する

## 参照

- `docs/specs/phase2-automation-spec.md`
- `work/2026-02-18__phase2-automation-implementation/investigation.md`
