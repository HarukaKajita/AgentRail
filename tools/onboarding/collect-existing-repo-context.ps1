param(
  [string]$RepoRoot = ".",
  [string]$OutputDir = "artifacts/onboarding",
  [string]$ProfilePath = "project.profile.yaml",
  [int]$MaxFiles = 2000,
  [int]$MaxFileBytes = 65536,
  [switch]$DryRun
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

. (Join-Path -Path $PSScriptRoot -ChildPath "../common/profile-paths.ps1")

function Fail {
  param([string]$Message)
  Write-Error "onboarding-collect: $Message"
  exit 1
}

function Normalize-RelPath {
  param(
    [string]$RepoRootFullPath,
    [string]$FullPath
  )

  $rel = [System.IO.Path]::GetRelativePath($RepoRootFullPath, $FullPath)
  return (ConvertTo-NormalizedRepoPath -PathValue $rel)
}

function Should-ExcludeDirectoryName {
  param([string]$DirectoryName)
  if ([string]::IsNullOrWhiteSpace($DirectoryName)) {
    return $false
  }

  $name = $DirectoryName.Trim()
  return $name -in @(
    ".git",
    ".svn",
    ".hg",
    "node_modules",
    "dist",
    "build",
    "out",
    ".venv",
    "venv",
    "__pycache__",
    ".pytest_cache",
    ".mypy_cache",
    ".tox",
    ".agentrail",
    "work",
    "artifacts",
    ".tmp"
  )
}

function Should-ExcludeFilePath {
  param([string]$RelativePath)

  $p = (ConvertTo-NormalizedRepoPath -PathValue $RelativePath).ToLowerInvariant()
  if ([string]::IsNullOrWhiteSpace($p)) {
    return $true
  }

  # Keep the collector non-sensitive by default.
  if ($p -match '(^|/)\.env(\.|$)') { return $true }
  if ($p -match '(^|/)\.env\..+') { return $true }
  if ($p -match '(^|/)secrets?(/|$)') { return $true }

  $ext = [System.IO.Path]::GetExtension($p)
  if ($ext -in @(".key", ".pem", ".pfx", ".p12", ".kdb", ".jks")) { return $true }

  return $false
}

function Get-ExtensionHistogram {
  param([string[]]$Paths)

  $map = @{}
  foreach ($path in $Paths) {
    $ext = [System.IO.Path]::GetExtension($path).ToLowerInvariant()
    if ([string]::IsNullOrWhiteSpace($ext)) { $ext = "(none)" }
    if (-not $map.ContainsKey($ext)) { $map[$ext] = 0 }
    $map[$ext]++
  }

  return $map.GetEnumerator() | Sort-Object -Property Value -Descending | ForEach-Object {
    [PSCustomObject]@{ ext = $_.Key; count = $_.Value }
  }
}

$repoRootFull = (Resolve-Path -LiteralPath $RepoRoot).Path
if (-not (Test-Path -LiteralPath $repoRootFull -PathType Container)) {
  Fail("RepoRoot does not exist: $RepoRoot")
}

$resolvedProfilePath = Join-Path -Path $repoRootFull -ChildPath $ProfilePath
Push-Location -LiteralPath $repoRootFull
try {
  $workflowPaths = Resolve-WorkflowPaths -ProfilePath $resolvedProfilePath -DefaultTaskRoot "work" -DefaultDocsRoot "docs"
} finally {
  Pop-Location
}

$files = New-Object System.Collections.Generic.List[object]
$skipped = New-Object System.Collections.Generic.List[string]

$queue = New-Object System.Collections.Generic.Queue[System.IO.DirectoryInfo]
$queue.Enqueue([System.IO.DirectoryInfo]::new($repoRootFull))

while ($queue.Count -gt 0) {
  $dir = $queue.Dequeue()

  # Skip excluded directories, but always include the repo root.
  if ($dir.FullName -ne $repoRootFull -and (Should-ExcludeDirectoryName -DirectoryName $dir.Name)) {
    continue
  }

  $children = @()
  try {
    $children = Get-ChildItem -LiteralPath $dir.FullName -Force -ErrorAction Stop
  } catch {
    $skipped.Add((Normalize-RelPath -RepoRootFullPath $repoRootFull -FullPath $dir.FullName) + " (unreadable)") | Out-Null
    continue
  }

  foreach ($child in $children) {
    if ($child.PSIsContainer) {
      $queue.Enqueue([System.IO.DirectoryInfo]::new($child.FullName))
      continue
    }

    $rel = Normalize-RelPath -RepoRootFullPath $repoRootFull -FullPath $child.FullName
    if (Should-ExcludeFilePath -RelativePath $rel) {
      continue
    }

    if ($files.Count -ge $MaxFiles) {
      $skipped.Add("... truncated: MaxFiles=$MaxFiles") | Out-Null
      break
    }

    $files.Add([PSCustomObject]@{
      path = $rel
      bytes = [int64]$child.Length
      modified_at = ($child.LastWriteTimeUtc.ToString("o"))
    }) | Out-Null
  }

  if ($files.Count -ge $MaxFiles) {
    break
  }
}

$allPaths = @($files | ForEach-Object { $_.path })
$docPaths = @($allPaths | Where-Object { $_ -like "docs/*" -or $_ -in @("README.md", "AGENTS.md", "CLAUDE.md", "MEMORY.md", "project.profile.yaml") })
$toolPaths = @($allPaths | Where-Object { $_ -like "tools/*" })

$context = [PSCustomObject]@{
  schema_version = "1.0.0"
  generated_at = (Get-Date -Format "yyyy-MM-ddTHH:mm:ssK")
  repo_root = (ConvertTo-NormalizedRepoPath -PathValue $RepoRoot)
  workflow = [PSCustomObject]@{
    profile_path = (ConvertTo-NormalizedRepoPath -PathValue $ProfilePath)
    profile_found = [bool]$workflowPaths.profile_found
    profile_loaded = [bool]$workflowPaths.profile_loaded
    task_root = $workflowPaths.task_root
    docs_root = $workflowPaths.docs_root
    runtime_root = $workflowPaths.runtime_root
  }
  summary = [PSCustomObject]@{
    file_count = $files.Count
    max_files = $MaxFiles
    extensions = @(Get-ExtensionHistogram -Paths $allPaths)
    docs_file_count = $docPaths.Count
    tools_file_count = $toolPaths.Count
  }
  docs = [PSCustomObject]@{
    important_paths = @(
      "AGENTS.md",
      "docs/INDEX.md",
      "docs/operations/high-priority-backlog.md"
    )
    files = @($files | Where-Object { $_.path -in $docPaths } | Sort-Object path)
  }
  tools = [PSCustomObject]@{
    files = @($files | Where-Object { $_.path -in $toolPaths } | Sort-Object path)
  }
  skipped = @($skipped)
}

$outputDirFull = Join-Path -Path $repoRootFull -ChildPath $OutputDir
$contextJsonPath = Join-Path -Path $outputDirFull -ChildPath "context.json"
$contextMdPath = Join-Path -Path $outputDirFull -ChildPath "context.md"

$md = New-Object System.Collections.Generic.List[string]
$md.Add("# Existing Repo Context (Collected)") | Out-Null
$md.Add("") | Out-Null
$md.Add("generated_at: $($context.generated_at)") | Out-Null
$md.Add("repo_root: $repoRootFull") | Out-Null
$md.Add("") | Out-Null
$md.Add("## Workflow") | Out-Null
$md.Add("") | Out-Null
$md.Add("- profile_found: $($context.workflow.profile_found)") | Out-Null
$md.Add("- profile_loaded: $($context.workflow.profile_loaded)") | Out-Null
$md.Add("- task_root: $($context.workflow.task_root)") | Out-Null
$md.Add("- docs_root: $($context.workflow.docs_root)") | Out-Null
$md.Add("- runtime_root: $($context.workflow.runtime_root)") | Out-Null
$md.Add("") | Out-Null
$md.Add("## Summary") | Out-Null
$md.Add("") | Out-Null
$md.Add("- file_count: $($context.summary.file_count) (max=$MaxFiles)") | Out-Null
$md.Add("- docs_file_count: $($context.summary.docs_file_count)") | Out-Null
$md.Add("- tools_file_count: $($context.summary.tools_file_count)") | Out-Null
$md.Add("") | Out-Null
$md.Add("## Extensions (Top)") | Out-Null
$md.Add("") | Out-Null
foreach ($item in ($context.summary.extensions | Select-Object -First 20)) {
  $md.Add("- $($item.ext): $($item.count)") | Out-Null
}
$md.Add("") | Out-Null
$md.Add("## Docs Files (Sample)") | Out-Null
$md.Add("") | Out-Null
foreach ($doc in (($context.docs.files | Select-Object -First 50))) {
  $md.Add("- $($doc.path) ($($doc.bytes) bytes)") | Out-Null
}
$md.Add("") | Out-Null
$md.Add("## Tools Files (Sample)") | Out-Null
$md.Add("") | Out-Null
foreach ($tool in (($context.tools.files | Select-Object -First 50))) {
  $md.Add("- $($tool.path) ($($tool.bytes) bytes)") | Out-Null
}
$md.Add("") | Out-Null
if ($context.skipped.Count -gt 0) {
  $md.Add("## Skipped") | Out-Null
  $md.Add("") | Out-Null
  foreach ($line in ($context.skipped | Select-Object -First 50)) {
    $md.Add("- $line") | Out-Null
  }
  $md.Add("") | Out-Null
}

if ($DryRun) {
  Write-Output "onboarding-collect: DRY_RUN"
  Write-Output "RepoRoot=$repoRootFull"
  Write-Output "OutputDir=$outputDirFull"
  Write-Output "WouldWrite=$contextJsonPath"
  Write-Output "WouldWrite=$contextMdPath"
  exit 0
}

New-Item -ItemType Directory -Path $outputDirFull -Force | Out-Null
($context | ConvertTo-Json -Depth 12) | Set-Content -LiteralPath $contextJsonPath
($md -join "`n") | Set-Content -LiteralPath $contextMdPath

Write-Output "onboarding-collect: PASS"
Write-Output "wrote=$contextJsonPath"
Write-Output "wrote=$contextMdPath"
exit 0

