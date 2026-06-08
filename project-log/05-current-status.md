# 当前状态

> **最后更新**：2026-06-08
> **最后更新人**：Codex
> **最近开发日志**：`06-dev-log.md` 中的 2026-06-08（1.1.6 发布）
> **当前可信度**：已通过 2026-06-08 macOS `xcodebuild test`、1.1.6 GitHub Release workflow、最新 main CI、历史 Release build、导出产物 ad-hoc 重签名验证、DMG 打包/挂载校验、本地 appcast 校验、三语本地化 build、菜单本地化覆盖审计和发布前全面自查；本机 shell 未安装 `swiftlint`，独立 `swiftlint --strict` 未运行

## 当前版本

**1.1.6 / build 116** — 当前主 App、VeilCtl 和 Sonar 项目版本已重新对齐，GitHub Release `1.1.6` 已发布。

## 当前阶段

发布链路收口阶段。当前 GitHub 仓库为 private，可以提交 `project-log/` 作为内部开发知识库。`1.1.6` Release 已由 tag workflow 产出 `Veil-1.1.6.dmg`、`appcast.xml` 和 `Veil.md`。公开前需要处理 project-log 的可见性和历史记录。

## 已完成

- App / target / scheme / bundle identifier 已切换为 Veil。
- 主 README 已重写为 Veil 项目说明。
- GitHub Release workflow 已调整为无 Apple Developer 账号的未公证 DMG 构建方式。
- 删除当前不需要的 Apple notarization、agent triage、外部翻译平台、赞助、行为准则、致谢文件等治理/署名入口。
- 旧品牌文本已清理。
- `project-log/` 已复制到项目内，并排除模板自身 `.git`。
- `project-log/` 文档已按 Veil 当前状态初始化。
- 已完成一轮设置功能精简：移除菜单栏外观页、菜单栏间距控件、二级菜单入口和热键鼠标指针位置选项，并把相关运行时行为固定为默认关闭。
- 已完成这轮设置精简的收尾修复：profile、reset、defaults 和 URI 入口已同步收敛，macOS `xcodebuild test` 已通过。
- 已重新引入 Sparkle 2.9.2，App 内 About 页和菜单栏入口现调用 Sparkle 检查更新。
- 已把 GitHub Release workflow 改为 tag 触发后构建 `Veil.dmg`、生成 Sparkle `appcast.xml` 并直接发布。
- 已生成 Sparkle ed25519 key pair；公钥写入 `Info.plist`，私钥只允许写入 GitHub secret `SPARKLE_PRIVATE_KEY`。
- 已修正 `ProfileFullTests.testDecodeProfileWithEmptyJSON()` 的本地化断言，macOS 全量 `xcodebuild test` 已通过。
- 已修复 2026-05-29 全面评审中的已确认 P0/P1/P2/P4 问题，包括 profile 持久化、隐藏应用菜单、URI callback scheme、断开显示器清理、权限入口和 README 链接。
- 已按当前产品范围收敛多语言支持：App 和 README 只支持简体中文、英语、日语。
- 已修复 CI 中 SonarQube 在未配置 `SONAR_TOKEN` 时持续失败的问题；latest main CI 已通过。
- 已修复 2026-06-08 评审中确认的版本不一致、CI 触发路径过窄、重隐 0 秒边界（含旧配置运行时 clamp）、HookRunner 输出阻塞和 `project-log/` 被忽略问题。

## 进行中

- 发布前复查收尾：README 和 App 本地化已收敛到简体中文、英语、日语；菜单栏控制菜单、设置导航、断开显示器清理入口、hooks 设置和更新入口已完成覆盖复查。

## 待处理

### 高优先级

- 仓库改为 public 后，复测 App 内 “Check for Updates” 是否能匿名读取 `releases/latest/download/appcast.xml`。private 状态下该 URL 对未认证请求返回 404。
- 测试首次安装流程，确认未公证 app 的 Gatekeeper 提示和 `xattr -cr /Applications/Veil.app` 说明准确。

### 中优先级（P2 安全问题）

- 复核 GitHub Release 发布链路是否与 README 说明一致。
- 检查 `IceBar` 内部命名是否需要在后续阶段逐步改为 `VeilBar`。
- 检查 `FREQUENT_ISSUES.md` 中引用 Ice issue 的内容是否仍要保留、改写或删除。

### 低优先级（P3-P4 性能和体验问题）

- **线程安全问题**：`HIDEventManager` 中 CGEventTap 回调线程读取 `@MainActor` 属性，存在潜在数据竞争。
- **性能优化**：IceBarContentView 使用 5 个 `@ObservedObject` 导致频繁重计算。
- 重新设计 app icon / menu bar icon。
- ~~梳理多语言资源策略。当前不使用外部翻译平台，也不对外强调社区翻译。~~ 已收敛为简体中文、英语、日语三种语言。

