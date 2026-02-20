param(
    [string]$Root = "."
)

$files = Get-ChildItem -Path $Root -Recurse -Filter "*.md"
$encoding = [System.Text.Encoding]::UTF8

foreach ($file in $files) {
    if ($file.FullName -match "node_modules") { continue }
    if ($file.FullName -match "\.git") { continue }

    $content = Get-Content -LiteralPath $file.FullName -Raw -Encoding UTF8
    $originalContent = $content
    
    # Common replacements
    $content = $content -replace "\[空欄禁止\]", "(必須)"
    $content = $content -replace "(?m)^##\s+前提知識(?:\s*\(Prerequisites.*?\))?.*$", "## 0. 前提知識 (Prerequisites) (必須)"

    # spec.md replacements
    if ($file.Name -eq "spec.md" -or $content -match "### 5.1 Unit Test" -or $content -match "### 5.1 単体テスト") {
        $content = $content -replace "(?m)^### 5.1 (?:Unit Test|単体テスト).*$", "### 5.1 単体テスト (Unit Test) (必須)"
        $content = $content -replace "(?m)^### 5.2 (?:Integration Test|結合テスト).*$", "### 5.2 結合テスト (Integration Test) (必須)"
        $content = $content -replace "(?m)^### 5.3 (?:Regression Test|回帰テスト).*$", "### 5.3 回帰テスト (Regression Test) (必須)"
        $content = $content -replace "(?m)^### 5.4 (?:Manual Verification|手動検証).*$", "### 5.4 手動検証 (Manual Verification) (必須)"
        
        # Fix previous migration if any
        $content = $content -replace "(?m)^(\s*-\s*)(対象|観点|検証項目|合格条件|合格基準|手順|検証手順|期待結果|期待される結果):", '$1**$2**:'
        # Normalize keys to new ones inside bold
        $content = $content -replace "\*\*観点\*\*:", "**検証項目**:"
        $content = $content -replace "\*\*合格条件\*\*:", "**合格基準**:"
        $content = $content -replace "\*\*手順\*\*:", "**検証手順**:"
        $content = $content -replace "\*\*期待結果\*\*:", "**期待される結果**:"
        
        $content = $content -replace "(?m)^## 9. 関連資料リンク.*$", "## 9. 関連資料リンク (Reference Links) (必須)"
        
        # Structural headers for specs
        $content = $content -replace "(?m)^## 1. メタ情報.*$", "## 1. メタ情報 (Metadata) (必須)"
        $content = $content -replace "(?m)^## 2. 背景と目的.*$", "## 2. 背景と目的 (Background & Objectives) (必須)"
        $content = $content -replace "(?m)^## 3. スコープ.*$", "## 3. スコープ (Scope) (必須)"
        $content = $content -replace "(?m)^## 4. 受入条件.*$", "## 4. 受入条件 (Acceptance Criteria) (必須)"
        $content = $content -replace "(?m)^## 5. テスト要件.*$", "## 5. テスト要件 (Test Requirements) (必須)"
        $content = $content -replace "(?m)^## 6. 影響範囲.*$", "## 6. 影響範囲 (Impact Assessment) (必須)"
        $content = $content -replace "(?m)^## 7. 制約とリスク.*$", "## 7. 制約とリスク (Constraints & Risks) (必須)"
        $content = $content -replace "(?m)^## 8. 未確定事項.*$", "## 8. 未確定事項 (Open Issues) (必須)"
    }

    # plan.md replacements
    if ($file.Name -eq "plan.md" -or $content -match "## 2. plan-draft" -or $content -match "## 2. Execution Commands") {
        if (-not ($content -match "Plan Draft")) {
            $content = $content -replace "(?m)^## 2. Execution Commands", "## 5. 実行コマンド (Execution Commands)"
            $content = $content -replace "(?m)^## 3. 実施ステップ", "## 4. 確定実装計画 (Plan Final)"
            
            # Insert missing ## 2 and ## 3 sections after ## 1
            if ($content -match "(?m)^## 1. 対象仕様") {
                 $content = $content -replace "(?m)(^## 1. 対象仕様.*?\r?\n(?:.*?\r?\n)*?)(?=## )", 
                     ('$1' + "`n## 2. 実装計画ドラフト (Plan Draft)`n`n- 目的: 既存資料の移行と整合性確保`n- 実施項目:`n  1. 既存ドキュメントの構造修正`n- 成果物: 更新済み Markdown ファイル`n`n## 3. 依存関係ゲート (Depends-on Gate)`n`n- 依存: なし`n- 判定方針: 直接移行`n")
            }
        }
        $content = $content -replace "(?m)^## 2. plan-draft.*$", "## 2. 実装計画ドラフト (Plan Draft)"
        $content = $content -replace "(?m)^## 4. plan-final.*$", "## 4. 確定実装計画 (Plan Final)"
    }

    # review.md replacements
    if ($file.Name -eq "review.md" -or $content -match "## 6. Process Findings") {
        $content = $content -replace "(?m)^## 6. Process Findings.*$", "## 6. プロセス改善案 (Process Findings) (必須)"
        $content = $content -replace "(?m)^## 7. Commit Boundaries.*$", "## 7. コミット境界の確認 (Commit Boundaries) (必須)"
        
        # Subsections in Commit Boundaries
        $content = $content -replace "(?m)^### 7.1 Kickoff Commit.*$", "### 7.1 起票境界 (Kickoff Commit)"
        $content = $content -replace "(?m)^### 7.2 Implementation Commit.*$", "### 7.2 実装境界 (Implementation Commit)"
        $content = $content -replace "(?m)^### 7.3 Finalize Commit.*$", "### 7.3 完了境界 (Finalize Commit)"
    }
    
    # investigation.md replacements (Generic attempt)
    if ($file.Name -eq "investigation.md" -or $content -match "## 1. 調査対象") {
         $content = $content -replace "(?m)^## 1. 調査対象.*$", "## 1. 調査対象 (Investigation Target) (必須)"
         $content = $content -replace "(?m)^## 2. 仮説.*$", "## 2. 仮説 (Hypothesis) (必須)"
         $content = $content -replace "(?m)^## 3. 調査方法.*$", "## 3. 調査・観測方法 (Investigation Method) (必須)"
         $content = $content -replace "(?m)^## 4. 調査結果.*$", "## 4. 調査・観測結果 (Observations) (必須)"
         $content = $content -replace "(?m)^## 5. 結論.*$", "## 5. 結論 (Conclusion) (必須)"
         $content = $content -replace "(?m)^## 6. 未解決事項.*$", "## 6. 未解決事項 (Open Issues) (必須)"
         $content = $content -replace "(?m)^## 7. 次アクション.*$", "## 7. 次のアクション (Next Action) (必須)"
         $content = $content -replace "(?m)^## 8. 関連リンク.*$", "## 8. 関連資料リンク (Reference Links) (必須)"
    }

    if ($content -ne $originalContent) {
        Write-Host "Updating: $($file.FullName)"
        Set-Content -LiteralPath $file.FullName -Value $content -Encoding UTF8 -NoNewline
    }
}
