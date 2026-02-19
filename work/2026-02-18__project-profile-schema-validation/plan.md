# Plan: 2026-02-18__project-profile-schema-validation

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 1. 対象仕様

- `work/2026-02-18__project-profile-schema-validation/spec.md`

## 2. Execution Commands

- validate profile: `pwsh -NoProfile -File tools/profile-validate/validate.ps1 -ProfilePath project.profile.yaml`

## 3. 実施ステップ

1. profile validator を実装する
2. 必須キー・禁止値検証を追加する
3. CI workflow に組み込む
4. docs / review / state を更新する

## 4. 変更対象ファイル

- `tools/profile-validate/validate.ps1`
- `.github/workflows/ci-framework.yml`
- `docs/specs/automation-tools-design-spec.md`
- `docs/INDEX.md`
- `work/2026-02-18__project-profile-schema-validation/*`

## 5. リスクとロールバック

- リスク: パース実装差異で誤判定
- ロールバック: validator を warning モードで暫定運用

## 6. 完了判定

- AC-001〜AC-004 をすべて PASS

## 7. 実装実行計画（2026-02-18T21:29:20+09:00）

1. `tools/profile-validate/validate.ps1` を新規作成し、必須キーと禁止値の検証を実装する。
2. workflow に profile validator step を追加して、checker 前に fail-fast させる。
3. CI 仕様 docs を validator 導入後の手順へ更新する。
4. 正常/欠落/TODO_SET_ME ケースを検証し、review/state を更新する。
