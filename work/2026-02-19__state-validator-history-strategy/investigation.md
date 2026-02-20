# Investigation: 2026-02-19__state-validator-history-strategy

## 0. 前提知識 (Prerequisites) (必須)

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 1. 調査対象 (Investigation Target) (必須)

- Source task 2026-02-18__state-transition-validation の finding F-001 の根本原因分析。

## 2. 仮説 (Hypothesis) (必須)

- state history の保存先を `state.json` ではなく Git 履歴に統一し、validator で `history` キー混入を防げば運用一貫性を保てる。

## 3. 調査・観測方法 (Investigation Method) (必須)

- 参照資料:
  - work/2026-02-18__state-transition-validation/review.md
  - tools/state-validate/validate.ps1
  - docs/operations/high-priority-backlog.md
- 実施した確認:
  - 現行 state validator が state history をどのように扱っているかを確認する。
  - `state.json` の構造を拡張した場合の運用コストを確認する。
  - history を `state.json` 内保持する案と外部化する案の影響を比較する。

## 4. 調査・観測結果 (Observations) (必須)

- 現行 `state.json` は `state` / `owner` / `updated_at` / `blocking_issues` の最小セットで運用されている。
- `tools/state-validate/validate.ps1` は extra key を許容しており、history キーが混入しても検知しない。
- history を `state.json` 内へ保持すると肥大化・競合・整形コストが増えるため、Git 履歴を正として外部化する方が運用負荷が低い。

## 5. 結論 (Conclusion) (必須)

- state history 管理方式は「外部化（Git 履歴を正）」を採用する。
- `state.json` は最新スナップショット専用とし、`history` / `state_history` キーは非推奨ではなく禁止扱いにする。
- state validator に禁止キー検知を追加し、docs へ方針と参照手順を記録する。

## 6. 未解決事項 (Open Issues) (必須)

- 将来、Git 以外の履歴ストア（専用 artifact）を導入する場合の移行手順。

## 7. 次のアクション (Next Action) (必須)

1. state validator に history キー禁止ルールを追加する。
2. history キーを含む一時 `state.json` を作成し、FAIL を確認する。
3. 運用方針 docs と backlog 状態を更新する。

## 8. 関連資料リンク (Reference Links) (必須)

- request: work/2026-02-19__state-validator-history-strategy/request.md
- spec: work/2026-02-19__state-validator-history-strategy/spec.md
- source review: work/2026-02-18__state-transition-validation/review.md
