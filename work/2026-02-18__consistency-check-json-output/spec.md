# 仕様書: 2026-02-18__consistency-check-json-output

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 1. メタ情報 (Metadata) (必須)

- Task ID: `2026-02-18__consistency-check-json-output`
- タイトル: consistency-check JSON 出力対応
- 作成日: 2026-02-18
- 更新日: 2026-02-18
- 作成者: Codex
- 関連要望: `work/2026-02-18__consistency-check-json-output/request.md`

## 2. 背景と目的 (Background & Objectives) (必須)

- 背景: checker 出力がテキストのみで、CI集計や通知に再利用しにくい。
- 目的: 機械可読な JSON 出力を追加して、自動連携を容易にする。

## 3. スコープ (Scope) (必須)

### 3.1 In Scope (必須)

- `-OutputFormat text|json` パラメータ追加
- `-OutputFile`（任意）追加
- JSON スキーマ定義（run metadata, results, failures）
- docs 仕様更新

### 3.2 Out of Scope (必須)

- 外部通知連携（Slack 等）
- checker ルール変更

## 4. 受入条件 (Acceptance Criteria) (必須)

- AC-001: 既定値 `text` で現行出力互換を維持する。
- AC-002: `-OutputFormat json` 指定時に有効な JSON を出力する。
- AC-003: JSON に `task_id`, `status`, `failure_count`, `failures[]` を含む。
- AC-004: 失敗時も JSON が生成され、終了コードは従来どおり 1 となる。
- AC-005: JSON スキーマと使用例が docs に反映される。

## 5. テスト要件 (Test Requirements) (必須)

### 5.1 単体テスト (Unit Test) (必須)

- **対象**: 出力フォーマット分岐
- **検証項目**: text/json 選択と不正値拒否
- **合格基準**: 想定どおり分岐し、エラー処理される

### 5.2 結合テスト (Integration Test) (必須)

- **対象**: checker 実行結果と JSON 生成
- **検証項目**: PASS/FAIL 両ケースで JSON が期待フィールドを持つ
- **合格基準**: JSON パース可能かつ項目欠落なし

### 5.3 回帰テスト (Regression Test) (必須)

- **対象**: 既存 CI ログ
- **検証項目**: text モード既定時に従来ログが維持される
- **合格基準**: CI の既存 step が変更なしで通る

### 5.4 手動検証 (Manual Verification) (必須)

- **検証手順**:
  1. text モードで実行
  2. json モードで実行
  3. `-OutputFile` 指定でファイル出力確認
- **期待される結果**: AC-001〜AC-004 を満たす

## 6. 影響範囲 (Impact Assessment) (必須)

- 影響ファイル/モジュール:
  - `tools/consistency-check/check.ps1`
  - `.github/workflows/ci-framework.yml`
  - `docs/specs/automation-tools-design-spec.md`
- 影響する仕様:
  - `docs/specs/automation-tools-ci-integration-spec.md`
- 非機能影響:
  - CI ログ解析や通知連携が容易になる

## 7. 制約とリスク (Constraints & Risks) (必須)

- 制約: 既存 text 出力互換を壊さない
- 想定リスク: JSON と text で情報不整合が起きる
- 回避策: 共通データ構造から両フォーマットを生成する

## 8. 未確定事項 (Open Issues) (必須)

- JSON 出力時の標準出力テキスト併記有無

## 9. 関連資料リンク (Reference Links) (必須)

- request: `work/2026-02-18__consistency-check-json-output/request.md`
- investigation: `work/2026-02-18__consistency-check-json-output/investigation.md`
- plan: `work/2026-02-18__consistency-check-json-output/plan.md`
- review: `work/2026-02-18__consistency-check-json-output/review.md`
- docs:
  - `docs/specs/automation-tools-design-spec.md`
  - `docs/specs/automation-tools-ci-integration-spec.md`
