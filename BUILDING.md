# Building Desktop Critters

This document describes how to build Desktop Critters from source on Windows.
1. Development Environment
The project was developed and tested with the following toolchain:
Component	Configuration
IDE	Visual Studio 2022
Build system	MSBuild
Platform Toolset	v141_xp
Windows SDK	Windows 7.1A SDK
Configuration	Release
Target Platform	Win32 / x86
Runtime Library	Static Runtime (/MT)

The required legacy toolset and SDK must be installed before building.
2. Required Components
Install Visual Studio 2022 or Visual Studio 2022 Build Tools with:
- Desktop development with C++
- MSBuild
- Visual C++ v141_xp toolset
- Windows 7.1A SDK
The exact availability of legacy components depends on the Visual Studio installation and installed toolchain packages.
3. Build Projects
The repository includes two Visual Studio projects:
Project	Project File	Purpose
Desktop Critters	src/Neko98.vcxproj	Main desktop pet application
Desktop Critters Config	src/NekoCFG/NekoCFG.vcxproj	Configuration utility

Both projects are built using:
- Configuration: Release
- Platform: Win32
4. Automatic Build
Open PowerShell in the repository root directory and run:
pwsh -NoProfile -ExecutionPolicy Bypass -File .\build.ps1


The script automatically searches for MSBuild, builds both projects, checks the build results and reports the generated executable files.

No hard-coded Visual Studio installation path is required.
5. Build Output
The generated executable files are placed in the output directories defined by the Visual Studio project configurations.

The build script reports the executable files it finds after compilation.
6. Notes
- The project targets Win32 / x86.
- The original project configuration is preserved.
- Required legacy toolsets and SDKs are not included in this repository.
- The original directory is a local development backup and is not required for the normal build process.
- Prebuilt portable releases are distributed separately through GitHub Releases.
7. Original Project
Desktop Critters is based on the open-source project:

Alex313031/Neko-ng

Please refer to the original project's copyright notices and license files when using or redistributing the source code.