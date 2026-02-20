# Plan: 2026-02-18__framework-pilot-01

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 1. 対象仕様

- 主仕様: `work/2026-02-18__framework-pilot-01/spec.md`
- docs 昇格先:
  - `docs/specs/framework-pilot-01-spec.md`
  - `docs/investigations/framework-pilot-01-investigation.md`
  - `docs/specs/automation-tools-design-spec.md`


## 2. 実装計画ドラフト (Plan Draft)

- 目的: 既存資料の移行と整合性確保
- 実施項目:
  1. 既存ドキュメントの構造修正
- 成果物: 更新済み Markdown ファイル

## 3. 依存関係ゲート (Depends-on Gate)

- 依存: なし
- 判定方針: 直接移行
## 5. 実行コマンド (Execution Commands)

- build: `project.profile.yaml -> commands.build.command`
- test: `project.profile.yaml -> commands.test.command`
- format: `project.profile.yaml -> commands.format.command`
- lint: `project.profile.yaml -> commands.lint.command`

## 4. 確定実装計画 (Plan Final)

1. `project.profile.yaml` の必須キーを `TODO_SET_ME` から実値へ更新する。
2. `work/2026-02-18__framework-pilot-01/` を作成し必須成果物を配置する。
3. request/investigation/spec を記述してブロック条件を解消する。
4. docs 昇格資料を作成し `docs/INDEX.md` を更新する。
5. review と state を更新し完了判定を記録する。
6. `MEMORY.md` を更新して引き継ぎ情報を確定する。

## 4. 変更対象ファイル

- `project.profile.yaml`
- `MEMORY.md`
- `docs/INDEX.md`
- `work/2026-02-18__framework-pilot-01/request.md`
- `work/2026-02-18__framework-pilot-01/investigation.md`
- `work/2026-02-18__framework-pilot-01/spec.md`
- `work/2026-02-18__framework-pilot-01/plan.md`
- `work/2026-02-18__framework-pilot-01/review.md`
- `work/2026-02-18__framework-pilot-01/state.json`
- `docs/specs/framework-pilot-01-spec.md`
- `docs/investigations/framework-pilot-01-investigation.md`
- `docs/specs/automation-tools-design-spec.md`

## 5. リスクとロールバック

- リスク: profile コマンドの定義が将来環境に合わない可能性
- ロールバック: profile の command 値のみを直前状態に戻して再定義する

## 6. 完了判定

- AC-001〜AC-005 を `review.md` ですべて PASS にする。
- `state.json` を `done` に更新し `blocking_issues` を空にする。
