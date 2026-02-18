param(
  [string]$DocsRoot = "docs",
  [string]$IndexPath = "docs/INDEX.md"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Fail([string]$Message) {
  Write-Error $Message
  exit 1
}

function Get-ManagedSection {
  param(
    [string]$Content,
    [string]$Heading
  )

  $pattern = "(?ms)(^" + [Regex]::Escape($Heading) + "\r?\n)(.*?)(?=^##\s+\d+\.\s+|\z)"
  $match = [Regex]::Match($Content, $pattern)
  if (-not $match.Success) {
    Fail("Managed section not found in INDEX: $Heading")
  }

  return [PSCustomObject]@{
    Prefix = $match.Groups[1].Value
    Body = $match.Groups[2].Value
  }
}

function Set-ManagedSection {
  param(
    [string]$Content,
    [string]$Heading,
    [string]$Body
  )

  $pattern = "(?ms)(^" + [Regex]::Escape($Heading) + "\r?\n)(.*?)(?=^##\s+\d+\.\s+|\z)"
  $replaced = [Regex]::Replace(
    $Content,
    $pattern,
    {
      param($m)
      return $m.Groups[1].Value + $Body
    },
    1
  )

  return $replaced
}

function Parse-EntriesFromBody {
  param(
    [string]$Body
  )

  $entries = @{}
  $matches = [Regex]::Matches($Body, '(?m)^\s*-\s+`([^`]+)`\s+-\s+(.+?)\s*$')
  foreach ($match in $matches) {
    $path = $match.Groups[1].Value.Trim()
    $entries[$path] = $match.Value.Trim()
  }
  return $entries
}

if (-not (Test-Path -LiteralPath $IndexPath)) {
  Fail("docs-indexer: INDEX file not found: $IndexPath")
}

$repoRoot = (Resolve-Path ".").Path
$indexContent = Get-Content -LiteralPath $IndexPath -Raw
$newline = if ($indexContent.Contains("`r`n")) { "`r`n" } else { "`n" }

$targets = @(
  @{ Heading = "## 2. テンプレート"; RelativeDir = "templates" },
  @{ Heading = "## 3. 仕様"; RelativeDir = "specs" },
  @{ Heading = "## 4. 意思決定"; RelativeDir = "decisions" },
  @{ Heading = "## 5. 調査"; RelativeDir = "investigations" },
  @{ Heading = "## 6. 運用"; RelativeDir = "operations" }
)

$parseErrors = New-Object System.Collections.Generic.List[string]
$nameMap = @{}
$generatedByHeading = @{}

foreach ($target in $targets) {
  $heading = [string]$target.Heading
  $relativeDir = [string]$target.RelativeDir
  $directoryPath = Join-Path -Path $DocsRoot -ChildPath $relativeDir
  $lines = New-Object System.Collections.Generic.List[string]

  if (Test-Path -LiteralPath $directoryPath) {
    $files = Get-ChildItem -LiteralPath $directoryPath -File -Filter "*.md" | Sort-Object FullName
    foreach ($file in $files) {
      $relativePath = [System.IO.Path]::GetRelativePath($repoRoot, $file.FullName).Replace("\", "/")
      $key = $file.Name
      if ($nameMap.ContainsKey($key)) {
        $parseErrors.Add("Duplicate markdown filename detected: $key ($($nameMap[$key]) / $relativePath)")
        continue
      }
      $nameMap[$key] = $relativePath

      try {
        $fileContent = Get-Content -LiteralPath $file.FullName -Raw
      } catch {
        $parseErrors.Add("Failed to read markdown file: $relativePath")
        continue
      }

      $titleMatch = [Regex]::Match($fileContent, "(?m)^\s*#\s+(.+?)\s*$")
      if (-not $titleMatch.Success) {
        $parseErrors.Add("Markdown title not found: $relativePath")
        continue
      }

      $title = $titleMatch.Groups[1].Value.Trim()
      $lines.Add("- ``$relativePath`` - $title")
    }
  }

  if ($lines.Count -eq 0) {
    $lines.Add("- （未登録）")
  }

  $sectionBody = ($lines -join $newline) + $newline + $newline
  $generatedByHeading[$heading] = $sectionBody
}

if ($parseErrors.Count -gt 0) {
  Write-Output "docs-indexer: FAIL"
  foreach ($errorMessage in $parseErrors) {
    Write-Output "- $errorMessage"
  }
  exit 1
}

$allAdded = New-Object System.Collections.Generic.List[string]
$allUpdated = New-Object System.Collections.Generic.List[string]
$allRemoved = New-Object System.Collections.Generic.List[string]

foreach ($target in $targets) {
  $heading = [string]$target.Heading
  $existingSection = Get-ManagedSection -Content $indexContent -Heading $heading
  $oldEntries = Parse-EntriesFromBody -Body $existingSection.Body
  $newEntries = Parse-EntriesFromBody -Body $generatedByHeading[$heading]

  foreach ($newKey in ($newEntries.Keys | Sort-Object)) {
    if (-not $oldEntries.ContainsKey($newKey)) {
      $allAdded.Add($newKey)
      continue
    }
    if ($oldEntries[$newKey] -ne $newEntries[$newKey]) {
      $allUpdated.Add($newKey)
    }
  }

  foreach ($oldKey in ($oldEntries.Keys | Sort-Object)) {
    if (-not $newEntries.ContainsKey($oldKey)) {
      $allRemoved.Add($oldKey)
    }
  }

  $indexContent = Set-ManagedSection -Content $indexContent -Heading $heading -Body $generatedByHeading[$heading]
}

Set-Content -LiteralPath $IndexPath -Value $indexContent -NoNewline

Write-Output "docs-indexer: PASS"
Write-Output "Summary:"
Write-Output "  Added: $($allAdded.Count)"
foreach ($entry in ($allAdded | Sort-Object)) {
  Write-Output "    + $entry"
}
Write-Output "  Updated: $($allUpdated.Count)"
foreach ($entry in ($allUpdated | Sort-Object)) {
  Write-Output "    ~ $entry"
}
Write-Output "  Removed: $($allRemoved.Count)"
foreach ($entry in ($allRemoved | Sort-Object)) {
  Write-Output "    - $entry"
}
