# Wave 0 Inventory: Human-Centric Doc Coverage

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/operations/human-centric-doc-bank-governance.md`
  - `docs/operations/human-centric-doc-bank-migration-plan.md`
  - `docs/operations/high-priority-backlog.md`
  - `work/2026-02-20__wave0-inventory-human-centric-doc-coverage/spec.md`
- 理解ポイント:
  - 本資料は Wave 1 以降の補完対象を決めるための棚卸し結果である。

## 1. 目的

- must 対象資料の網羅状況を確認し、欠落カテゴリ（目的/使い方/仕組み/実装/関連）を可視化する。
- Wave 1 の優先補完順を決定できる状態を作る。

## 2. 対象範囲（Must）

- `AGENTS.md`
- `README.md`
- `docs/INDEX.md`
- `docs/operations/high-priority-backlog.md`
- `docs/operations/framework-request-to-commit-visual-guide.md`
- `docs/operations/runtime-framework-rules.md`
- `docs/operations/ci-failure-runbook.md`

## 3. 棚卸し結果

| 資料 | 目的 | 使い方 | 仕組み | 実装 | 関連 |
| --- | --- | --- | --- | --- | --- |
| `AGENTS.md` | 充足 | 一部不足 | 充足 | 一部不足 | 一部不足 |
| `README.md` | 充足 | 一部不足 | 一部不足 | 不足 | 一部不足 |
| `docs/INDEX.md` | 充足 | 充足 | 不足 | 不足 | 一部不足 |
| `docs/operations/high-priority-backlog.md` | 充足 | 充足 | 一部不足 | 不足 | 充足 |
| `docs/operations/framework-request-to-commit-visual-guide.md` | 充足 | 充足 | 一部不足 | 一部不足 | 一部不足 |
| `docs/operations/runtime-framework-rules.md` | 充足 | 一部不足 | 充足 | 一部不足 | 一部不足 |
| `docs/operations/ci-failure-runbook.md` | 充足 | 充足 | 一部不足 | 一部不足 | 一部不足 |

## 4. 欠落カテゴリマップ

### 4.1 目的

- 深刻な欠落はなし（全資料で目的は明記済み）。

### 4.2 使い方

- `AGENTS.md`: ルール参照順序は明記されているが、典型的な運用開始手順が分散。
- `README.md`: 新規参加者向けの最短実行フローが不足。
- `docs/operations/runtime-framework-rules.md`: 実運用での参照優先度と例外対応手順が不足。

### 4.3 仕組み

- `README.md`: docs/work/state の連動関係が断片的。
- `docs/INDEX.md`: 導線一覧はあるが、どの運用でどの資料を使うかの説明が不足。
- `docs/operations/high-priority-backlog.md`: 優先度判断ロジックと gate の解説が不足。

### 4.4 実装

- `README.md`: 実装関連ツール（`tools/*`）への導線が弱い。
- `docs/INDEX.md`: 実装系 docs/specs と運用 docs の対応関係が見えづらい。
- `docs/operations/high-priority-backlog.md`: backlog 更新を支える実行コマンドの一覧が不足。

### 4.5 関連

- 複数資料で `docs <-> work` の相互リンク粒度が不統一。
- runbook 群で「関連する task/spec/review への導線」が揺れている。

## 5. Wave 1 への引き継ぎ

1. `2026-02-20__wave1-migrate-core-docs-to-human-centric-model`
   - `AGENTS.md` / `README.md` / `docs/INDEX.md` の不足カテゴリ補完を優先。
2. `2026-02-20__wave1-migrate-operations-docs-to-human-centric-model`
   - `docs/operations/*` の不足カテゴリ補完と用語統一を優先。
3. `2026-02-20__wave1-normalize-doc-work-cross-links`
   - Wave 1 の2タスク完了後に cross-link 正規化を実施。

## 6. ゲート判定

- must 対象の列挙: PASS（対象7資料を棚卸し）
- 欠落カテゴリ明文化: PASS（目的/使い方/仕組み/実装/関連を全件記録）
- 次タスクへの接続: PASS（Wave 1 先行2タスクを plan-ready に更新）

## 7. ロールバック方針

- 分類結果に誤りが判明した場合は本資料の該当行を修正し、`docs/operations/high-priority-backlog.md` の依存状態を再同期する。
- docs 導線に不整合が発生した場合は `docs/INDEX.md` を先に復旧し、その後 review/state を更新する。
