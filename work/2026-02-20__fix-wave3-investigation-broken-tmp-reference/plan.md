# Plan: 2026-02-20__fix-wave3-investigation-broken-tmp-reference

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
  - `work/2026-02-20__fix-wave3-investigation-broken-tmp-reference/spec.md`
- 理解ポイント:
  - 起票段階では plan-draft までを確定し、実装順序の最終化は depends_on gate 後に行う。

## 1. 対象仕様

- `work/2026-02-20__fix-wave3-investigation-broken-tmp-reference/spec.md`

## 2. plan-draft

- 目的:
  - task12 investigation の参照切れを解消し、再発防止ルールを確定する。
- 実施項目:
  1. task12 investigation の該当記述を恒久参照表現へ修正する。
  2. 必要に応じて運用 docs の記述ルールを補足する。
  3. task12 単体 + 全体 checker を再実行して結果を確認する。
- 成果物:
  - 修正済み investigation
  - 検証ログ（checker PASS）

## 3. depends_on gate

- 依存: なし
- 判定方針: 依存なしのため `plan-ready`。
- 判定結果: pass（起票時点）

## 4. plan-final

- 実装順序:
  - kickoff 段階のため未確定。depends_on gate 後に確定する。
- 検証順序:
  - kickoff 段階のため未確定。depends_on gate 後に確定する。
- ロールバック:
  - fail が残る場合は修正差分を戻し、参照表現を再設計する。

## 5. Execution Commands

- `pwsh -NoProfile -File tools/consistency-check/check.ps1 -TaskId 2026-02-20__fix-wave3-investigation-broken-tmp-reference -DocQualityMode warning`
- `pwsh -NoProfile -File tools/state-validate/validate.ps1 -TaskId 2026-02-20__fix-wave3-investigation-broken-tmp-reference -DocQualityMode warning`
- `pwsh -NoProfile -File tools/commit-boundary/check-staged-files.ps1 -TaskId 2026-02-20__fix-wave3-investigation-broken-tmp-reference -Phase kickoff -AllowCommonSharedPaths`

## 6. 完了判定

- plan-draft が spec を参照している。
- backlog/state の planned 記述が整合している。
- kickoff 境界コミットの scope check が PASS。
