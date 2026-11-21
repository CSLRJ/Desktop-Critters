# 🐾 Desktop Critters

### Little Friends on Your Desktop

**一个轻巧、便携的 Windows 桌面宠物程序。**

**A lightweight and portable desktop pet application for Windows.**

**语言 / Language:** [简体中文](#简体中文) | [English](#english)

---

[下载 Desktop Critters v1.0.0](https://github.com/CSLRJ/Desktop-Critters/releases/tag/v1.0.0)

---

## 简体中文

## ✨ 项目简介

**Desktop Critters** 基于开源项目 Neko-ng 改造和扩展。

你可以在桌面上同时拥有多只宠物。它们能够追逐鼠标、自由移动、被拖动后坠落，也可以随时更换外观。

项目保留了经典桌面宠物的简单乐趣，并在皮肤数量、物理效果、兼容性和资源管理方面进行了扩展。

## 🎨 皮肤与功能

| 功能 | 说明 |
|---|---|
| 动画皮肤 | 共 76 套，每套 32 帧 |
| 多宠物 | 支持多只宠物同时活动 |
| 皮肤切换 | 通过右键菜单即时切换 |
| 物理效果 | 拖动、重力坠落、坐定姿态和落地反弹 |
| 其他操作 | 调整大小、暂停、恢复和退出 |
| 配置管理 | 通过独立配置程序修改设置 |

所有皮肤均嵌入主程序，无需额外下载或安装素材文件。

## 🛠️ 项目来源与制作

Desktop Critters 基于 [Alex313031/Neko-ng](https://github.com/Alex313031/neko-ng) 开发，是在经典 Neko 桌面宠物基础上进行功能扩展和优化的独立衍生项目。

项目整合了 [eliot-akira/neko](https://github.com/eliot-akira/neko) 中 `2023-icon-library` 目录提供的 74 套动画素材，并保留 Neko-ng 原有的 Neko 和 Penguin 动画，最终形成 76 套皮肤。

在原项目基础上，本项目进行了代码修改、功能扩展、资源整合和性能优化，逐步形成现在的 Desktop Critters。

**开发者：** CSLRJ

**开发辅助：** GLM-V5.3-Flash，用于辅助代码分析、修改、调试和功能扩展。

本项目并非 Neko-ng 官方版本，与原作者及素材提供者保持独立。

### 开发环境

- **构建工具：** Visual Studio 2022 MSBuild
- **编译工具集：** v141_xp
- **Windows SDK：** Windows 7.1A SDK
- **目标平台：** Win32 / x86
- **运行库：** 静态运行库 `/MT`
- **开发辅助：** GLM-V5.3-Flash

## ⚙️ 主要改进

- 保留并修复原有 Neko 和 Penguin 皮肤。
- 整合 74 套动画皮肤，最终共计 76 套。
- 新增 DPI 自动适配，支持手动缩放。
- 支持多只宠物同时活动，可分别使用不同皮肤。
- 新增拖动后的重力坠落动画，加入落地反弹效果。
- 优化皮肤按需加载和多宠物共享缓存。
- 将设置保存位置从注册表改为程序同目录下的 `config.ini` 文件。

## 💻 兼容性与运行表现

已在以下系统验证：

- Windows XP SP3（32 位）
- Windows 11

使用 Win32 / x86 编译和静态运行库，无需额外安装 Visual C++ 运行库。

### 内存表现

Windows 11 实测：

| 指标 | 实测表现 |
|---|---:|
| 工作集（Working Set） | 约 1～2 MB |
| 专用工作集（Private Working Set） | 约 1～2 MB |
| 提交大小（Commit Size） | 20 多 MB |

**关于内存指标：**

- **工作集（Working Set）：** 当前驻留在物理 RAM 中的进程内存。
- **专用工作集（Private Working Set）：** 工作集中由该进程独占的部分。
- **提交大小（Commit Size）：** 已提交的虚拟内存，需要由系统的 RAM 或页面文件提供后备保障，不代表这些内存当前全部驻留在物理 RAM 中。

提交大小会在首次切换皮肤时出现一次性增长，后续连续切换没有持续增长。工作集和专用工作集则保持在较低水平。多宠物共享缓存、皮肤连续切换和资源释放均已进行验证。

### 📦 程序文件

| 文件 | 体积 | 用途 |
|---|---:|---|
| `Desktop_Critters.exe` | 约 11.1 MB | 桌面宠物主程序 |
| `NekoCFG.exe` | 约 301 KB | 配置程序 |

主程序体积较大，主要是因为内置了 76 套动画皮肤。

## 🚀 使用方法

1. 将 `Desktop_Critters.exe` 和 `NekoCFG.exe` 放在同一目录。
2. 双击运行 `Desktop_Critters.exe`。
3. 右键点击宠物，可以切换皮肤、调整大小、暂停或恢复活动，以及退出程序。
4. 运行 `NekoCFG.exe` 可以修改其他配置。

## 🔒 便携与隐私

- 无需安装。
- 不写入注册表。
- 程序不需要联网，不会自动启动。
- 所有设置保存在程序同目录下的 `config.ini` 文件中。
- 整个文件夹可以自由移动或复制到其他电脑使用。

## 📜 版权与许可

本项目包含基于 Neko-ng 修改的代码，以及来自其他项目的动画素材。

- **Neko-ng：** 原始代码及历史版权归各自原作者所有。保留原项目的版权声明及相关许可证文件。
- **动画素材：** 来源于 [eliot-akira/neko](https://github.com/eliot-akira/neko) 的 `2023-icon-library` 目录。素材版权及授权条件以各自原始来源为准。
- **Desktop Critters：** 本项目新增及修改的代码由 CSLRJ 开发。其许可范围不包括第三方原始代码和素材。

第三方版权声明和许可证应随源代码一并保留。

本项目免费提供，不代表其中所有第三方代码和素材均可脱离原授权条件单独使用。

## 🙏 致谢

感谢 Neko-ng 原作者 Alex313031、eliot-akira，以及相关动画和图标素材的创作者。

感谢 GLM-V5.3-Flash 在开发过程中的辅助。

---

## 📁 项目文件结构

由于 GitHub 网页版上传文件数量有限，项目中的三个主要目录采用 ZIP 压缩包形式存放在仓库根目录。

### 仓库中的实际结构

```text
Desktop-Critters/
├── BUILD.gn
├── BUILDING.md
├── README.md
├── README-upstream.md
├── THIRD-PARTY-NOTICES.md
├── build.ps1
├── clang_format.sh
├── license.txt
│
├── src.zip
├── assets.zip
└── 2023-icon-library.zip
```

### 解压后的完整项目结构

下载源码后，请将三个 ZIP 压缩包分别解压到项目根目录。解压后应恢复为以下目录结构：

```text
Desktop-Critters/
├── BUILD.gn
├── BUILDING.md
├── README.md
├── README-upstream.md
├── THIRD-PARTY-NOTICES.md
├── build.ps1
├── clang_format.sh
├── license.txt
│
├── src/
│   ├── ...
│
├── assets/
│   ├── ...
│
└── 2023-icon-library/
    ├── ...
```

**注意：** `src/`、`assets/` 和 `2023-icon-library/` 是项目原有的目录结构。请分别解压对应的 ZIP 文件，并保留这些目录名称及其内部层级，不要将文件平铺到项目根目录。

完成解压后，即可按照 `BUILDING.md` 中的说明查看源码和进行编译。

**Created by CSLRJ**

2026年11月21日

---

## English

## ✨ About

**Desktop Critters** is an enhanced and extended version based on the open-source project Neko-ng.

You can have multiple little pets living on your desktop at the same time. They can chase your mouse cursor, move around freely, be dragged and dropped, and fall under gravity. You can also change their appearance whenever you like.

The project preserves the simple charm of classic desktop pets while extending its skin collection, physical interactions, compatibility, and resource management.

## 🎨 Skins & Features

| Feature | Description |
|---|---|
| Animated skins | 76 skins, with 32 frames per skin |
| Multiple pets | Multiple pets can be active simultaneously |
| Skin selection | Switch skins instantly through the right-click menu |
| Physics effects | Dragging, gravity-based falling, sitting animations, and landing bounce |
| Other controls | Resize, pause, resume, and exit |
| Configuration | Modify settings through a separate configuration utility |

All skins are embedded in the main executable. No additional skin files or downloads are required.

## 🛠️ Project Origins & Development

Desktop Critters is based on [Alex313031/Neko-ng](https://github.com/Alex313031/neko-ng) and is an independent derivative project that extends and improves upon the classic Neko desktop pet.

The project incorporates 74 sets of animated assets from the `2023-icon-library` directory in [eliot-akira/neko](https://github.com/eliot-akira/neko), while retaining the original Neko and Penguin animations from Neko-ng. This brings the total collection to 76 skins.

Building upon the original project, I modified the source code, expanded its functionality, integrated additional resources, and optimized its performance to create Desktop Critters.

**Developer:** CSLRJ

**AI-assisted development:** GLM-V5.3-Flash, used to assist with code analysis, modifications, debugging, and feature development.

This project is not an official release of Neko-ng and is independently maintained.

### Development Environment

- **Build system:** Visual Studio 2022 MSBuild
- **Compiler toolset:** v141_xp
- **Windows SDK:** Windows 7.1A SDK
- **Target platform:** Win32 / x86
- **Runtime library:** Static runtime (`/MT`)
- **Development assistance:** GLM-V5.3-Flash

## ⚙️ Key Improvements

- Preserved and repaired the original Neko and Penguin skins.
- Integrated 74 additional animated skins, bringing the total to 76.
- Added automatic DPI scaling and manual size adjustment.
- Added support for multiple pets, each with its own skin.
- Added gravity-based falling animations after dragging, including a landing bounce effect.
- Optimized on-demand skin loading and shared caching between pets.
- Replaced registry-based settings storage with a `config.ini` file in the application directory.

## 💻 Compatibility & Performance

Tested on the following operating systems:

- Windows XP SP3 (32-bit)
- Windows 11

The application is built for Win32 / x86 and uses the static runtime library, so no additional Visual C++ runtime installation is required.

### Memory Usage

Measured on Windows 11:

| Metric | Observed Usage |
|---|---:|
| Working Set | Approximately 1–2 MB |
| Private Working Set | Approximately 1–2 MB |
| Commit Size | A little over 20 MB |

**Understanding the memory metrics:**

- **Working Set:** The amount of process memory currently resident in physical RAM.
- **Private Working Set:** The portion of the working set that is private to the process.
- **Commit Size:** The amount of virtual memory committed by the process, which must be backed by system RAM or the page file. It does not mean that all of this memory is currently resident in physical RAM.

Commit Size increases once during the initial skin switch, but does not continue growing with repeated switches. Working Set and Private Working Set remain relatively low.

Shared caching between multiple pets, repeated skin switching, and resource release have all been tested.

### 📦 Included Applications

| File | Size | Description |
|---|---:|---|
| `Desktop_Critters.exe` | Approx. 11.1 MB | Main desktop pet application |
| `NekoCFG.exe` | Approx. 301 KB | Configuration utility |

The main executable is relatively large because it contains all 76 animated skins.

## 🚀 How to Use

1. Place `Desktop_Critters.exe` and `NekoCFG.exe` in the same directory.
2. Double-click `Desktop_Critters.exe` to launch the desktop pets.
3. Right-click a pet to switch its skin, adjust its size, pause or resume its activity, or exit the application.
4. Run `NekoCFG.exe` to modify additional settings.

## 🔒 Portability & Privacy

- No installation required.
- Does not write to the Windows registry.
- No network connection required.
- Does not automatically launch at Windows startup.
- All settings are stored in a `config.ini` file in the application directory.
- The entire application folder can be moved or copied to another computer.

## 📜 Copyright & Licensing

This project contains modified code derived from Neko-ng, as well as animated assets originating from another project.

- **Neko-ng:** Original source code and historical copyrights belong to their respective authors. The original copyright notices and applicable license files are retained.
- **Animated assets:** The incorporated assets originate from the `2023-icon-library` directory in [eliot-akira/neko](https://github.com/eliot-akira/neko). Copyright and licensing conditions remain subject to their respective original sources.
- **Desktop Critters:** New and modified code contributed to this project was developed by CSLRJ. This does not grant rights to third-party source code or assets.

Third-party copyright notices and license files must be retained and respected when using or redistributing the project.

The project is provided free of charge. This does not mean that all third-party code or assets may be used independently of their original licensing conditions.

## 🙏 Acknowledgements

Special thanks to Alex313031, the original developer of Neko-ng, and eliot-akira, along with the creators of the animated and icon assets used in this project.

Thanks also to GLM-V5.3-Flash for its assistance throughout the development process.

---

## 📁 Project Structure

Due to the file upload limit of the GitHub web interface, the three main project directories are stored as ZIP archives in the repository root.

### Repository Layout

```text
Desktop-Critters/
├── BUILD.gn
├── BUILDING.md
├── README.md
├── README-upstream.md
├── THIRD-PARTY-NOTICES.md
├── build.ps1
├── clang_format.sh
├── license.txt
│
├── src.zip
├── assets.zip
└── 2023-icon-library.zip
```

### Complete Project Structure After Extraction

After downloading the source code, extract all three ZIP archives into the project root directory. The original directory structure should be restored as follows:

```text
Desktop-Critters/
├── BUILD.gn
├── BUILDING.md
├── README.md
├── README-upstream.md
├── THIRD-PARTY-NOTICES.md
├── build.ps1
├── clang_format.sh
├── license.txt
│
├── src/
│   ├── ...
│
├── assets/
│   ├── ...
│
└── 2023-icon-library/
    ├── ...
```

**Note:** `src/`, `assets/`, and `2023-icon-library/` are the original project directories. Extract each corresponding ZIP archive separately and preserve the original directory names and internal folder hierarchy. Do not flatten their contents into the project root.

Once extraction is complete, you can browse the source code and build the project by following the instructions in `BUILDING.md`.

---

**Created by CSLRJ**

November 21, 2026
