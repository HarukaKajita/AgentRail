# Wave 0: Doc Ownership And Update Matrix

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/human-centric-doc-bank-governance.md`
  - `docs/operations/wave0-inventory-human-centric-doc-coverage.md`
  - `work/2026-02-20__wave0-define-doc-ownership-and-update-matrix/spec.md`
- 理解ポイント:
  - 本資料は docs 更新時の責務境界を固定し、更新漏れを防ぐための運用基準である。

## 1. 目的

- docs 更新責務を `task owner` / `implementation owner` / `reviewer` で明確化する。
- Wave 1 以降の docs 補完作業で、判断基準と責務の重複をなくす。

## 2. ロール定義

1. task owner
   - `work/<task-id>/` 一式（request/investigation/spec/plan/review/state）の最終責任を持つ。
   - 受入条件とテスト要件の一致を担保する。
2. implementation owner
   - 実装差分・設計差分に対応する docs 更新を実施する。
   - `docs/INDEX.md` 導線を同一タスクで同期する。
3. reviewer
   - AC 判定、テスト結果、依存整合、Process Findings を検証する。
   - 欠落があれば done 判定前に差し戻す。

## 3. 責務マトリクス

| 対象資料 | task owner | implementation owner | reviewer |
| --- | --- | --- | --- |
| `AGENTS.md` | 要件反映の必要性を判断 | 変更反映と整合確認 | ルール逸脱がないか確認 |
| `README.md` | 影響範囲を定義 | 使い方/導線を更新 | 利用者視点での可読性を確認 |
| `docs/INDEX.md` | 更新対象を確定 | 新規/更新 docs の導線反映 | 参照切れと分類漏れを確認 |
| `docs/operations/*.md` | 更新計画を確定 | 本文更新と関連リンク整備 | 目的/使い方/仕組み/実装/関連の不足確認 |
| `work/<task-id>/*` | 正本として維持 | 実装・検証結果を記録 | AC とテストの一致を確認 |
| `docs/operations/high-priority-backlog.md` | 状態更新を指示 | planned/completed を反映 | depends_on 整合を確認 |
| `MEMORY.md` | 引き継ぎ内容を決定 | 最新状況を記録 | 次アクションの妥当性を確認 |

## 4. 更新トリガーと担当

1. 仕様変更
   - 主担当: task owner
   - 連携: implementation owner が docs へ反映、reviewer が AC 再確認
2. 実装変更
   - 主担当: implementation owner
   - 連携: task owner が work 資料更新、reviewer が回帰影響を確認
3. 運用変更
   - 主担当: task owner + implementation owner
   - 連携: reviewer が backlog/MEMORY の一貫性を確認

## 5. done 前チェックリスト

1. `state.json` が `done` で、depends_on が全て `done` になっている。
2. `review.md` の AC とテスト結果に PENDING が残っていない。
3. `spec.md` の関連資料リンクに対象 docs が記載され、`docs/INDEX.md` に導線がある。
4. `docs/operations/high-priority-backlog.md` が最新状態と一致している。
5. `MEMORY.md` が次アクションと現在タスクを正しく示している。

## 6. Wave 1 への適用方針

- `2026-02-20__wave1-migrate-core-docs-to-human-centric-model`
  - core docs 補完時に本責務マトリクスを適用する。
- `2026-02-20__wave1-migrate-operations-docs-to-human-centric-model`
  - operations docs 補完時に本責務マトリクスを適用する。
- `2026-02-20__wave1-normalize-doc-work-cross-links`
  - cross-link 正規化時の更新責務判定に本資料を参照する。
