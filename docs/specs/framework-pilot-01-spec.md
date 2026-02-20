# Framework Pilot 01 仕様

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `docs/operations/high-priority-backlog.md`
- 理解ポイント:
  - 本仕様の背景、関連調査、運用制約を先に確認してから詳細を読む。
## 概要

手動運用導入段階で整備したフレームワークを実際に 1 件運用し、厳格ブロック運用が成立することを検証する。

## スコープ

- `project.profile.yaml` 必須項目の実値化
- `work/2026-02-18__framework-pilot-01/` の成果物作成
- docs 昇格資料の作成
- `docs/INDEX.md` 更新
- 自動化基盤仕様の文書化

## 受入条件

1. profile の `TODO_SET_ME` がすべて除去されている
2. task 成果物 6 ファイルが揃い、空欄禁止項目が埋まっている
3. docs 側に spec/investigation が昇格されている
4. `docs/specs/automation-tools-design-spec.md` が作成されている
5. `docs/INDEX.md` が更新されている

## テスト観点

- ファイル存在チェック
- work/docs 相互参照チェック
- 既存ルール維持確認
- 手動の AC 照合

## 詳細仕様

- 実運用仕様は `work/2026-02-18__framework-pilot-01/spec.md` を参照する。

