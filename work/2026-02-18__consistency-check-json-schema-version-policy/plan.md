# Plan: 2026-02-18__consistency-check-json-schema-version-policy

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 1. 対象仕様

- `work/2026-02-18__consistency-check-json-schema-version-policy/spec.md`


## 2. 実装計画ドラフト (Plan Draft)

- 目的: 既存資料の移行と整合性確保
- 実施項目:
  1. 既存ドキュメントの構造修正
- 成果物: 更新済み Markdown ファイル

## 3. 依存関係ゲート (Depends-on Gate)

- 依存: なし
- 判定方針: 直接移行
## 5. 実行コマンド (Execution Commands)

- json single: `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-18__project-profile-schema-validation -OutputFormat json`
- json multi: `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskIds 2026-02-18__project-profile-schema-validation,does-not-exist -OutputFormat json`
- json output file: `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-18__project-profile-schema-validation -OutputFormat json -OutputFile .tmp/schema-check.json`
- text regression: `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId does-not-exist`
- docs index update: `pwsh -NoProfile -File tools/docs-indexer/index.ps1`
- task consistency: `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-18__consistency-check-json-schema-version-policy`

## 4. 確定実装計画 (Plan Final)

1. investigation と spec を反映し、`schema_version` と互換ポリシーの要件を固定する。
2. `tools/consistency-check/check.ps1` の JSON payload 組み立てへ `schema_version` 定数を導入する。
3. `docs/specs/automation-tools-design-spec.md` に JSON スキーマ versioning policy を追記する。
4. JSON 出力（single/multi/file）と text 回帰を実行し、受入条件を検証する。
5. `review.md` / `state.json` / `MEMORY.md` を更新し、`consistency-check` で task 完了可否を確認する。

## 4. 変更対象ファイル

- `tools/consistency-check/check.ps1`
- `docs/specs/automation-tools-design-spec.md`
- `work/2026-02-18__consistency-check-json-schema-version-policy/investigation.md`
- `work/2026-02-18__consistency-check-json-schema-version-policy/spec.md`
- `work/2026-02-18__consistency-check-json-schema-version-policy/plan.md`
- `work/2026-02-18__consistency-check-json-schema-version-policy/review.md`
- `work/2026-02-18__consistency-check-json-schema-version-policy/state.json`
- `MEMORY.md`

## 5. リスクとロールバック

- リスク: JSON 利用側が strict schema で追加フィールドを拒否する可能性
- 回避: 追加のみで既存キーを維持し、docs で互換ポリシーを明示する
- ロールバック: `schema_version` 導入コミットを取り消し、互換方針のみ docs 先行で再設計する

## 6. 完了判定

- AC-001〜AC-004 が PASS
- `review.md` にテスト結果と判定根拠が記録される
- `state.json` が `done` で更新される

## 7. 実装実行計画（2026-02-19T00:56:03+09:00）

1. `tools/consistency-check/check.ps1` に `$jsonSchemaVersion = "1.0.0"` を追加し、single/multi JSON payload 双方へ注入する。
2. `automation-tools-design-spec` の JSON スキーマ例と受入基準へ `schema_version` と versioning policy を追記する。
3. 4系統の実行コマンド（json single/json multi/json file/text regression）で挙動を確認する。
4. review/state/memory を更新後、task consistency check を通してコミットする。
