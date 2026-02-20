# 仕様書: 2026-02-20__define-runtime-manifest-and-export-flow

## 記入ルール

- `(必須)` セクションは必ず記入する。
- N/A を使う場合は理由を明記する。
- 受入条件とテスト要件は 1 対 1 で対応付ける。

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `work/2026-02-20__define-runtime-manifest-and-export-flow/request.md`
  - `work/2026-02-20__define-runtime-manifest-and-export-flow/investigation.md`
- 理解ポイント:
  - 単一リポジトリ方針を維持し、外部利用への分離強化を優先する。

## 1. メタ情報 (Metadata) (必須)

- Task ID: 2026-02-20__define-runtime-manifest-and-export-flow
- タイトル: runtime 配布境界（manifest）と dist/runtime export の確立
- 作成日: 2026-02-20
- 更新日: 2026-02-20
- 作成者: codex
- 関連要望: work/2026-02-20__define-runtime-manifest-and-export-flow/request.md

## 2. 背景と目的 (Background & Objectives) (必須)

- 背景: 外部利用時に framework 開発資産と runtime 必要資産が混在する。
- 目的: 配布対象を allowlist 化し、外部利用時に不要な開発用ファイル混入を防止する。

## 3. スコープ (Scope) (必須)

### 3.1 In Scope (必須)

- framework.runtime.manifest.yaml の新規定義
- tools/runtime/export-runtime.ps1 の新規追加
- dist/runtime 出力内容の決定性検証（dry-run/check）

### 3.2 Out of Scope (必須)

- 外部リポジトリへのインストール機構
- package 化実装

## 4. 受入条件 (Acceptance Criteria) (必須)

- AC-001: `framework.runtime.manifest.yaml` が追加され、`include_paths` / `seed_files` / `exclude_paths` により runtime 配布対象が定義される。
- AC-002: `tools/runtime/export-runtime.ps1` が追加され、`-Mode apply|check` と `-DryRun` で実行できる。
- AC-003: `pwsh -NoProfile -File tools/runtime/export-runtime.ps1 -Mode apply` 実行後に `-Mode check` が PASS し、dist/runtime の内容差分が 0 件であることを確認できる。

## 5. テスト要件 (Test Requirements) (必須)

### 5.1 単体テスト (Unit Test) (必須)

- **対象**: `tools/runtime/export-runtime.ps1` の manifest 解析と file plan 生成
- **検証項目**: include/exclude/seed の解決結果が期待どおりになる
- **合格基準**: `-DryRun` で copy 対象件数と出力先が期待どおりに表示される

### 5.2 結合テスト (Integration Test) (必須)

- **対象**: `framework.runtime.manifest.yaml` と `tools/runtime/export-runtime.ps1`
- **検証項目**: apply で dist/runtime が生成され、check で同期状態を検証できる
- **合格基準**: apply 実行後の check が PASS する

### 5.3 回帰テスト (Regression Test) (必須)

- **対象**: 既存の work と docs 運用フロー
- **検証項目**: 従来の task チェック・CI チェックを壊さない
- **合格基準**: `tools/state-validate/validate.ps1` と `tools/consistency-check/check.ps1` が対象 task で PASS する

### 5.4 手動検証 (Manual Verification) (必須)

- **検証手順**: `-Mode apply` 実行後に `-Mode check` と `-DryRun` を順次実行する
- **期待される結果**: AC-001 / AC-002 / AC-003 を満たす

## 6. 影響範囲 (Impact Assessment) (必須)

- 影響ファイル/モジュール: task 目的に関係する tools, README.md, AGENTS.md, docs/operations
- 影響する仕様: 分離運用、導入手順、パス解決規約
- 非機能影響: 外部導入の再現性と保守性が向上する

## 7. 制約とリスク (Constraints & Risks) (必須)

- 制約: 単一リポジトリ構成を維持する
- 想定リスク:
  - allowlist 漏れにより runtime が不完全になる
  - 除外漏れにより開発資料が混入する
- 回避策: 段階タスク化と depends_on gate により変更影響を局所化する

## 8. 未確定事項 (Open Issues) (必須)

- package 化の実施タイミングは未定。移行は別 task で判断する。

## 9. 関連資料リンク (Reference Links) (必須)

- request: work/2026-02-20__define-runtime-manifest-and-export-flow/request.md
- investigation: work/2026-02-20__define-runtime-manifest-and-export-flow/investigation.md
- plan: work/2026-02-20__define-runtime-manifest-and-export-flow/plan.md
- review: work/2026-02-20__define-runtime-manifest-and-export-flow/review.md
- docs:
  - `docs/operations/high-priority-backlog.md`
  - `docs/operations/runtime-distribution-export-guide.md`


