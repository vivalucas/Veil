# 设计决策记录

> 更新频率：中
> 最近更新：2026-06-04

## DD-001：Veil 对外叙述作为独立产品

**状态**：已采用
**日期**：2026-05-19

### 决策

Veil 的 README、GitHub 页面、安装说明、发布说明和产品文案以 Veil 自身为主。只在 license / attribution 必要位置说明项目基于 Ice，保留 GPL-3.0 和原作者 attribution。

### 原因

- 用户需要看到清晰的 Veil 产品说明，而不是 fork 清理记录。
- 法律 attribution 需要保留，但不应让中间来源成为产品叙述中心。

### 影响

- README 不提中间来源。
- project-log 以 Veil 初始开发项目记录，不写中间项目迁移过程。
- 源码 copyright 和 LICENSE 保留必要 attribution。

## DD-002：第一阶段不重命名所有 `Ice*` 内部类型

**状态**：已采用
**日期**：2026-05-19

### 决策

第一阶段只改对外品牌、bundle、target、scheme、文档和明显入口。`IceBar`、`IceUI`、`IceColor`、`IceGradient`、`IceSettingsImporter` 等内部命名暂时保留。

### 原因

- 内部命名分布广，涉及 settings key、profiles、tests、localization 和 URI docs。
- 直接改名会带来大规模风险，且当前目标是先建立可编译发布基线。

### 后续

如需改为 `VeilBar` 等命名，先在 `10-planning-log.md` 写迁移方案，包括：

- Swift type/file rename。
- UserDefaults key 兼容。
- Profile JSON 兼容。
- URI scheme key 是否保留 alias。
- 测试和本地化更新。

## DD-003：private 阶段保留 project-log，public 前不公开

**状态**：已采用
**日期**：2026-05-19

### 决策

`project-log/` 是内部知识库。当前 GitHub repo 为 private，可以提交并同步；准备 public 前，必须加入 `.gitignore` 并清理 Git 历史中的 `project-log/` 痕迹。

### 推荐表述

当前阶段：

> The repository is private, so `project-log/` is intentionally committed as an internal development knowledge base for maintainers and AI-assisted work.

公开前：

> Before making the repository public, move `project-log/` out of the public history, add it to `.gitignore`, and publish from a cleaned branch or rewritten history.

### 原因

- private 阶段 project-log 能显著提升上下文连续性。
- public 后内部开发记录不应暴露。
- 只删除文件不清历史是不够的。

## DD-004：当前采用未公证分发

**状态**：已采用
**日期**：2026-05-19

### 决策

在没有 Apple Developer 账号时，GitHub Release 发布未公证 DMG。README 明确提示用户使用：

```sh
xattr -cr /Applications/Veil.app
```

### 原因

- 当前无法 notarize。
- GitHub Release 能满足 private 测试和早期分发。

### 风险

- 用户首次启动体验不如 notarized app。
- macOS 安全提示文案可能随系统版本变化。

### 后续

获得 Apple Developer 账号后，再评估 Developer ID signing、notarization、Sparkle appcast 和 release automation。

## DD-005：使用 Sparkle 2 和 GitHub Release appcast 做应用内更新

**状态**：已采用
**日期**：2026-06-04

### 决策

Veil 使用 Sparkle 2.9.2 做应用内自动更新。GitHub Release workflow 在 tag 发布时上传 `Veil.dmg` 和 `appcast.xml`；App 内 feed 指向 `https://github.com/vivalucas/Veil/releases/latest/download/appcast.xml`。

### 原因

- 用户需要从 GitHub 下载 DMG，同时也需要 App 内自动检查、下载、安装并重启完成更新。
- Sparkle 是 macOS App 更新的成熟方案，能校验更新包签名并处理替换 App 的流程。
- 手写 GitHub API 版本检查只能提示下载，不能等价替代自动更新安装。

### 安全约束

- `SUPublicEDKey` 可提交到 `Info.plist`。
- Sparkle 私钥只能存入 GitHub secret `SPARKLE_PRIVATE_KEY`，不得写入源码、文档或 project-log。
- 未公证 DMG 仍会受到 Gatekeeper 影响；Sparkle 更新签名不等同于 Apple notarization。

### 后续

获得 Apple Developer 账号后，应补充 Developer ID signing 和 notarization，再重新验证 Sparkle 更新、首次安装和 Gatekeeper 文案。

## DD-006：本地化只维护简体中文、英语、日语

**状态**：已采用
**日期**：2026-06-04

### 决策

Veil 当前只维护三种语言：

- 简体中文：主 README 和 App localization。
- 英语：`README.en.md` 和 source language。
- 日语：`README.ja.md` 和 App localization。

### 原因

- 历史 `Localizable.xcstrings` 中存在多种旧语言，但当前没有对应维护流程。
- 对外保留未维护语言会造成用户预期和实际质量不一致。
- 三语范围与当前用户需求一致，也便于后续人工审校。

### 影响

- Xcode `knownRegions` 只保留 `en`、`zh-Hans`、`ja` 和 `Base`。
- `Localizable.xcstrings` 删除其他 localization，只保留三语条目。
- README 采用 dashcat 风格的多文件结构：`README.md`、`README.en.md`、`README.ja.md`。

### 后续

如需新增语言，必须同时补 App string catalog、README 文件、语言切换链接和维护说明。