### 已修复（2026-05-29 / 2026-06-04）

- ✅ **Profile 系统数据丢失**：`Profile.swift` 中 `iceBarLocationOnHotkey`、`useOptionClickToShowAlwaysHiddenSection`、`useLCSSortingOnNotchedDisplays`、`enableMenuBarItemOverflow` 已修复。
- ✅ **外观配置无法持久化**：`MenuBarAppearanceManager.loadInitialState` 已改为从 UserDefaults 加载配置。
- ✅ **HideApplicationMenus 功能失效**：`MenuBarManager.swift` 中 `guard false` 已改为读取实际设置。
- ✅ **exit(0) 问题**：`AppState.swift` 中已改为 `NSApp.terminate(nil)`。
- ✅ **About 页面按钮标签**：已改为 "Check for Updates"。
- ✅ **FREQUENT_ISSUES.md**：已解决问题的回复已改为提供更新建议和 issue 链接。
- ✅ **URI callback 外泄风险**：callback URL 现只允许自定义本地 scheme，拒绝 `http`、`https`、`veil`、`x-apple-*` 和无效 scheme。
- ✅ **断开显示器配置累积**：Displays 页面新增单个移除和清空断开显示器配置入口。
- ✅ **Tooltips 权限入口**：Tooltips 区域新增直接请求 Screen Recording 权限的按钮。
- ✅ **应用内自动更新**：Sparkle 2.9.2 已重新接入，release workflow 负责生成 appcast。
- ✅ **版本号不一致**：主 App、VeilCtl 和 Sonar 已统一为 `1.1.6` / `116`。
- ✅ **1.1.0 Release 资产早于本地化修复**：改为发布后续 patch 版本，避免重写既有 release tag。
- ✅ **Sparkle 启动崩溃**：Release build 导出后会对 app 做 ad-hoc deep re-sign，去掉 Hardened Runtime library validation，避免 `Sparkle.framework` 在 macOS 26 启动阶段被拒绝加载。

## 未解决的问题 / 临时决策

| 问题 | 影响 | 状态 | 备注 |
|------|------|------|------|
| Sparkle 自动更新链路 | 依赖 GitHub Release appcast 和私钥 secret | 已恢复 | `SPARKLE_PRIVATE_KEY` 只能保存为 GitHub secret，不能提交仓库。 |
| 未公证分发 | 用户首次启动会遇到 Gatekeeper 拦截 | 已接受 | README 已写 `xattr -cr /Applications/Veil.app`。 |
| `project-log/` 当前可提交到 private repo | public 后会暴露内部开发记录 | 临时方案 | private 阶段不再忽略 `project-log/`；public 前重新加入 `.gitignore` 并清理历史。 |
| 内部仍有 `IceBar` 等命名 | 代码不完全品牌化 | 临时保留 | 避免第一阶段大规模破坏兼容。 |

## 下一步

1. 仓库改 public 后，复测 GitHub latest appcast URL 和 App 内更新检查。
2. 测试首次安装流程。

## 任务交接

**当前任务**：1.1.6 发布后收尾。
**已完成**：主 App / VeilCtl / Sonar 版本重新对齐到 `1.1.6` / `116`；CI paths 覆盖 Xcode 工程、workflow/action、plist、VeilCtl、Sonar、README 和 docs；重隐 timed 滑块最小值改为 1 秒，并对旧配置运行时 clamp；HookRunner 输出改用临时文件承接并截断日志读取；private 阶段 `project-log/` 不再被 `.gitignore` 忽略；tag `1.1.6` 已发布，GitHub Release assets 包含 `Veil-1.1.6.dmg`、`appcast.xml` 和 `Veil.md`。
**未完成**：独立 `swiftlint --strict` 未运行（本机 shell 未安装 `swiftlint`）；仓库改 public 后复测 latest appcast URL 和 App 内更新检查；首次安装链路仍待实机验证。
**下一步建议**：在仓库公开后复测 Sparkle latest appcast URL；用真实首次安装路径验证 Gatekeeper 提示和 README 的 `xattr -cr /Applications/Veil.app` 说明。
**风险 / 阻塞**：当前仍是未公证分发；private 仓库下 GitHub release asset 的匿名 latest URL 返回 404，Sparkle 自动更新需要 public 发布通道。
**相关文件**：`.github/workflows/release.yml`、`Veil/Resources/Info.plist`、`Veil/Main/AppDelegate.swift`、`Veil/Settings`、`Veil/Utilities/SettingsURIHandler.swift`、`project-log/07-deployment.md`、`project-log/10-planning-log.md`。
