# 项目概述

> 更新频率：低
> 最近更新：2026-05-24
> 维护说明：本文件描述 Veil 的长期背景、目标和边界。阶段性进度写入 `05-current-status.md`。

## 项目名称

Veil

## 项目背景

Veil 是一个 macOS menu bar manager，用于隐藏、显示、整理和自定义菜单栏项目。项目面向希望减少菜单栏拥挤、管理隐藏项目、为不同工作场景保存菜单栏布局的 macOS 用户。

项目第一阶段目标不是新增功能，而是完成 Veil 自身的品牌、发布、文档和构建基础整理，确保后续可以在最新代码基础上继续开发。

Veil 保留 GPL-3.0 license，并在法律和 license 层面保留 Ice 原项目来源与作者 attribution。对外产品叙述以 Veil 自身为主，不展开中间项目来源。

## 用户 / 使用场景

- 菜单栏项目很多，希望把不常用项目隐藏起来的 macOS 用户。
- 使用 MacBook notch 屏幕，希望隐藏项目能在独立区域展示的用户。
- 需要为工作、娱乐、演示等场景保存不同菜单栏布局的用户。
- 需要通过快捷键、鼠标、URI scheme 或自动化脚本控制菜单栏状态的高级用户。

## 核心功能

1. 隐藏、显示和重新排列菜单栏项目。
2. 支持始终隐藏、临时显示、自动重新隐藏等菜单栏管理方式。
3. 支持独立的 Veil Bar 展示隐藏项目，适配 notch 场景。
4. 支持 profiles 保存和切换不同菜单栏布局。
5. 支持 hotkeys、URI scheme 和 automation hooks。
6. 支持 GitHub Releases 分发未公证 DMG。

## 核心概念

| 概念 | 说明 |
|------|------|
| Menu Bar Item | macOS 菜单栏中的应用项目或系统项目。 |
| Hidden Section | 普通隐藏区，项目在需要时显示。 |
| Always Hidden Section | 始终隐藏区，适合长期不想显示的项目。 |
| Veil Bar | 用于集中展示隐藏项目的独立菜单栏区域。代码里仍有 `IceBar` 内部命名，后续可单独评估是否重命名。 |
| Control Item | Veil 自己显示在菜单栏中的控制入口。 |
| Profile | 一组菜单栏布局和显示设置快照。 |
| Automation Hook | Profile 切换等事件触发时执行的用户脚本。 |
| URI Scheme | `veil://` 和 `veilctl://`，用于自动化控制和回调。 |

## 技术栈

| 层级 | 技术 | 说明 |
|------|------|------|
| App | Swift / SwiftUI / AppKit | macOS menu bar app 主体。 |
| 系统能力 | Accessibility API / ScreenCaptureKit / SkyLight | 用于识别、操作和观察菜单栏项目。 |
| XPC | MenuBarItemService | 独立服务，用于隔离菜单栏项目相关能力。 |
| CLI/辅助工具 | VeilCtl | SwiftUI 小工具，用于 URI 回调和自动化辅助。 |
| 构建 | Xcode project / GitHub Actions | 当前目标是在 GitHub Actions macOS runner 上构建 DMG。 |
| 数据存储 | UserDefaults / 文件系统 | 无数据库。profiles 等数据存储在本地应用目录。 |

## 项目边界

- 不做跨平台版本；第一阶段只面向 macOS。
- 不引入账号系统、云同步或远程后端。
- 不做 Mac App Store 分发。
- 当前没有 Apple Developer 账号，不做 Developer ID notarization。
- 第一阶段不做大规模内部类名重构，尤其是 `IceBar` 相关模型先保持稳定。

## 项目约束

- 保留 GPL-3.0 license。
- 保留 Ice 原项目的法律 attribution。
- 当前开发环境是 macOS，可运行 Xcode build/test；发布 workflow 和首次安装仍需在 GitHub / 干净安装场景验证。
- GitHub 仓库当前为 private；`project-log/` 可以随 private 仓库提交。公开发布前需要决定是否忽略并清理历史。
- **开发环境与日常使用环境共用同一台 MacBook。** 完成代码修改、测试或构建后，必须及时清理所有构建产物（如 DerivedData、build 目录、测试生成的 .app 等）。Spotlight 会索引这些产物，导致搜索软件时出现多个同名条目，干扰日常使用。
