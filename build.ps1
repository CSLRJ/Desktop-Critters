
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

# ============================================================
# 8. Deploy portable version to DC_portable
# ============================================================

$PetSourceExe    = Join-Path $Root 'src\Release\NekoPet.exe'
$ConfigSourceExe = Join-Path $Root 'src\NekoCFG\Release\NekoCFG.exe'
$PortableDir     = Join-Path $Root 'DC_portable'

Write-Host ''
Write-Host '----------------------------------------' -ForegroundColor Cyan
Write-Host 'Deploying portable version' -ForegroundColor Cyan
Write-Host '----------------------------------------' -ForegroundColor Cyan

# 8.1 Both build outputs must exist and be non-empty

foreach ($Artifact in @(
    @{ Path = $PetSourceExe;    Name = 'NekoPet.exe' },
    @{ Path = $ConfigSourceExe; Name = 'NekoCFG.exe' }
)) {

    if (-not (Test-Path $Artifact.Path -PathType Leaf)) {

        Write-Host ''
        Write-Host "ERROR: Build output missing: $($Artifact.Name)" -ForegroundColor Red
        Write-Host $Artifact.Path -ForegroundColor Red

        exit 10
    }

    if ((Get-Item $Artifact.Path).Length -le 0) {

        Write-Host ''
        Write-Host "ERROR: Build output is empty: $($Artifact.Name)" -ForegroundColor Red
        Write-Host $Artifact.Path -ForegroundColor Red

        exit 10
    }
}

# 8.2 Create the portable directory. Existing content is never wiped.

if (-not (Test-Path $PortableDir -PathType Container)) {
    New-Item -ItemType Directory -Path $PortableDir | Out-Null
}

# 8.3 The portable directory must not contain unexpected items.
#     If it does, stop WITHOUT deleting anything and let the user
#     clean it up manually.

$ExpectedNames = @('Desktop_Critters.exe', 'Desktop_Critters_CFG.exe', 'config.ini')

$Unexpected = Get-ChildItem -Path $PortableDir -Force |
    Where-Object { ($_.PSIsContainer) -or ($ExpectedNames -notcontains $_.Name) }

if ($Unexpected) {

    Write-Host ''
    Write-Host 'ERROR: DC_portable contains unexpected items.' -ForegroundColor Red
    Write-Host 'Deployment stopped. Nothing was deleted:' -ForegroundColor Red

    foreach ($Item in $Unexpected) {
        Write-Host "  $($Item.Name)" -ForegroundColor Red
    }

    exit 11
}

# 8.4 Copy and rename the two executables, then verify them

$PortablePetExe    = Join-Path $PortableDir 'Desktop_Critters.exe'
$PortableConfigExe = Join-Path $PortableDir 'Desktop_Critters_CFG.exe'

Copy-Item -Path $PetSourceExe    -Destination $PortablePetExe    -Force
Copy-Item -Path $ConfigSourceExe -Destination $PortableConfigExe -Force

foreach ($Artifact in @(
    @{ Path = $PortablePetExe;    Name = 'Desktop_Critters.exe' },
    @{ Path = $PortableConfigExe; Name = 'Desktop_Critters_CFG.exe' }
)) {

    if (-not (Test-Path $Artifact.Path -PathType Leaf) -or
        (Get-Item $Artifact.Path).Length -le 0) {

        Write-Host ''
        Write-Host "ERROR: Deployment failed for $($Artifact.Name)" -ForegroundColor Red
        Write-Host $Artifact.Path -ForegroundColor Red

        exit 12
    }
}

# 8.5 config.ini protection.
#     An existing file is NEVER overwritten or modified.
#     The repository ships no config.ini template. Both programs
#     are verified to handle a missing or empty config.ini safely
#     (every key falls back to its built-in default and the file is
#     created on first save), so an EMPTY config.ini is created only
#     when none exists.

$PortableIni = Join-Path $PortableDir 'config.ini'

if (Test-Path $PortableIni -PathType Leaf) {

    Write-Host '  Existing config.ini preserved untouched.' -ForegroundColor Green
}
else {

    Write-Host '  config.ini not found - creating an empty one (built-in defaults).' -ForegroundColor Yellow
    New-Item -ItemType File -Path $PortableIni | Out-Null

    if (-not (Test-Path $PortableIni -PathType Leaf)) {

        Write-Host ''
        Write-Host 'ERROR: Could not create config.ini' -ForegroundColor Red
        Write-Host $PortableIni -ForegroundColor Red

        exit 13
    }
}

# 8.6 Remove the original build output directories.
#     Only reached after the full deployment succeeded. The next
#     build recreates everything because /t:Rebuild is used.

try {

    Remove-Item -Path (Join-Path $Root 'src\Release') -Recurse -Force
    Remove-Item -Path (Join-Path $Root 'src\NekoCFG\Release') -Recurse -Force

    Write-Host '  Original build output directories removed.' -ForegroundColor Green
}
catch {

    Write-Host ''
    Write-Host 'ERROR: Could not remove the original build output directories:' -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host 'Deployment itself succeeded; clean them up manually and rebuild.' -ForegroundColor Red

    exit 14
}

Write-Host ''
Write-Host '[OK] Portable deployment complete.' -ForegroundColor Green
Write-Host "     $PortableDir"

Write-Host ''
Write-Host '========================================' -ForegroundColor Green
Write-Host '       ALL BUILDS SUCCEEDED' -ForegroundColor Green
Write-Host '========================================' -ForegroundColor Green

exit 0
