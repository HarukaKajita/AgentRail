function ConvertTo-NormalizedRepoPath {
  param(
    [AllowNull()]
    [string]$PathValue
  )

  if ($null -eq $PathValue) {
    return ""
  }

  $trimmed = $PathValue.Trim()
  if ([string]::IsNullOrWhiteSpace($trimmed)) {
    return ""
  }

  $normalized = $trimmed.Replace("\", "/")
  if ([System.IO.Path]::IsPathRooted($trimmed)) {
    return $normalized.TrimEnd("/")
  }

  while ($normalized.StartsWith("./")) {
    $normalized = $normalized.Substring(2)
  }

  while ($normalized.StartsWith("/")) {
    $normalized = $normalized.Substring(1)
  }

  while ($normalized.EndsWith("/")) {
    $normalized = $normalized.Substring(0, $normalized.Length - 1)
  }

  return $normalized
}

function Join-NormalizedRepoPath {
  param(
    [string]$BasePath,
    [string]$ChildPath
  )

  $normalizedBase = ConvertTo-NormalizedRepoPath -PathValue $BasePath
  $normalizedChild = ConvertTo-NormalizedRepoPath -PathValue $ChildPath

  if ([string]::IsNullOrWhiteSpace($normalizedBase)) {
    return $normalizedChild
  }

  if ([string]::IsNullOrWhiteSpace($normalizedChild)) {
    return $normalizedBase
  }

  if ([System.IO.Path]::IsPathRooted($normalizedChild)) {
    return $normalizedChild
  }

  return ConvertTo-NormalizedRepoPath -PathValue ($normalizedBase.TrimEnd("/") + "/" + $normalizedChild.TrimStart("/"))
}

function Get-WorkflowValueFromProfileContent {
  param(
    [string]$ProfileContent,
    [string]$Key
  )

  if ([string]::IsNullOrWhiteSpace($ProfileContent)) {
    return ""
  }

  $workflowMatch = [Regex]::Match($ProfileContent, '(?ms)^workflow:\s*(?:#.*)?\r?\n(?<body>(?:^[ \t]+.*(?:\r?\n|$))*)')
  if (-not $workflowMatch.Success) {
    return ""
  }

  $workflowBody = $workflowMatch.Groups["body"].Value
  $keyPattern = '(?m)^\s{2}' + [Regex]::Escape($Key) + '\s*:\s*(?<value>.*?)\s*$'
  $keyMatch = [Regex]::Match($workflowBody, $keyPattern)
  if (-not $keyMatch.Success) {
    return ""
  }

  $rawValue = $keyMatch.Groups["value"].Value.Trim()
  if ([string]::IsNullOrWhiteSpace($rawValue)) {
    return ""
  }

  $firstChar = $rawValue.Substring(0, 1)
  if (($firstChar -eq '"' -or $firstChar -eq "'") -and $rawValue.EndsWith($firstChar) -and $rawValue.Length -ge 2) {
    $rawValue = $rawValue.Substring(1, $rawValue.Length - 2)
  } else {
    $commentIndex = $rawValue.IndexOf("#")
    if ($commentIndex -ge 0) {
      $rawValue = $rawValue.Substring(0, $commentIndex).Trim()
    }
  }

  return ConvertTo-NormalizedRepoPath -PathValue $rawValue
}

function Resolve-WorkflowPaths {
  param(
    [string]$ProfilePath = "project.profile.yaml",
    [string]$DefaultTaskRoot = "work",
    [string]$DefaultDocsRoot = "docs",
    [string]$DefaultRuntimeRoot = ""
  )

  $resolvedProfilePath = $ProfilePath
  $taskRoot = ConvertTo-NormalizedRepoPath -PathValue $DefaultTaskRoot
  $docsRoot = ConvertTo-NormalizedRepoPath -PathValue $DefaultDocsRoot
  $runtimeRoot = ConvertTo-NormalizedRepoPath -PathValue $DefaultRuntimeRoot
  $profileFound = $false
  $profileLoaded = $false

  if (-not [string]::IsNullOrWhiteSpace($resolvedProfilePath) -and (Test-Path -LiteralPath $resolvedProfilePath -PathType Leaf)) {
    $profileFound = $true
    try {
      $content = Get-Content -LiteralPath $resolvedProfilePath -Raw
      $profileLoaded = $true

      $taskRootFromProfile = Get-WorkflowValueFromProfileContent -ProfileContent $content -Key "task_root"
      if (-not [string]::IsNullOrWhiteSpace($taskRootFromProfile)) {
        $taskRoot = $taskRootFromProfile
      }

      $docsRootFromProfile = Get-WorkflowValueFromProfileContent -ProfileContent $content -Key "docs_root"
      if (-not [string]::IsNullOrWhiteSpace($docsRootFromProfile)) {
        $docsRoot = $docsRootFromProfile
      }

      $runtimeRootFromProfile = Get-WorkflowValueFromProfileContent -ProfileContent $content -Key "runtime_root"
      if (-not [string]::IsNullOrWhiteSpace($runtimeRootFromProfile)) {
        $runtimeRoot = $runtimeRootFromProfile
      }
    } catch {
      $profileLoaded = $false
    }
  }

  if ([string]::IsNullOrWhiteSpace($taskRoot)) {
    $taskRoot = "work"
  }
  if ([string]::IsNullOrWhiteSpace($docsRoot)) {
    $docsRoot = "docs"
  }

  return [PSCustomObject]@{
    profile_path    = $resolvedProfilePath
    profile_found   = $profileFound
    profile_loaded  = $profileLoaded
    task_root       = $taskRoot
    docs_root       = $docsRoot
    runtime_root    = $runtimeRoot
    docs_index_path = Join-NormalizedRepoPath -BasePath $docsRoot -ChildPath "INDEX.md"
    backlog_path    = Join-NormalizedRepoPath -BasePath $docsRoot -ChildPath "operations/high-priority-backlog.md"
  }
}
