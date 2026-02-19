# Skills Sync Runbook

## 前提知識 (Prerequisites / 前提知識) [空欄禁止]

- 参照資料:
  - `AGENTS.md`
  - `docs/INDEX.md`
- 理解ポイント:
  - 本資料に入る前に、目的・受入条件・依存関係を把握する。


## 目的

`agents/skills` の変更を `./.agents/skills` に安全に同期し、リポジトリ内の運用スキルを最新化する。

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
pwsh -NoProfile -File tools/skills-sync/sync.ps1 -SkillNames Rail5-write-spec,Rail6-write-plan
```

### 4. 余剰ファイル削除付き同期

```powershell
pwsh -NoProfile -File tools/skills-sync/sync.ps1 -DeleteExtraneous
```

## 引数仕様

- `-SourceRoot` (default: `agents/skills`)
- `-TargetRoot` (default: `.agents/skills`)
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
3. `.agents/skills/<skill>/` に更新内容が反映される。

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

## セッション中再読み込み可否

`codex --help` と `claude --help` の確認時点では、セッション中にスキルだけを再読み込みする専用コマンドは確認できない。

そのため、同期後は CLI セッションを再起動して反映する。

### Codex CLI の反映手順

1. 現在のセッションを終了する（例: `Ctrl+C`）。
2. リポジトリルートで同期を実行する。
   - `pwsh -NoProfile -File tools/skills-sync/sync.ps1`
3. 新しいセッションを開始する。
   - `codex`
4. 反映確認を行う。
   - 変更したスキル名を明示して要求を実行し、更新後の挙動を確認する。

### Claude Code の反映手順

1. 現在のセッションを終了する。
2. リポジトリルートで同期を実行する。
   - `pwsh -NoProfile -File tools/skills-sync/sync.ps1`
3. 新しいセッションを開始する。
   - `claude`
4. 反映確認を行う。
   - 変更したスキル名を明示して要求を実行し、更新後の挙動を確認する。

### 注意

- 反映確認を確実にするため、再開オプション（例: `claude --continue` / `claude --resume` / `codex resume`）ではなく新規セッションを推奨する。
