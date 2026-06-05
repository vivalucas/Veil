# Veil

Veil 是一款精简的 macOS 菜单栏折叠工具，用来隐藏、显示和整理菜单栏项目。

[简体中文](README.md) | [English](README.en.md) | [日本語](README.ja.md)

<br>

[![Download](https://img.shields.io/badge/download-latest-brightgreen?style=flat-square)](https://github.com/vivalucas/Veil/releases/latest)
[![CI](https://img.shields.io/github/actions/workflow/status/vivalucas/Veil/ci.yml?style=flat-square)](https://github.com/vivalucas/Veil/actions/workflows/ci.yml)
![Platform](https://img.shields.io/badge/platform-macOS-blue?style=flat-square)
![Requirements](https://img.shields.io/badge/requirements-macOS%2026%2B-fa4e49?style=flat-square)
[![License](https://img.shields.io/github/license/vivalucas/Veil?style=flat-square)](LICENSE)

## 概览

Veil 可以让拥挤的 macOS 菜单栏重新变得可控。你可以决定哪些菜单栏项目保持可见，哪些项目隐藏起来，并在菜单栏空间不足时自动把低优先级项目折叠进隐藏区域。

Veil 面向想要更安静菜单栏、但又不想失去常用工具入口的用户。当前界面聚焦四个入口：折叠设置、菜单栏布局、权限和关于。

## 功能

- 隐藏和显示菜单栏项目。
- 菜单栏空间不足时自动折叠溢出项目。
- 将很少使用的项目放入始终隐藏区域。
- 通过悬停、点击、滚动或滑动显示隐藏项目。
- 通过拖放重新排列菜单栏项目。
- 通过 Sparkle 在 App 内检查并安装更新。

## 安装

从 [Releases 页面](https://github.com/vivalucas/Veil/releases/latest) 下载最新版本的 Veil，打开 DMG，然后把 `Veil.app` 拖入 `/Applications`。

Veil 当前没有使用 Apple Developer ID 公证分发。首次启动时，macOS 可能提示“应用已损坏”或“无法验证开发者”。如果遇到这种情况，请移除 quarantine 属性：

```sh
xattr -cr /Applications/Veil.app
```

然后从 `/Applications` 再次启动 Veil。

## 权限

Veil 启动时只要求必要的辅助功能权限，用于读取和移动菜单栏项目。屏幕录制权限是可选项，只在布局预览等需要截取菜单栏图标的功能中使用；没有该权限时，基础折叠功能仍可工作。

## 高级接口

Veil 仍保留部分兼容性的 `veil://` URL scheme。它不作为当前精简界面的主功能入口，详细命令参考见 [docs/URI_SCHEMES.md](docs/URI_SCHEMES.md)。

## 故障排除

常见安装、权限和菜单栏整理问题见 [FREQUENT_ISSUES.md](FREQUENT_ISSUES.md)。

## 开发

要求：

- macOS 26 or later
- Xcode 26 or later
- SwiftLint
- SwiftFormat

用 Xcode 打开项目：

```sh
open Veil.xcodeproj
```

在 macOS 上运行测试：

```sh
xcodebuild test \
  -project Veil.xcodeproj \
  -scheme Veil \
  -destination 'platform=macOS'
```

仓库为 private 时，内部开发知识库位于 `project-log/`。准备公开仓库前，应从公开历史中移除 `project-log/`，并把它加入 `.gitignore`。

## 许可

Veil 使用 [GPL-3.0 license](LICENSE)。

Veil 包含基于 Jordan Baird 的 [Ice](https://github.com/jordanbaird/Ice) 派生的工作。GPL-3.0 许可和原始 attribution 已保留。
