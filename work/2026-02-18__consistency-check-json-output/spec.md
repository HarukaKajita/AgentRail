# 仕様書: 2026-02-18__consistency-check-json-output

## 1. メタ情報 [空欄禁止]

- Task ID: `2026-02-18__consistency-check-json-output`
- タイトル: consistency-check JSON 出力対応
- 作成日: 2026-02-18
- 更新日: 2026-02-18
- 作成者: Codex
- 関連要望: `work/2026-02-18__consistency-check-json-output/request.md`

## 2. 背景と目的 [空欄禁止]

- 背景: checker 出力がテキストのみで、CI集計や通知に再利用しにくい。
- 目的: 機械可読な JSON 出力を追加して、自動連携を容易にする。

## 3. スコープ [空欄禁止]

### 3.1 In Scope [空欄禁止]

- `-OutputFormat text|json` パラメータ追加
- `-OutputFile`（任意）追加
- JSON スキーマ定義（run metadata, results, failures）
- docs 仕様更新

### 3.2 Out of Scope [空欄禁止]

- 外部通知連携（Slack 等）
- checker ルール変更

## 4. 受入条件 (Acceptance Criteria / 受入条件) [空欄禁止]

- AC-001: 既定値 `text` で現行出力互換を維持する。
- AC-002: `-OutputFormat json` 指定時に有効な JSON を出力する。
- AC-003: JSON に `task_id`, `status`, `failure_count`, `failures[]` を含む。
- AC-004: 失敗時も JSON が生成され、終了コードは従来どおり 1 となる。
- AC-005: JSON スキーマと使用例が docs に反映される。

## 5. テスト要件 (Test Requirements / テスト要件) [空欄禁止]

### 5.1 Unit Test (Unit Test / 単体テスト) [空欄禁止]

- 対象: 出力フォーマット分岐
- 観点: text/json 選択と不正値拒否
- 合格条件: 想定どおり分岐し、エラー処理される

### 5.2 Integration Test (Integration Test / 結合テスト) [空欄禁止]

- 対象: checker 実行結果と JSON 生成
- 観点: PASS/FAIL 両ケースで JSON が期待フィールドを持つ
- 合格条件: JSON パース可能かつ項目欠落なし

### 5.3 Regression Test (Regression Test / 回帰テスト) [空欄禁止]

- 対象: 既存 CI ログ
- 観点: text モード既定時に従来ログが維持される
- 合格条件: CI の既存 step が変更なしで通る

### 5.4 Manual Verification (Manual Verification / 手動検証) [空欄禁止]

- 手順:
  1. text モードで実行
  2. json モードで実行
  3. `-OutputFile` 指定でファイル出力確認
- 期待結果: AC-001〜AC-004 を満たす

## 6. 影響範囲 [空欄禁止]

- 影響ファイル/モジュール:
  - `tools/consistency-check/check.ps1`
  - `.github/workflows/ci-framework.yml`
  - `docs/specs/phase2-automation-spec.md`
- 影響する仕様:
  - `docs/specs/phase2-ci-integration-spec.md`
- 非機能影響:
  - CI ログ解析や通知連携が容易になる

## 7. 制約とリスク [空欄禁止]

- 制約: 既存 text 出力互換を壊さない
- 想定リスク: JSON と text で情報不整合が起きる
- 回避策: 共通データ構造から両フォーマットを生成する

## 8. 未確定事項 [空欄禁止]

- JSON 出力時の標準出力テキスト併記有無

## 9. 関連資料リンク [空欄禁止]

- request: `work/2026-02-18__consistency-check-json-output/request.md`
- investigation: `work/2026-02-18__consistency-check-json-output/investigation.md`
- plan: `work/2026-02-18__consistency-check-json-output/plan.md`
- review: `work/2026-02-18__consistency-check-json-output/review.md`
- docs:
  - `docs/specs/phase2-automation-spec.md`
  - `docs/specs/phase2-ci-integration-spec.md`
