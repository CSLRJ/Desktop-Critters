# Building Desktop Critters

This document describes how to build Desktop Critters from source on Windows.

## 1. Development Environment

The project was developed and tested with the following toolchain:

| Component               | Configuration          |
|-------------------------|------------------------|
| IDE                     | Visual Studio 2022     |
| Build system            | MSBuild                |
| Platform Toolset        | v141_xp                |
| Windows SDK             | Windows 7.1A SDK       |
| Configuration           | Release                |
| Target Platform         | Win32 / x86            |
| Runtime Library         | Static Runtime (/MT)   |

The required legacy toolset and SDK must be installed before building.

## 2. Required Components

Install Visual Studio 2022 or Visual Studio 2022 Build Tools with:

- Desktop development with C++
- MSBuild
- Visual C++ v141_xp toolset
- Windows 7.1A SDK

The exact availability of legacy components depends on the Visual Studio installation and installed toolchain packages.

## 3. Build Projects

The repository includes two Visual Studio projects:

| Project                | Project File                    | Output                |
|------------------------|---------------------------------|-----------------------|
| Desktop Critters       | src/Neko98.vcxproj              | src/Release/NekoPet.exe |
| Desktop Critters Config| src/NekoCFG/NekoCFG.vcxproj     | src/NekoCFG/Release/NekoCFG.exe |

Both projects are built using:

- Configuration: Release
- Platform: Win32

The in-project executable names (NekoPet.exe / NekoCFG.exe) are never changed; the release names are produced by the deployment step below.

## 4. Automatic Build

Open PowerShell in the repository root directory and run:

```powershell
pwsh -NoProfile -ExecutionPolicy Bypass -File .\build.ps1
```

The script automatically:

1. searches for MSBuild (vswhere / common install paths / PATH) - no hard-coded installation path is required;
2. rebuilds both projects (`/t:Rebuild`, Release | Win32) and fails fast on any build error;
3. reports the generated executables;
4. deploys the portable version (see below);
5. after a successful deployment, removes the original build output directories `src\Release` and `src\NekoCFG\Release`.

## 5. Automatic Deployment (DC_portable)

After both projects build successfully, the script creates (if needed) the folder `DC_portable` in the repository root and produces exactly three files:

```
DC_portable\
├── Desktop_Critters.exe        (copy of src\Release\NekoPet.exe)
├── Desktop_Critters_CFG.exe    (copy of src\NekoCFG\Release\NekoCFG.exe)
└── config.ini
```

Safety rules enforced by the script:

- Deployment runs only when BOTH projects built successfully; on any failure the script exits non-zero and keeps the original build outputs.
- After copying, both EXEs are verified for existence and size > 0.
- `DC_portable` is never wiped. If it contains unexpected files or subdirectories, the script reports them and stops without deleting anything.
- Only after the full deployment succeeds are the original build output directories removed. The next run rebuilds everything from scratch (`/t:Rebuild`).

## 6. config.ini Protection

- An existing `DC_portable\config.ini` is NEVER overwritten or modified by the build script.
- The repository intentionally ships no config.ini template. When no config.ini exists, the script creates an EMPTY one. This is verified safe: both programs treat a missing or empty config.ini as "all keys unset" and use their built-in defaults; the file is written automatically the first time settings are saved (portable storage next to the EXE, no registry).
- Do not hand-craft config content into the repository; every configuration key has a built-in default in code.

## 7. Repeated Builds

- Simply run `.\build.ps1` again. The script uses `/t:Rebuild`, so it works even after the previous run deleted the Release output directories.
- `DC_portable` is not cleared between builds; existing EXEs are replaced and `config.ini` is preserved.

## 8. Notes

- The project targets Win32 / x86.
- The original project configuration is preserved.
- Required legacy toolsets and SDKs are not included in this repository.
- See `SOURCE_CODE_GUIDE.txt` for a detailed description of the source tree and the internal mechanisms before making code changes.

## 9. Original Project

Desktop Critters is based on the open-source project:

Alex313031/Neko-ng

Please refer to the original project's copyright notices and license files when using or redistributing the source code.
