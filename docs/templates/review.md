# レビュー・検証報告書 (Review & Verification Report)

本ファイルは、`spec.md` で定義された受入条件とテスト要件に基づく検証結果を記録する。`work/<task-id>/review.md` として利用すること。

---

## 0. 前提知識 (Prerequisites) (必須)

*検証を開始する前に、確認すべき背景知識や参照資料、検証の観点を整理する。*

- **参照資料**:
  - `AGENTS.md` (フレームワーク基本ルール)
  - `docs/INDEX.md` (ドキュメントインデックス)
- **理解ポイント**:
  - [例: `spec.md` の AC-001 が今回の主要な検証対象であることを理解していること]
  - [例: 特定の検証用環境（スタブ、モック等）が準備されていること]

## 1. レビュー対象 (Review Target) (必須)

- [実装されたファイル、ドキュメント、または特定の機能を記載]

## 2. 受入条件の達成状況 (Acceptance Criteria Evaluation) (必須)

- **AC-001**: [PASS / FAIL / PENDING] (理由やエビデンスを簡潔に追記)
- **AC-002**: [PASS / FAIL / PENDING]

## 3. テスト・検証結果 (Test Results) (必須)

### 単体テスト (Unit Test)
- **実施内容**: [実施したテストスイートやケースを記載]
- **結果**: [PASS / FAIL / PENDING]

### 結合テスト (Integration Test)
- **実施内容**: [モジュール間連携や API の検証内容を記載]
- **結果**: [PASS / FAIL / PENDING]

### 回帰テスト (Regression Test)
- **実施内容**: [既存機能への影響がないことを確認した内容を記載]
- **結果**: [PASS / FAIL / PENDING]

### 手動検証 (Manual Verification)
- **実施内容**: [実際の画面操作やコマンド実行による確認手順を記載]
- **結果**: [PASS / FAIL / PENDING]

## 4. 指摘事項 (Review Findings) (必須)

- **重大な不備**: [修正が必須の項目を記載。ない場合は「なし」]
- **改善提案/マイナーな修正**:
  - [将来的なリファクタリング案や、細かな使い勝手の改善点などを記載]

## 5. 最終結論 (Conclusion) (必須)

- [タスクが完了 (done) とみなせるか、または再修正が必要かの最終判断を記載]

## 6. プロセス改善案 (Process Findings) (必須)

*開発プロセスそのものを改善するための気づきを記録する（自動ツールによる抽出対象）。*

### 6.1 Finding F-001
- **finding_id**: F-001
- **category**: [flow / documentation / tooling / etc.]
- **severity**: [must / high / low]
- **summary**: [プロセスの問題点や改善案の要約を記載]
- **evidence**: [そのように判断した根拠や事例を記載]
- **action_required**: [yes / no]
- **linked_task_id**: [フォローアップタスクを作成した場合はその ID を記載。ない場合は none]

## 7. コミット境界の確認 (Commit Boundaries) (必須)

### 7.1 起票境界 (Kickoff Commit)
- **commit**: [コミットハッシュ、または PENDING]
- **scope_check**: [対象タスクの範囲内に収まっているか確認結果を記載]

### 7.2 実装境界 (Implementation Commit)
- **commit**: [コミットハッシュ、または PENDING]
- **scope_check**: [検証結果を反映した適切なコミットであることを確認]

### 7.3 完了境界 (Finalize Commit)
- **commit**: [コミットハッシュ、または PENDING]
- **scope_check**: [すべてのドキュメントと状態が最新であることを確認]
