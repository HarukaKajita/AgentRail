# 自動化基盤 実装調査記録

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 調査目的

自動化基盤仕様を実装へ落とすための構造と失敗条件を確定する。

## 主な観測

- docs 管理カテゴリは `templates/specs/decisions/investigations` の4領域
- task 成果物は `work/<task-id>/` 6ファイルで固定
- profile に自動化コマンドキーが未存在

## 結論

- PowerShell 2スクリプト構成を採用する
- INDEX は部分更新し、手動セクションを維持する
- checker は task 指定型とし、終了コード契約を固定する

## 参照

- `docs/specs/automation-tools-design-spec.md`
- `work/2026-02-18__automation-tools-implementation/investigation.md`
