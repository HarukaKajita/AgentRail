param(
    [string]$SourceRoot = 'agents/skills',
    [string]$TargetRoot = '.agents/skills',
    [string[]]$SkillNames,
    [switch]$DeleteExtraneous,
    [switch]$WhatIf
)

$ErrorActionPreference = 'Stop'

function Resolve-AbsolutePath {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    if ([System.IO.Path]::IsPathRooted($Path)) {
        return (Resolve-Path -Path $Path).Path
    }

    return (Resolve-Path -Path (Join-Path -Path (Get-Location) -ChildPath $Path)).Path
}

function Ensure-Directory {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path,
        [switch]$DryRun
    )

    if (Test-Path -Path $Path -PathType Container) {
        return
    }

    if ($DryRun) {
        Write-Output "[WhatIf] Create directory: $Path"
        return
    }

    New-Item -Path $Path -ItemType Directory -Force | Out-Null
}

if (-not (Test-Path -Path $SourceRoot -PathType Container)) {
    Write-Error "Source root not found: $SourceRoot"
    exit 1
}

$sourceRootResolved = Resolve-AbsolutePath -Path $SourceRoot
$targetRootResolved = if (Test-Path -Path $TargetRoot -PathType Container) {
    Resolve-AbsolutePath -Path $TargetRoot
}
else {
    if ($WhatIf) {
        [System.IO.Path]::GetFullPath((Join-Path -Path (Get-Location) -ChildPath $TargetRoot))
    }
    else {
        Ensure-Directory -Path $TargetRoot
        Resolve-AbsolutePath -Path $TargetRoot
    }
}

$sourceSkillDirs = Get-ChildItem -Path $sourceRootResolved -Directory | Where-Object { $_.Name -notlike '_*' }

if ($SkillNames -and $SkillNames.Count -gt 0) {
    $selected = @()
    $missing = @()
    foreach ($name in $SkillNames) {
        $candidate = $sourceSkillDirs | Where-Object { $_.Name -eq $name } | Select-Object -First 1
        if ($null -eq $candidate) {
            $missing += $name
            continue
        }
        $selected += $candidate
    }

    if ($missing.Count -gt 0) {
        Write-Error ("Skill not found in source: " + ($missing -join ', '))
        exit 1
    }

    $sourceSkillDirs = $selected
}

if ($sourceSkillDirs.Count -eq 0) {
    Write-Output 'No skills selected for sync.'
    exit 0
}

$results = New-Object System.Collections.Generic.List[object]
$errors = New-Object System.Collections.Generic.List[string]

foreach ($skillDir in $sourceSkillDirs) {
    $skillName = $skillDir.Name
    $src = $skillDir.FullName
    $dst = Join-Path -Path $targetRootResolved -ChildPath $skillName

    try {
        Ensure-Directory -Path $targetRootResolved -DryRun:$WhatIf

        if ($DeleteExtraneous -and (Test-Path -Path $dst -PathType Container)) {
            if ($WhatIf) {
                Write-Output "[WhatIf] Remove directory: $dst"
            }
            else {
                Remove-Item -Path $dst -Recurse -Force
            }
        }

        Ensure-Directory -Path $dst -DryRun:$WhatIf

        if ($WhatIf) {
            Write-Output "[WhatIf] Copy $src -> $dst"
        }
        else {
            Copy-Item -Path (Join-Path -Path $src -ChildPath '*') -Destination $dst -Recurse -Force
        }

        $results.Add([pscustomobject]@{
            skill_name = $skillName
            source     = $src
            target     = $dst
            status     = if ($WhatIf) { 'dry-run' } else { 'synced' }
        })
    }
    catch {
        $errors.Add("${skillName}: $($_.Exception.Message)")
    }
}

Write-Output 'Skill Sync Results'
foreach ($row in $results | Sort-Object skill_name) {
    Write-Output ("- {0}: {1}" -f $row.skill_name, $row.status)
}

if ($errors.Count -gt 0) {
    Write-Output ''
    Write-Output 'Errors'
    foreach ($line in $errors) {
        Write-Output ("- {0}" -f $line)
    }
    exit 1
}

Write-Output ''
Write-Output ("Total synced: {0}" -f $results.Count)
if ($WhatIf) {
    Write-Output 'Mode: WhatIf'
}
