# Plan: 2026-02-18__automation-tools-ci-integration

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 1. 対象仕様

- 主仕様: `work/2026-02-18__automation-tools-ci-integration/spec.md`
- 参照仕様:
  - `docs/specs/automation-tools-design-spec.md`
  - `docs/specs/automation-tools-implementation-spec.md`


## 2. 実装計画ドラフト (Plan Draft)

- 目的: 既存資料の移行と整合性確保
- 実施項目:
  1. 既存ドキュメントの構造修正
- 成果物: 更新済み Markdown ファイル

## 3. 依存関係ゲート (Depends-on Gate)

- 依存: なし
- 判定方針: 直接移行
## 5. 実行コマンド (Execution Commands)

- index docs: `pwsh -NoProfile -File tools/docs-indexer/index.ps1`
- index diff check: `git diff --exit-code -- docs/INDEX.md`
- consistency check (ci task): `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-18__automation-tools-ci-integration`
- consistency check (automation task): `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-18__automation-tools-implementation`
- consistency check (pilot task): `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-18__framework-pilot-01`

## 4. 確定実装計画 (Plan Final)

1. GitHub Actions workflow を追加する。
2. latest task-id 自動解決ロジックを workflow に実装する。
3. docs-indexer + INDEX差分検知 + checker 実行の順を構成する。
4. CI 連携内容を docs/specs + docs/investigations に昇格する。
5. docs-indexer / checker をローカル検証し、review/state/memory を更新する。

## 4. 変更対象ファイル

- `.github/workflows/ci-framework.yml`
- `docs/specs/automation-tools-design-spec.md`
- `docs/specs/automation-tools-ci-integration-spec.md`
- `docs/investigations/automation-tools-ci-integration-investigation.md`
- `docs/INDEX.md`
- `MEMORY.md`
- `work/2026-02-18__automation-tools-ci-integration/*`

## 5. リスクとロールバック

- リスク: 同時刻更新で最新 task-id が一意に解決できない
- ロールバック: workflow の task-id 解決を入力パラメータ必須方式へ切り替える

## 6. 完了判定

- AC-001〜AC-005 を `review.md` ですべて PASS にする。
- `state.json` を `done` に更新する。
