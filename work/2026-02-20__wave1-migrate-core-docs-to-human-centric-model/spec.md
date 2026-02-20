# 仕様書: 2026-02-20__wave1-migrate-core-docs-to-human-centric-model

## 記入ルール

- [空欄禁止] セクションは必ず記入する。
- N/A を使う場合は理由を明記する。
- 受入条件とテスト要件は 1 対 1 で対応付ける。

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `README.md`
  - `docs/INDEX.md`
  - `docs/operations/wave0-inventory-human-centric-doc-coverage.md`
  - `docs/operations/wave0-doc-ownership-and-update-matrix.md`
  - `work/2026-02-20__wave1-migrate-core-docs-to-human-centric-model/request.md`
  - `work/2026-02-20__wave1-migrate-core-docs-to-human-centric-model/investigation.md`
- 理解ポイント:
  - Wave 1 core docs 移行は、must 資料の「目的/使い方/仕組み/実装/関連」導線を先に整えるタスクである。

## 1. メタ情報 [空欄禁止]

- Task ID: 2026-02-20__wave1-migrate-core-docs-to-human-centric-model
- タイトル: Wave 1: AGENTS/README/INDEX を情報モデルへ移行
- 作成日: 2026-02-20
- 更新日: 2026-02-20
- 作成者: codex
- 関連要望: `work/2026-02-20__wave1-migrate-core-docs-to-human-centric-model/request.md`

## 2. 背景と目的 [空欄禁止]

- 背景: Wave 0 で core docs のカテゴリ不足が明確になったため、Wave 1 で first-class docs を補完する必要がある。
- 目的: `AGENTS.md`、`README.md`、`docs/INDEX.md` に人間理解中心の導線（目的/使い方/仕組み/実装/関連）を追加する。

## 3. スコープ [空欄禁止]

### 3.1 In Scope [空欄禁止]

- `AGENTS.md` の運用理解導線を補強する。
- `README.md` の onboarding 導線を補強する。
- `docs/INDEX.md` の利用ガイド導線を補強する。
- core docs 移行結果を docs に記録する。
- review と検証結果の記録。

### 3.2 Out of Scope [空欄禁止]

- `docs/operations/*` 全体の補完（Wave 1 operations で実施）。
- validator 実装変更（Wave 2 で実施）。

## 4. 受入条件 (Acceptance Criteria / 受入条件) [空欄禁止]

- AC-001: `AGENTS.md`、`README.md`、`docs/INDEX.md` に人間理解中心の導線（目的/使い方/仕組み/実装/関連）が追記される。
- AC-002: core docs 移行結果が `docs/operations/wave1-core-docs-human-centric-migration.md` と task 資料に記録され、depends_on/backlog/state/plan が整合する。

## 5. テスト要件 (Test Requirements / テスト要件) [空欄禁止]

### 5.1 Unit Test (Unit Test / 単体テスト) [空欄禁止]

- 対象: `work/2026-02-20__wave1-migrate-core-docs-to-human-centric-model` の request/investigation/spec/plan/review/state
- 観点: 空欄禁止セクション、依存、成果物定義の整合
- 合格条件: consistency-check -TaskId 2026-02-20__wave1-migrate-core-docs-to-human-centric-model が PASS

### 5.2 Integration Test (Integration Test / 結合テスト) [空欄禁止]

- 対象: depends_on で接続される task 間の整合
- 観点: depends_on 記述と backlog 表示が一致
- 合格条件: 依存 task + 本 task の consistency-check が PASS

### 5.3 Regression Test (Regression Test / 回帰テスト) [空欄禁止]

- 対象: 全 task の state / consistency 運用
- 観点: 既存完了タスクの PASS を維持
- 合格条件: state-validate -AllTasks と consistency-check -AllTasks が PASS

### 5.4 Manual Verification (Manual Verification / 手動検証) [空欄禁止]

- 手順: `AGENTS.md` / `README.md` / `docs/INDEX.md` の導線見出しと関連リンクを確認する
- 期待結果: AC-001 と AC-002 を満たす

## 6. 影響範囲 [空欄禁止]

- 影響ファイル/モジュール: `AGENTS.md`, `README.md`, `docs/INDEX.md`, `docs/operations/wave1-core-docs-human-centric-migration.md`, `work/2026-02-20__wave1-migrate-core-docs-to-human-centric-model/*`, `docs/operations/high-priority-backlog.md`, `MEMORY.md`
- 影響する仕様: human-centric docs migration wave 計画
- 非機能影響: 新規参加者の理解時間短縮、導線探索コスト低減

## 7. 制約とリスク [空欄禁止]

- 制約: depends_on 未解決時は dependency-blocked を維持する。
- 想定リスク:
  - core docs への追記が分散し過ぎて可読性が下がる
  - docs 導線更新漏れ
- 回避策: 追記は「導線強化」に限定し、詳細は operations doc へ集約する。

## 8. 未確定事項 [空欄禁止]

- operations docs への適用粒度は Wave 1 operations task で確定する。

## 9. 関連資料リンク [空欄禁止]

- request: `work/2026-02-20__wave1-migrate-core-docs-to-human-centric-model/request.md`
- investigation: `work/2026-02-20__wave1-migrate-core-docs-to-human-centric-model/investigation.md`
- plan: `work/2026-02-20__wave1-migrate-core-docs-to-human-centric-model/plan.md`
- review: `work/2026-02-20__wave1-migrate-core-docs-to-human-centric-model/review.md`
- `docs/operations/wave1-core-docs-human-centric-migration.md`
- `docs/operations/wave0-inventory-human-centric-doc-coverage.md`
- `docs/operations/wave0-doc-ownership-and-update-matrix.md`
- `docs/operations/high-priority-backlog.md`
