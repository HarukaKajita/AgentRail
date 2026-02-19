# 自動化基盤 CI 連携調査記録

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 調査目的

自動化基盤として実装済みの自動化スクリプトを CI に組み込むための具体方式を確定する。

## 主な観測

- `.github/workflows/` が未作成で、CI 定義が存在しない
- `check.ps1` は `-TaskId` 必須で、CI 側で task 解決が必要
- `docs-indexer` 後の INDEX 差分をゲート化すると更新漏れを防げる

## 結論

- CI 基盤は GitHub Actions を採用
- latest task-id 自動解決方式を採用
- INDEX 差分検出は失敗扱いにする

## 参照

- `docs/specs/automation-tools-design-spec.md`
- `docs/specs/automation-tools-ci-integration-spec.md`
- `work/2026-02-18__automation-tools-ci-integration/investigation.md`
