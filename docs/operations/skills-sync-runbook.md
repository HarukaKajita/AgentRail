# Skills Sync Runbook

## 目的

`agents/skills` の変更を `~/.agents/skills` に安全に同期し、実運用スキルを最新化する。

## 対象スクリプト

- `tools/skills-sync/sync.ps1`

## 基本コマンド

### 1. 全スキルのドライラン

```powershell
pwsh -NoProfile -File tools/skills-sync/sync.ps1 -WhatIf
```

### 2. 全スキル同期

```powershell
pwsh -NoProfile -File tools/skills-sync/sync.ps1
```

### 3. 指定スキルのみ同期

```powershell
pwsh -NoProfile -File tools/skills-sync/sync.ps1 -SkillNames write_spec,write_plan
```

### 4. 余剰ファイル削除付き同期

```powershell
pwsh -NoProfile -File tools/skills-sync/sync.ps1 -DeleteExtraneous
```

## 引数仕様

- `-SourceRoot` (default: `agents/skills`)
- `-TargetRoot` (default: `$HOME/.agents/skills`)
- `-SkillNames` (optional)
- `-DeleteExtraneous` (optional)
- `-WhatIf` (optional)

## 実行前チェック

1. `agents/skills/<skill>/SKILL.md` が存在する。
2. 追加した `references` / `scripts` がリポジトリ上で確認できる。
3. 同期先に上書きして問題ないことを確認した。

## 実行後チェック

1. 出力に `Errors` が無い。
2. `Total synced` が期待値と一致する。
3. `~/.agents/skills/<skill>/` に更新内容が反映される。

## 障害対応

### Case 1: Skill not found in source

- 原因: `-SkillNames` に存在しない名前を指定
- 対応: `agents/skills` 配下のディレクトリ名を再確認

### Case 2: 権限エラー

- 原因: 同期先ディレクトリの書込権限不足
- 対応: 権限を確認し、必要なら管理者権限で再実行

### Case 3: 想定外の削除

- 原因: `-DeleteExtraneous` を付けて実行
- 対応: まず `-WhatIf` で削除対象を確認してから本実行する

## 安全運用ルール

- 初回は必ず `-WhatIf` を実行する。
- `-DeleteExtraneous` は理由がある場合のみ使う。
- 同期後は対象スキルで最低1回の実行確認を行う。
