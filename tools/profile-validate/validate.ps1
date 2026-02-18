param(
  [string]$ProfilePath = "project.profile.yaml"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$failures = New-Object System.Collections.Generic.List[string]

function Add-Failure {
  param([string]$Reason)
  $failures.Add($Reason)
}

if (-not (Test-Path -LiteralPath $ProfilePath -PathType Leaf)) {
  Add-Failure "Profile file does not exist: $ProfilePath"
  Write-Output "PROFILE_VALIDATE: FAIL"
  Write-Output "Failure Count: $($failures.Count)"
  foreach ($failure in $failures) {
    Write-Output "- $failure"
  }
  exit 1
}

$profileContent = Get-Content -LiteralPath $ProfilePath -Raw
if ($profileContent.Contains("TODO_SET_ME")) {
  Add-Failure "Forbidden placeholder remains: TODO_SET_ME"
}

$requiredChecks = @(
  @{ Path = "version"; Pattern = "(?m)^version:\s*\S+" },
  @{ Path = "project.name"; Pattern = "(?m)^project:\s*$[\s\S]*?^\s{2}name:\s*\S+" },
  @{ Path = "workflow.task_root"; Pattern = "(?m)^workflow:\s*$[\s\S]*?^\s{2}task_root:\s*\S+" },
  @{ Path = "workflow.docs_root"; Pattern = "(?m)^workflow:\s*$[\s\S]*?^\s{2}docs_root:\s*\S+" },
  @{ Path = "workflow.strict_blocking"; Pattern = "(?m)^workflow:\s*$[\s\S]*?^\s{2}strict_blocking:\s*\S+" },
  @{ Path = "commands.build.command"; Pattern = "(?m)^\s{2}build:\s*$[\s\S]*?^\s{4}command:\s*\S+" },
  @{ Path = "commands.test.command"; Pattern = "(?m)^\s{2}test:\s*$[\s\S]*?^\s{4}command:\s*\S+" },
  @{ Path = "commands.format.command"; Pattern = "(?m)^\s{2}format:\s*$[\s\S]*?^\s{4}command:\s*\S+" },
  @{ Path = "commands.lint.command"; Pattern = "(?m)^\s{2}lint:\s*$[\s\S]*?^\s{4}command:\s*\S+" },
  @{ Path = "paths.source_roots"; Pattern = "(?m)^paths:\s*$[\s\S]*?^\s{2}source_roots:\s*$" },
  @{ Path = "paths.artifacts"; Pattern = "(?m)^paths:\s*$[\s\S]*?^\s{2}artifacts:\s*$" },
  @{ Path = "review.required_checks"; Pattern = "(?m)^review:\s*$[\s\S]*?^\s{2}required_checks:\s*$" },
  @{ Path = "defaults.documentation_language"; Pattern = "(?m)^defaults:\s*$[\s\S]*?^\s{2}documentation_language:\s*\S+" },
  @{ Path = "defaults.code_comment_language"; Pattern = "(?m)^defaults:\s*$[\s\S]*?^\s{2}code_comment_language:\s*\S+" }
)

foreach ($check in $requiredChecks) {
  if (-not [Regex]::IsMatch($profileContent, [string]$check.Pattern)) {
    Add-Failure "Missing required key path: $($check.Path)"
  }
}

if ($failures.Count -eq 0) {
  Write-Output "PROFILE_VALIDATE: PASS"
  Write-Output "Validated profile: $ProfilePath"
  exit 0
}

Write-Output "PROFILE_VALIDATE: FAIL"
Write-Output "Failure Count: $($failures.Count)"
foreach ($failure in $failures) {
  Write-Output "- $failure"
}
exit 1
