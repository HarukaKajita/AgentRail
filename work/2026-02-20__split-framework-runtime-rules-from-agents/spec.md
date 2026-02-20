# 仕様書: 2026-02-20__split-framework-runtime-rules-from-agents

## 記入ルール

- `(必須)` セクションは必ず記入する。
- N/A を使う場合は理由を明記する。
- 受入条件とテスト要件は 1 対 1 で対応付ける。

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `work/2026-02-20__split-framework-runtime-rules-from-agents/request.md`
  - `work/2026-02-20__split-framework-runtime-rules-from-agents/investigation.md`
- 理解ポイント:
  - 単一リポジトリ方針を維持し、外部利用への分離強化を優先する。

## 1. メタ情報 (Metadata) (必須)

- Task ID: 2026-02-20__split-framework-runtime-rules-from-agents
- タイトル: AGENTS.md から runtime 必須記述を分離して要旨リンク化
- 作成日: 2026-02-20
- 更新日: 2026-02-20
- 作成者: codex
- 関連要望: work/2026-02-20__split-framework-runtime-rules-from-agents/request.md

## 2. 背景と目的 (Background & Objectives) (必須)

- 背景: 外部利用時に framework 開発資産と runtime 必要資産が混在する。
- 目的: フレームワーク動作必須ルールを専用ファイルへ分離し、AGENTS.md は要旨と参照導線に整理する。

## 3. スコープ (Scope) (必須)

### 3.1 In Scope (必須)

- runtime 必須規約の新規ドキュメント作成
- AGENTS.md への要旨・リンク導線の追加
- 導入手順と docs/INDEX.md の整合更新

### 3.2 Out of Scope (必須)

- AGENTS.md 全面書き換え
- 非 runtime ルールの再編成

## 4. 受入条件 (Acceptance Criteria) (必須)

- AC-001: タスク目的に対する仕様と実装方針が docs/work に反映される。
- AC-002: 依存関係とゲート条件が backlog/state/plan で整合する。

## 5. テスト要件 (Test Requirements) (必須)

### 5.1 単体テスト (Unit Test) (必須)

- **対象**: 変更対象 PowerShell スクリプトまたはドキュメント生成ロジック
- **検証項目**: 入力条件に対して期待出力が得られる
- **合格基準**: 想定ケースで PASS、異常系で適切に FAIL

### 5.2 結合テスト (Integration Test) (必須)

- **対象**: tools と project.profile.yaml の連携
- **検証項目**: .agentrail/work 前提でも一貫した動作となる
- **合格基準**: 導入～検証の主要コマンドが成功する

### 5.3 回帰テスト (Regression Test) (必須)

- **対象**: 既存の work と docs 運用フロー
- **検証項目**: 従来の task チェック・CI チェックを壊さない
- **合格基準**: 既存検証手順が継続して PASS

### 5.4 手動検証 (Manual Verification) (必須)

- **検証手順**: spec と plan に定義したコマンドを順次実行して結果を確認する
- **期待される結果**: AC-001 と AC-002 を満たす

## 6. 影響範囲 (Impact Assessment) (必須)

- 影響ファイル/モジュール: task 目的に関係する tools, README.md, AGENTS.md, docs/operations
- 影響する仕様: 分離運用、導入手順、パス解決規約
- 非機能影響: 外部導入の再現性と保守性が向上する

## 7. 制約とリスク (Constraints & Risks) (必須)

- 制約: 単一リポジトリ構成を維持する
- 想定リスク:
  - 参照先分離で読解順が複雑化する
  - 旧参照の残存によりルール解釈が割れる
- 回避策: 段階タスク化と depends_on gate により変更影響を局所化する

## 8. 未確定事項 (Open Issues) (必須)

- package 化の実施タイミングは未定。移行は別 task で判断する。

## 9. 関連資料リンク (Reference Links) (必須)

- request: work/2026-02-20__split-framework-runtime-rules-from-agents/request.md
- investigation: work/2026-02-20__split-framework-runtime-rules-from-agents/investigation.md
- plan: work/2026-02-20__split-framework-runtime-rules-from-agents/plan.md
- review: work/2026-02-20__split-framework-runtime-rules-from-agents/review.md
- docs:
  - `docs/operations/high-priority-backlog.md`

