
# Desktop Critters Build Script
# Configuration: Release / Win32
# Original toolchain: v141_xp / Windows 7.1A SDK

[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

# ============================================================
# 1. Project configuration
# ============================================================

$Root = $PSScriptRoot

$Configuration = 'Release'
$Platform = 'Win32'

$Projects = @(
    @{
        Name = 'Desktop Critters'
        Path = Join-Path $Root 'src\Neko98.vcxproj'
    },
    @{
        Name = 'Desktop Critters Config'
        Path = Join-Path $Root 'src\NekoCFG\NekoCFG.vcxproj'
    }
)

# ============================================================
# 2. Find MSBuild automatically
# ============================================================

function Find-MSBuild {

    $Candidates = [System.Collections.Generic.List[string]]::new()

    # Method A: Visual Studio Installer / vswhere

    $VswherePaths = @(
        "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe",
        "$env:ProgramFiles\Microsoft Visual Studio\Installer\vswhere.exe"
    )

    foreach ($Vswhere in $VswherePaths) {

        if (Test-Path $Vswhere) {

            $InstallPath = & $Vswhere `
                -latest `
                -products '*' `
                -requires Microsoft.Component.MSBuild `
                -property installationPath 2>$null

            if ($InstallPath) {

                $Candidates.Add(
                    (Join-Path $InstallPath 'MSBuild\Current\Bin\MSBuild.exe')
                )
            }
        }
    }

    # Method B: Common Visual Studio 2022 locations

    $VSBase = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2022"

    foreach ($Edition in @(
        'BuildTools',
        'Community',
        'Professional',
        'Enterprise'
    )) {

        $Candidates.Add(
            (Join-Path $VSBase "$Edition\MSBuild\Current\Bin\MSBuild.exe")
        )
    }

    # Method C: MSBuild available through PATH

    $PathCommand = Get-Command 'MSBuild.exe' -ErrorAction SilentlyContinue

    if ($PathCommand) {
        $Candidates.Add($PathCommand.Source)
    }

    # Return the first valid executable

    foreach ($Candidate in ($Candidates | Select-Object -Unique)) {

        if (Test-Path $Candidate -PathType Leaf) {
            return $Candidate
        }
    }

    return $null
}

# ============================================================
# 3. Check project files
# ============================================================

Write-Host ''
Write-Host '========================================' -ForegroundColor Cyan
Write-Host '       Desktop Critters Build' -ForegroundColor Cyan
Write-Host '========================================' -ForegroundColor Cyan

Write-Host ''
Write-Host "Project directory: $Root"
Write-Host "Configuration:     $Configuration"
Write-Host "Platform:          $Platform"

foreach ($Project in $Projects) {

    if (-not (Test-Path $Project.Path -PathType Leaf)) {

        Write-Host ''
        Write-Host "ERROR: Project file not found:" -ForegroundColor Red
        Write-Host $Project.Path -ForegroundColor Red

        exit 1
    }
}

Write-Host ''
Write-Host '[OK] All project files found.' -ForegroundColor Green

# ============================================================
# 4. Locate MSBuild
# ============================================================

$MSBuild = Find-MSBuild

if (-not $MSBuild) {

    Write-Host ''
    Write-Host 'ERROR: MSBuild.exe was not found.' -ForegroundColor Red

    Write-Host ''
    Write-Host 'Please install Visual Studio 2022 or'
    Write-Host 'Visual Studio 2022 Build Tools.'
    Write-Host ''

    exit 2
}

Write-Host ''
Write-Host "MSBuild: $MSBuild" -ForegroundColor Green

# ============================================================
# 5. Check original toolchain requirements
# ============================================================

Write-Host ''
Write-Host 'Checking project toolchain settings...' -ForegroundColor Cyan

foreach ($Project in $Projects) {

    $Toolset = Select-String `
        -Path $Project.Path `
        -Pattern '<PlatformToolset>(.*?)</PlatformToolset>' `
        -AllMatches

    if ($Toolset) {

        foreach ($Match in $Toolset.Matches) {
            Write-Host "  $($Project.Name): Toolset $($Match.Groups[1].Value)"
        }
    }

    $SDK = Select-String `
        -Path $Project.Path `
        -Pattern '<WindowsTargetPlatformVersion>(.*?)</WindowsTargetPlatformVersion>' `
        -AllMatches

    if ($SDK) {

        foreach ($Match in $SDK.Matches) {
            Write-Host "  $($Project.Name): SDK $($Match.Groups[1].Value)"
        }
    }
}

Write-Host ''
Write-Host 'Note: Required toolsets and SDKs must be installed separately.'
Write-Host 'The actual build result will determine whether they are available.'

# ============================================================
# 6. Build projects
# ============================================================

$BuildResults = @()

foreach ($Project in $Projects) {

    Write-Host ''
    Write-Host '----------------------------------------' -ForegroundColor Cyan
    Write-Host "Building: $($Project.Name)" -ForegroundColor Cyan
    Write-Host '----------------------------------------' -ForegroundColor Cyan

    $BuildArguments = @(
        $Project.Path
        '/t:Rebuild'
        "/p:Configuration=$Configuration"
        "/p:Platform=$Platform"
        '/m'
        '/v:minimal'
        '/nologo'
    )

    & $MSBuild @BuildArguments

    $ExitCode = $LASTEXITCODE

    if ($ExitCode -ne 0) {

        Write-Host ''
        Write-Host "BUILD FAILED: $($Project.Name)" -ForegroundColor Red
        Write-Host "MSBuild exit code: $ExitCode" -ForegroundColor Red

        exit $ExitCode
    }

    Write-Host ''
    Write-Host "[OK] $($Project.Name) built successfully." -ForegroundColor Green

    $BuildResults += $Project.Name
}

# ============================================================
# 7. Report generated executables
# ============================================================

Write-Host ''
Write-Host '========================================' -ForegroundColor Cyan
Write-Host '       Build Output Summary' -ForegroundColor Cyan
Write-Host '========================================' -ForegroundColor Cyan

$OutputDirectories = @(
    (Join-Path $Root 'src\Release'),
    (Join-Path $Root 'src\NekoCFG\Release')
)

foreach ($Directory in $OutputDirectories) {

    if (Test-Path $Directory -PathType Container) {

        $Executables = Get-ChildItem `
            -Path $Directory `
            -Filter '*.exe' `
            -File

        foreach ($Executable in $Executables) {

            Write-Host ''
            Write-Host "  $($Executable.FullName)" -ForegroundColor Green
            Write-Host "  Size: $([math]::Round($Executable.Length / 1MB, 2)) MB"
        }
    }
}

Write-Host ''
Write-Host '========================================' -ForegroundColor Green
Write-Host '       ALL BUILDS SUCCEEDED' -ForegroundColor Green
Write-Host '========================================' -ForegroundColor Green

exit 0
