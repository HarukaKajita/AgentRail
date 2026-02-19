# Investigation: 2026-02-19__task-dependency-aware-prioritization-flow

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 1. 調査対象 [空欄禁止]

- 現行フレームワークにタスク依存関係を保持するデータモデルがあるか。
- 起票時・着手時に依存関係確認を強制する仕組みがあるか。
- backlog 表示と Rail10 スキル表示で依存関係を可視化できるか。

## 2. 仮説 (Hypothesis / 仮説) [空欄禁止]

- state/backlog/スキル表示に依存情報を統一して追加し、起票時調査と着手時ゲートを組み合わせれば、先行タスク優先の運用を継続的に実現できる。

## 3. 調査方法 (Observation Method / 観測方法) [空欄禁止]

- 参照資料:
  - `tools/state-validate/validate.ps1`
  - `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/scripts/list_planned_tasks.ps1`
  - `.agents/skills/Rail10-list-planned-tasks-by-backlog-priority/SKILL.md`
  - `docs/operations/high-priority-backlog.md`
  - `tools/improvement-harvest/create-task.ps1`
- 実施した確認:
  - state validator の required key が `state` / `owner` / `updated_at` / `blocking_issues` のみであることを確認。
  - Rail10 スクリプトは planned 状態と backlog 順のみで並べており、依存関係判定を行っていないことを確認。
  - high-priority backlog に依存関係表示欄がないことを確認。
  - 起票生成スクリプトは依存調査や依存先起票を実施していないことを確認。

## 4. 調査結果 (Observations / 観測結果) [空欄禁止]

- 事実:
  - 現行フレームワークにタスク依存関係の標準フィールドは未組み込み。
  - 起票時依存調査、着手時依存ゲート、依存可視化は未実装。
  - `blocking_issues` は blocked 状態の理由保持であり、依存 DAG の表現には使われていない。
- 推測:
  - 依存管理を追加する際は、状態管理（state）、優先表示（backlog/Rail10）、運用ルール（skills/docs）を同時に定義しないと整合が崩れやすい。

## 5. 提案オプション（3案） [空欄禁止]

1. 最小:
   - backlog 文面に依存メモを追記し、手動で優先度調整する。
2. バランス:
   - state.json に依存配列を追加し、着手前チェックを導入する。
   - backlog と Rail10 へ依存表示を追加する。
3. 強化（採用）:
   - バランス案 + 起票時依存調査ルール + 依存不足時の追加起票方針 + 循環依存検知 + docs/skill運用更新まで仕様化する。

## 6. 推奨案 [空欄禁止]

- 採用: オプション3（強化）
- 理由:
  - ユーザー要望がワークフロー全体改善であり、単一箇所の改修では目的を満たせないため。
  - 依存循環や missing task を先に仕様へ織り込むことで、実装後の運用停止リスクを下げられるため。

## 7. 結論 (Conclusion / 結論) [空欄禁止]

- 本タスクでは、依存関係モデル、起票時調査、着手時ゲート、backlog可視化、Rail10表示拡張を一体の要件として確定する。
- 依存関係の解決済み判定を「依存先 task の state=done」と定義し、未解決時は着手対象を切り替える運用を標準化する。

## 8. 未解決事項 [空欄禁止]

- なし（要件化段階での判断材料は揃っている）。

## 9. 次アクション [空欄禁止]

1. `work/2026-02-19__task-dependency-aware-prioritization-flow/spec.md` で AC とテスト要件を確定する。
2. `work/2026-02-19__task-dependency-aware-prioritization-flow/plan.md` で実装順序とロールバックを定義する。
3. backlog と memory を起票状態に更新する。

## 10. 確認質問（2〜4件） [空欄禁止]

- なし。

## 11. blocked 判定 [空欄禁止]

- blocked ではない。

## 12. 関連リンク [空欄禁止]

- request: `work/2026-02-19__task-dependency-aware-prioritization-flow/request.md`
- spec: `work/2026-02-19__task-dependency-aware-prioritization-flow/spec.md`
