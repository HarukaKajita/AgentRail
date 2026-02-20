# Plan: 2026-02-18__consistency-check-multi-task-mode

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 1. 対象仕様

- `work/2026-02-18__consistency-check-multi-task-mode/spec.md`


## 2. 実装計画ドラフト (Plan Draft)

- 目的: 既存資料の移行と整合性確保
- 実施項目:
  1. 既存ドキュメントの構造修正
- 成果物: 更新済み Markdown ファイル

## 3. 依存関係ゲート (Depends-on Gate)

- 依存: なし
- 判定方針: 直接移行
## 5. 実行コマンド (Execution Commands)

- single: `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-18__framework-pilot-01`
- multi: `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskIds 2026-02-18__framework-pilot-01,2026-02-18__automation-tools-implementation`
- all: `pwsh -NoProfile -File tools/consistency-check/check.ps1 -AllTasks`

## 4. 確定実装計画 (Plan Final)

1. `tools/consistency-check/check.ps1` に parameter set を追加する。
2. task 単位の結果集計データ構造を実装する。
3. 終了コード決定ロジックを集計ベースに変更する。
4. CI 側の呼び出し方を更新する（必要なら）。
5. docs と review/state を更新する。

## 4. 変更対象ファイル

- `tools/consistency-check/check.ps1`
- `.github/workflows/ci-framework.yml`
- `docs/specs/automation-tools-ci-integration-spec.md`
- `docs/INDEX.md`
- `work/2026-02-18__consistency-check-multi-task-mode/*`

## 5. リスクとロールバック

- リスク: 複数走査時にノイズfailが増える
- ロールバック: `-TaskId` モードのみ使用する運用へ一時戻す

## 6. 完了判定

- AC-001〜AC-005 がすべて PASS

## 7. 実装実行計画（2026-02-18T22:29:55+09:00）

1. `tools/consistency-check/check.ps1` に `-TaskIds` / `-AllTasks` の parameter set を追加する。
2. 単一 task 検証ロジックを関数化し、複数 task の集計処理から再利用する。
3. 複数モードでは task ごとの PASS/FAIL サマリを出力し、FAIL 含有時に終了コード 1 を返す。
4. docs と review/state を更新し、単一/複数/全件モードを手動検証する。
