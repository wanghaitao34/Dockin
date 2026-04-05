# Dockin

[中文](#中文说明) | [English](#english)

Dockin is a lightweight macOS menu bar utility that keeps the Dock effectively pinned to one display in a multi-monitor setup.

Instead of modifying the Dock process, Dockin prevents accidental Dock reveals on non-target displays by intercepting pointer movement near the active Dock edge and gently redirecting the cursor before the Dock trigger zone is reached.

## English

### Overview

Dockin is built for people who use multiple monitors on macOS and want the Dock to stay usable on one chosen display without popping up unexpectedly on the others.

Key capabilities:

- Pin Dock activation to a selected display
- Reduce accidental Dock reveals on other displays
- Support bottom, left, and right Dock positions
- Provide a smoother bottom-edge guard path for the common bottom Dock layout
- Run as a menu bar app with a compact native-style control panel
- Support Chinese, English, Japanese, Korean, Spanish, and French
- Follow system language and system appearance, with manual overrides
- Optionally launch at login

### How It Works

Dockin does not inject into or patch the Dock.

It monitors display layout, the current Dock orientation, and pointer movement:

- On non-target displays, Dockin blocks the pointer from entering the Dock trigger edge
- For bottom Dock layouts, Dockin uses an event tap to clamp pointer movement more smoothly
- For left and right Dock layouts, Dockin uses a lightweight cursor bounce-back strategy

The result is a practical “Dock stays on one display” experience while keeping the selected display unchanged.

### Requirements

- macOS 14.0 or later
- Accessibility permission for global pointer control

If the app cannot control the pointer, macOS permission settings are the first thing to check.

### Installation

#### Option 1: Download a release

1. Open the latest release on GitHub
2. Download the `.dmg`
3. Drag `Dockin.app` into `Applications`
4. Launch Dockin
5. Grant the required macOS permission if prompted

Current release:

- [Dockin v1.0.0](https://github.com/wanghaitao34/Dockin/releases/tag/v1.0.0)

#### Option 2: Build from source

1. Open `Dockin.xcodeproj` in Xcode
2. Select the `Dockin` scheme
3. Build and run the app on macOS

Command-line build example:

```bash
xcodebuild -scheme Dockin -project Dockin.xcodeproj -configuration Debug CODE_SIGNING_ALLOWED=NO build
```

### Privacy and Permissions

Dockin needs system-level pointer access to keep the cursor from crossing the Dock trigger edge on blocked displays.

Dockin does not require network access for its core functionality.

### Known Limitations

- Dockin is designed for direct distribution, not the Mac App Store, because its core behavior depends on pointer control that is not a good fit for App Store sandbox restrictions
- The bottom-edge guard is optimized for smoothness, but behavior can still vary slightly with unusual display arrangements
- Launch at login may require manual approval in System Settings depending on macOS policy and signing state

### Release Assets

The published DMG includes:

- `Dockin.app`
- A shortcut to `/Applications`

Release packages are signed with Developer ID and notarized by Apple.

## 中文说明

### 项目简介

Dockin 是一个面向 macOS 多显示器场景的轻量级菜单栏工具，用来把 Dock 的触发体验“固定”在用户指定的某一块显示器上，避免鼠标在其他显示器底部或侧边误触出 Dock。

Dockin 不会修改 Dock 进程本身，而是在非目标显示器接近 Dock 触发边缘时，提前拦截或轻微回推鼠标，让系统不会误判为用户想在该屏幕呼出 Dock。

### 主要功能

- 支持用户自定义允许显示 Dock 的目标显示器
- 阻止其他显示器误触 Dock
- 支持 Dock 位于底部、左侧、右侧
- 针对底部 Dock 做了更顺滑的边缘拦截
- 以菜单栏应用形式运行，界面简洁
- 支持中文、英文、日语、韩语、西班牙语、法语
- 支持跟随系统语言和系统外观，也支持手动指定
- 支持开机自动启动

### 工作原理

Dockin 会感知当前显示器布局、Dock 方向和鼠标位置：

- 当鼠标位于非目标显示器并接近 Dock 触发边缘时，Dockin 会阻止鼠标进入触发区
- 当 Dock 位于底部时，Dockin 使用事件级坐标夹紧方式，让手感更顺滑
- 当 Dock 位于左侧或右侧时，Dockin 使用轻量回弹策略把鼠标拉回安全区域

这样可以在不改变目标显示器正常使用习惯的前提下，尽量把 Dock 稳定留在指定屏幕。

### 系统要求

- macOS 14.0 或更高版本
- 需要授予辅助功能相关权限，才能进行全局鼠标控制

如果应用无法生效，优先检查 macOS 的权限设置。

### 安装方式

#### 方式一：下载发行版

1. 打开 GitHub Releases 页面
2. 下载最新 `.dmg`
3. 将 `Dockin.app` 拖入 `Applications`
4. 启动 Dockin
5. 按提示授予所需权限

当前版本：

- [Dockin v1.0.0](https://github.com/wanghaitao34/Dockin/releases/tag/v1.0.0)

#### 方式二：从源码构建

1. 使用 Xcode 打开 `Dockin.xcodeproj`
2. 选择 `Dockin` scheme
3. 在 macOS 上构建并运行

命令行构建示例：

```bash
xcodebuild -scheme Dockin -project Dockin.xcodeproj -configuration Debug CODE_SIGNING_ALLOWED=NO build
```

### 权限与隐私

Dockin 的核心能力依赖全局鼠标控制权限，用于阻止鼠标跨入非目标显示器的 Dock 触发边缘。

应用的核心功能不依赖网络访问。

### 当前限制

- Dockin 更适合采用官网或 GitHub Release 的直装分发方式，不适合当前形态下直接上架 Mac App Store
- 在非常特殊的多显示器布局下，底部边缘的手感可能仍会有细微差异
- 开机启动在部分系统配置下可能需要用户到系统设置中手动确认

### 发行包说明

发布的 DMG 包含：

- `Dockin.app`
- `/Applications` 快捷方式

所有发布包均使用 Developer ID 签名，并通过 Apple notarization 公证。
