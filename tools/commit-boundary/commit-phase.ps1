param(
  [Parameter(Mandatory = $true)]
  [string]$TaskId,
  [Parameter(Mandatory = $true)]
  [ValidateSet("kickoff", "implementation", "finalize")]
  [string]$Phase,
  [string]$Summary = "",
  [string[]]$AdditionalAllowedPaths = @(),
  [switch]$AllowCommonSharedPaths
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$scriptPath = Join-Path -Path $PSScriptRoot -ChildPath "check-staged-files.ps1"
if (-not (Test-Path -LiteralPath $scriptPath -PathType Leaf)) {
  Write-Error "commit-phase: missing check script: $scriptPath"
  exit 1
}

$checkArgs = @{
  TaskId                 = $TaskId
  Phase                  = $Phase
  AdditionalAllowedPaths = $AdditionalAllowedPaths
  AllowCommonSharedPaths = $AllowCommonSharedPaths
}

& pwsh -NoProfile -File $scriptPath @checkArgs
$checkExitCode = $LASTEXITCODE
if ($checkExitCode -ne 0) {
  Write-Error "commit-phase: staged files failed boundary check."
  exit $checkExitCode
}

$normalizedSummary = $Summary.Trim()
if ([string]::IsNullOrWhiteSpace($normalizedSummary)) {
  $normalizedSummary = "update"
}

$commitMessage = "{0}({1}): {2}" -f $Phase, $TaskId, $normalizedSummary
git commit -m $commitMessage
$commitExitCode = $LASTEXITCODE
if ($commitExitCode -ne 0) {
  Write-Error "commit-phase: git commit failed."
  exit $commitExitCode
}

Write-Output "COMMIT_PHASE: PASS"
Write-Output ("task_id={0}" -f $TaskId)
Write-Output ("phase={0}" -f $Phase)
Write-Output ("message={0}" -f $commitMessage)

exit 0
