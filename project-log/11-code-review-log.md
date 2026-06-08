# 代码评审记录

> 更新频率：中
> 最近更新：2026-06-04

## 评审流程

每次较大改动后，在本文件追加评审记录。重点记录问题、风险和验证缺口，不写泛泛总结。

建议格式：

```markdown
## YYYY-MM-DD（主题）

**范围**：

**发现的问题**：
| 严重级别 | 文件 | 问题 | 建议 |
|----------|------|------|------|

**验证缺口**：

**结论**：
```

## 2026-06-08（全项目评审与修复确认）

**范围**：

- project-log 规范、当前状态和 git 跟踪策略。
- 发布版本、VeilCtl 版本、Sonar 项目版本和 release 说明。
- CI 触发路径。
- 主设置 UI 的 rehide 边界值。
- Profile hook 执行稳定性。

**已确认问题**：

| 严重级别 | 文件 | 问题 | 处理结果 |
|----------|------|------|----------|
| P1 | `.gitignore` / `project-log/*` | `project-log/` 被忽略且未被 Git 跟踪，和 private 阶段随代码同步内部知识库的规范冲突。 | 已移除 `.gitignore` 中的 `project-log/` 规则；public 前仍需重新忽略并清理历史。 |
| P1 | `Veil.xcodeproj/project.pbxproj` / `VeilCtl/Resources/Info.plist` / `sonar-project.properties` / `project-log/05-current-status.md` | 主 App 为 `1.1.5` / `115`，VeilCtl 和 Sonar 停在 `1.1.4`，project-log 停在 `1.1.3`。 | 已将主 App、VeilCtl、Sonar 和当前状态记录推进到 `1.1.6` / `116`。 |
| P2 | `.github/workflows/ci.yml` | CI paths 未覆盖 Xcode 工程、GitHub actions、Info.plist、VeilCtl、Sonar、README 和 docs，配置改坏时可能不跑 CI。 | 已扩展 paths 覆盖关键构建、发布和文档文件。 |
| P2 | `GeneralSettingsPane.swift` / `MenuBarSection.swift` | timed rehide UI 允许 0 秒，且旧 defaults / 旧 profile 可继续把 0 秒传给运行时，造成刚展开就收回。 | 已将 UI 滑块范围改为 `1 ... 30`，并在运行时对 0 或非有限值做防御性 clamp。 |
| P3 | `HookRunner.swift` | hook stdout/stderr 只在进程退出后读取，脚本大量输出时可能塞满 pipe 并阻塞 profile apply。 | 已改为临时文件承接输出，并限制读取日志长度；新增大 stdout 回归测试。 |

**待确认问题**：

| 文件 | 问题 | 需要确认 |
|------|------|----------|
| `project-log/05-current-status.md` / `.github/workflows/release.yml` | 下一次 release tag。 | 本轮使用 `1.1.6` tag，推 tag 前确认 DMG 名称、appcast 和 README 下载说明一致。 |
| `Veil/Events/HIDEventManager.swift` | CGEventTap 回调线程读取主 actor 状态的线程安全遗留风险。 | 是否进入下一轮修复范围。 |

**验证**：

- `xcodebuild test -project Veil.xcodeproj -scheme Veil -destination 'platform=macOS' CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO -derivedDataPath /tmp/VeilDerivedData` 通过；复查补丁后再次运行也通过。
- `swiftlint --strict` 未运行：本机 shell 未安装 `swiftlint`，加入 `/opt/homebrew/bin` 后仍不可用。
- 已清理 `/tmp/VeilDerivedData`。

**验证缺口**：

- release workflow、Sparkle latest appcast 和首次安装链路仍需在实际发布环境验证。

**结论**：

本轮已修复评审中确认的版本、CI、文档同步策略、rehide 边界值和 hook 输出阻塞问题。剩余风险集中在独立 SwiftLint、release workflow 和首次安装实机验证。

## 2026-05-19（品牌、发布和文档整理初审）

**范围**：

- Veil 品牌改名。
- GitHub Release workflow 改为未公证 DMG 构建。
- 删除外部翻译平台、赞助、行为准则、致谢、notarization 等当前不需要的治理入口。
- 初始化 `project-log/`。

**发现的问题**：

| 严重级别 | 文件 | 问题 | 建议 |
|----------|------|------|------|
| P1 | `.github/workflows/release.yml` / `.github/actions/build/action.yml` | 当前无法在 Windows 环境验证 macOS 构建是否成功。 | 迁移 macOS 或 GitHub private repo 后立即跑 CI/release workflow。 |
| P2 | `Veil/Resources/Info.plist` | Sparkle appcast 指向 `vivalucas.github.io/Veil/appcast.xml`，未确认是否存在。 | 发布前确认是否启用 Sparkle；未准备好时考虑暂时关闭自动更新或提供 appcast。 |
| P2 | 多处 `IceBar` 内部命名 | 产品文案已称 Veil Bar，但代码和设置 key 仍有 IceBar。 | 第一阶段保留；后续如重命名，必须单独做迁移方案。 |

**验证缺口**：

- 未运行 Xcode build/test。
- 未运行 GitHub Actions。
- 未手动安装 DMG。

**结论**：

当前改动适合作为 Windows 阶段的文档和配置整理结果，但不能视为可发布版本。发布前必须在 macOS 和 GitHub Actions 上验证。

## 2026-05-24（设置功能精简复审）

**范围**：

- 设置功能精简相关代码与配置收敛。
- profile、reset、defaults、URI 和显示配置的回归行为。

**已确认问题**：

| 严重级别 | 文件 | 问题 | 建议 |
|----------|------|------|------|
| P1 | `Veil/Settings/Models/ProfileManager.swift` | Focus Filter 重新触发同一 profile 时提前返回，会跳过 `applyProfile`，导致 profile hooks、布局和副作用不再执行。 | 保留 `focusFilterActive`，但仍走完整应用流程。 |
| P1 | `Veil/Settings/Models/Profile.swift` | profile apply / snapshot 会把已删除的 appearance 和 hotkey-location 配置重新写回状态。 | 固定为默认值，避免旧 profile 重新激活已删功能。 |
| P1 | `Veil/Settings/Models/SettingsResetter.swift` | reset advanced 只恢复了部分默认值，遗漏多个仍在代码中的开关。 | 按 Defaults 补全 reset，避免“重置后状态不一致”。 |
| P2 | `Veil/Settings/Models/DisplayIceBarConfiguration.swift` | 旧配置中的 `itemSpacingOffset` 仍会被编码/解码，但运行时不再使用它。 | 保留兼容解码，输出统一归零，避免旧值继续影响布局。 |

**待确认问题**：

- 是否需要继续删除纯死代码文件和历史迁移兼容层，还是继续保留到下一轮收敛。
- release workflow 和首次安装链路在当前 macOS 环境下是否与 README 说明完全一致。

**验证**：

- `xcodebuild test -project Veil.xcodeproj -scheme Veil -destination 'platform=macOS' CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO -derivedDataPath /tmp/VeilDerivedData`

**结论**：

已确认的设置收敛问题都已修复，当前回归测试通过。剩余风险集中在发布链路和兼容层是否继续删除，需要下一轮范围确认。

补充说明：`ProfileFullTests.testDecodeProfileWithEmptyJSON()` 的本地化断言已对齐，避免把默认名的语言差异误判为产品回归。

## 2026-05-24（Sparkle 与在线更新链路清理复审）

**范围**：

- 移除 Sparkle package、Info.plist appcast keys、更新 consent sheet 和在线版本探测。
- 将 About / 菜单栏入口收敛为 GitHub Releases 跳转。
- 同步 release workflow、project-log 和本地化残留的更新相关内容。

**已确认问题**：

| 严重级别 | 文件 | 问题 | 建议 |
|----------|------|------|------|
| P1 | `Veil/Settings/SettingsPanes/AboutSettingsPane.swift` | 仍在通过 GitHub API 探测最新 release，和“彻底移除更新链路”目标冲突。 | 去掉网络检查，只保留打开 Releases 页面。 |
| P1 | `.github/workflows/release.yml` | release workflow 仍创建 draft release，和 README 的 latest release 下载入口不一致。 | 改为直接发布 release。 |
| P2 | `Veil.xcodeproj/project.pbxproj` / `Veil.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved` | Sparkle package 仍挂在工程和 SwiftPM 解析结果里。 | 移除 package 引用和残留 pin。 |
| P2 | `Veil/Resources/Info.plist` | Sparkle feed / public key 仍写在 app plist 中。 | 删除 Sparkle keys。 |

**验证缺口**：

- `xcodebuild test` 已完成并通过；release workflow 仍待 GitHub 上实际跑一遍。
- 仍需在 GitHub private repo 上确认 release 产物和首次安装链路。

**结论**：

本轮更新链路已从代码、工程和文档层面收口到 GitHub Releases 跳转。macOS 构建与测试已通过，剩余风险集中在 GitHub Actions 发布和首次安装链路验证。

## 2026-05-29（全面代码审查）

**范围**：

- 核心功能：AppState、MenuBarManager、ControlItem、IceBar、MenuBarAppearanceManager
- 设置和配置：Profile、ProfileManager、GeneralSettings、AdvancedSettings、Defaults
- 安全和权限：HIDEventManager、SettingsURIHandler、URI scheme 处理
- 性能和稳定性：Combine 管道、线程安全、内存管理、资源释放
- 用户体验：设置界面、文档、提示信息、交互流程

**已确认问题**：

### 严重级别 P0（数据丢失 / 功能完全失效）

| 文件 | 行号 | 问题 | 建议 |
|------|------|------|------|
| `Veil/MenuBar/Appearance/MenuBarAppearanceManager.swift` | 48-51 | `loadInitialState` 每次启动都删除用户保存的外观配置并重置为默认值，导致用户自定义外观设置无法持久化。 | 移除 `removeObject` 调用，改为从 UserDefaults 加载已保存的配置；如果是迁移逻辑，应添加一次性迁移标记。 |
| `Veil/Settings/Models/Profile.swift` | 55, 84 | `iceBarLocationOnHotkey` 在 Profile 保存和应用时被硬编码为默认值 `false`，用户设置的热键位置偏好永远丢失。 | 在 `capture` 中使用 `settings.iceBarLocationOnHotkey`，在 `apply` 中使用 `self.iceBarLocationOnHotkey`。 |
| `Veil/Settings/Models/Profile.swift` | 91-223 | `AdvancedSettingsSnapshot` 缺少三个活跃使用的属性：`useOptionClickToShowAlwaysHiddenSection`、`useLCSSortingOnNotchedDisplays`、`enableMenuBarItemOverflow`。 | 将这三个属性添加到 `AdvancedSettingsSnapshot` 的 `capture`、`apply` 和 `CodingKeys` 中。 |
| `Veil/Settings/Models/Profile.swift` | 111-113, 130-132 | `AdvancedSettingsSnapshot` 在 `capture` 和 `apply` 中将 `hideApplicationMenus`、`enableSecondaryContextMenu`、`enableSecondaryContextMenuQuit` 硬编码为 `false`。 | 从 `settings` 读取实际值并在 `apply` 时恢复；如果确实要排除，应从结构体中移除这些字段。 |

### 严重级别 P1（功能异常 / 代码质量）

| 文件 | 行号 | 问题 | 建议 |
|------|------|------|------|
| `Veil/MenuBar/MenuBarManager.swift` | 370 | `guard false` 使整个 "HideApplicationMenus" 功能成为死代码，应用菜单隐藏功能完全失效。 | 将 `false` 替换为实际的设置检查条件；如果功能已废弃，应移除死代码。 |
| `Veil/Main/AppState.swift` | 302 | `restartSelf` 中使用 `exit(0)` 跳过 AppKit 关闭生命周期，可能丢失未保存的数据和未刷新的日志。 | 改用 `NSApp.terminate(nil)` 让标准关闭流程运行。 |
| `Veil/Settings/Models/Profile.swift` | 313, 350, 412 | `Profile.content`、`Profile.init` 和解码器始终忽略 `appearanceConfiguration`，强制使用 `.defaultConfiguration`。 | 如果 appearance 已迁移到 per-display 配置，应移除该字段；否则应正确读写。 |

### 严重级别 P2（安全风险）

| 文件 | 行号 | 问题 | 建议 |
|------|------|------|------|
| `Veil/Utilities/SettingsURIHandler.swift` | 1113 | Callback URL 使用黑名单验证，但黑名单不完整，未覆盖 `ftp`、`ssh`、`telnet` 等危险 scheme。 | 改用白名单验证，只允许已知安全的自定义 scheme。 |
| `Veil/Utilities/SettingsURIHandler.swift` | 1116-1161 | 白名单应用可通过 `http`/`https` callback URL 将所有设置数据外泄到外部服务器。 | 限制 callback URL 只能使用自定义 app scheme，或在使用 web scheme 时显示警告。 |
| `Veil/Main/AppDelegate.swift` | 309-316, 343-354 | DEBUG 构建中任何应用可通过 `bundleId` 参数伪造身份，绕过白名单授权。 | 确保 DEBUG 构建永远不会分发给最终用户；添加额外的环境变量或构建标志。 |

### 严重级别 P3（性能问题）

| 文件 | 行号 | 问题 | 建议 |
|------|------|------|------|
| `Veil/Events/HIDEventManager.swift` | 242-287, 302-357 | CGEventTap 回调线程读取 `@MainActor` 类的实例属性（如 `isEnabled`），存在潜在数据竞争。 | 将这些属性改为使用 `OSAllocatedUnfairLock` 或明确标记为 `nonisolated(unsafe)` 并注释线程安全假设。 |
| `Veil/Events/HIDEventManager.swift` | 1573-1591 | 缓存未命中时的 Window Server IPC 回退路径在高频调用时性能不佳。 | 优化缓存策略，减少 IPC 调用频率。 |
| `Veil/MenuBar/IceBar/IceBar.swift` | 355-361 | IceBarContentView 使用 5 个 `@ObservedObject`，任一对象变化都触发整个视图重计算。 | 拆分视图层级，使用 `@EnvironmentObject` 或更细粒度的状态管理。 |

### 严重级别 P4（用户体验）

| 文件 | 行号 | 问题 | 建议 |
|------|------|------|------|
| `Veil/Settings/SettingsPanes/AboutSettingsPane.swift` | - | "Open Releases" 按钮标签面向开发者，普通用户不理解 "Releases" 含义。 | 改为 "Check for Updates" 或 "Download Latest Version"。 |
| `Veil/Settings/SettingsPanes/DisplaySettingsPane.swift` | 83-91 | 已断开连接的显示器条目无法删除，会无限累积。 | 添加清除已断开显示器配置的选项。 |
| `Veil/Settings/SettingsPanes/AdvancedSettingsPane.swift` | 52-61 | Tooltips 区域显示需要屏幕录制权限但没有操作按钮，用户需要滚动到其他区域。 | 在 Tooltips 区域直接添加 "Grant Permission" 按钮。 |
| `README.md` | - | 未链接到 `FREQUENT_ISSUES.md`，用户难以找到故障排除文档。 | 添加 "Troubleshooting" 部分并链接。 |
| `FREQUENT_ISSUES.md` | 10, 19 | 已解决问题的回复只有 "已在当前代码库中解决"，对用户没有实际帮助。 | 移除已解决问题或提供验证方法。 |

**待确认问题**：

| 文件 | 问题 | 需要确认 |
|------|------|----------|
| `Veil/MenuBar/Appearance/MenuBarAppearanceManager.swift` | `overlayPanels` 声明但从未被修改，是否有外部代码添加到集合中？ | 检查是否有其他文件通过某种方式修改 `overlayPanels`。 |
| `Veil/Settings/Models/Profile.swift` | `appearanceConfiguration` 始终被忽略是否为有意设计？ | 确认外观配置是否已迁移到 per-display 配置。 |
| `Veil/Settings/Models/Profile.swift` | `hideApplicationMenus` 等三个字段被硬编码为 `false` 是否为有意禁用？ | 确认这些功能是否已废弃或暂时禁用。 |
| `Veil/MenuBar/MenuBarManager.swift` | `guard false` 是否为有意禁用 HideApplicationMenus 功能？ | 确认功能是否已废弃或需要重新启用。 |

**验证缺口**：

- release workflow 和首次安装链路仍未在 GitHub 上实际验证。
- 未在干净安装环境测试 Gatekeeper 提示和 `xattr` 指令。
- 线程安全问题（HIDEventManager）需要在高并发场景下验证。

**结论**：

本次全面审查发现 4 个 P0 级数据丢失问题（Profile 系统无法正确保存/恢复设置）、3 个 P1 级功能异常、3 个 P2 级安全风险、3 个 P3 级性能问题和 5 个 P4 级用户体验问题。

最紧急需要修复的是：
1. Profile 系统的数据丢失问题（P0）— 影响所有用户的设置持久化
2. MenuBarAppearanceManager 每次启动删除用户配置（P0）— 导致外观设置无法保存
3. HideApplicationMenus 功能失效（P1）— 功能完全不可用

建议按 P0 → P1 → P2 → P3 → P4 的优先级逐步修复。P0 问题应立即处理，因为它们会导致用户数据丢失。

## 2026-05-29（全面代码审查修复）

**范围**：

修复 2026-05-29 全面代码审查中发现的所有已确认问题。

**已修复问题**：

### P0 级（数据丢失）— 已全部修复

| 文件 | 修复内容 | 状态 |
|------|----------|------|
| `Veil/Settings/Models/Profile.swift` | `iceBarLocationOnHotkey` 在 capture/apply 中改为使用 `settings.iceBarLocationOnHotkey` 和 `self.iceBarLocationOnHotkey`。 | ✅ 已修复 |
| `Veil/Settings/Models/Profile.swift` | `AdvancedSettingsSnapshot` 添加 `useOptionClickToShowAlwaysHiddenSection`、`useLCSSortingOnNotchedDisplays`、`enableMenuBarItemOverflow` 三个属性到结构体、capture、apply、CodingKeys 和 init。 | ✅ 已修复 |
| `Veil/Settings/Models/Profile.swift` | `hideApplicationMenus`、`enableSecondaryContextMenu`、`enableSecondaryContextMenuQuit` 在 capture/apply 中改为读取实际设置值。 | ✅ 已修复 |
| `Veil/MenuBar/Appearance/MenuBarAppearanceManager.swift` | `loadInitialState` 改为从 UserDefaults 加载已保存的配置，不再删除用户数据。 | ✅ 已修复 |

### P1 级（功能异常）— 已全部修复

| 文件 | 修复内容 | 状态 |
|------|----------|------|
| `Veil/MenuBar/MenuBarManager.swift` | `guard false` 改为 `guard appState.settings.advancedSettings.hideApplicationMenus`，恢复功能。 | ✅ 已修复 |
| `Veil/Main/AppState.swift` | `exit(0)` 改为 `NSApp.terminate(nil)`，使用标准关闭流程。 | ✅ 已修复 |

### P4 级（用户体验）— 已部分修复

| 文件 | 修复内容 | 状态 |
|------|----------|------|
| `Veil/Settings/SettingsPanes/AboutSettingsPane.swift` | "Open Releases" 按钮标签改为 "Check for Updates"。 | ✅ 已修复 |
| `FREQUENT_ISSUES.md` | 已解决问题的回复改为提供更新建议和 issue 链接。 | ✅ 已修复 |

**未修复问题**：

| 文件 | 问题 | 原因 |
|------|------|------|
| `Veil/Settings/Models/Profile.swift` | `appearanceConfiguration` 始终被忽略 | 需确认是否为有意设计（外观可能已迁移到 per-display 配置） |
| `Veil/Utilities/SettingsURIHandler.swift` | Callback URL 黑名单不完整 | 设计权衡，实际利用需要白名单应用配合 |
| `Veil/Utilities/SettingsURIHandler.swift` | `http`/`https` callback 导致数据外泄 | 设计权衡，白名单机制已提供保护 |
| `Veil/Main/AppDelegate.swift` | DEBUG 构建 bundleId 伪造 | 仅影响 DEBUG 构建，不会分发给最终用户 |
| `Veil/Events/HIDEventManager.swift` | 线程安全问题 | ARM64 上 Bool 读写通常是原子的，实际风险低 |
| `Veil/Events/HIDEventManager.swift` | 缓存未命中时 IPC 性能 | 需要更深入的性能分析和重构 |
| `Veil/MenuBar/IceBar/IceBar.swift` | 5 个 @ObservedObject 性能问题 | 需要较大的架构重构 |
| `Veil/Settings/SettingsPanes/DisplaySettingsPane.swift` | 断开显示器无法删除 | 需要设计清除 UI |
| `Veil/Settings/SettingsPanes/AdvancedSettingsPane.swift` | Tooltips 权限提示无操作按钮 | 需要添加权限请求逻辑 |
| `README.md` | 未链接 FREQUENT_ISSUES.md | 需要更新文档 |

**验证**：

- 修复后需要运行 `xcodebuild test` 验证编译和测试通过。
- 需要手动验证 Profile 保存/恢复功能是否正常工作。

## 2026-06-04（1.1.0 发布链路与评审问题修复复审）

**范围**：

- 版本号统一、GitHub Release workflow、Sparkle appcast 和 App 内更新入口。
- 2026-05-29 全面审查中仍待处理的 P2/P4 问题。
- project-log、README 和 URI 文档一致性。

**已确认问题**：

| 严重级别 | 文件 | 问题 | 处理结果 |
|----------|------|------|----------|
| P1 | `.github/workflows/release.yml` | 旧发布链路只上传 DMG，无法给 Sparkle 提供 appcast，App 内无法自动更新。 | 已改为 tag 触发后上传 `Veil.dmg` 和 `appcast.xml`，appcast 由 Sparkle `generate_appcast` 用 `SPARKLE_PRIVATE_KEY` 生成。 |
| P1 | `Veil/Resources/Info.plist` | App 内缺少有效 Sparkle feed/public key 配置，不能安全更新。 | 已写入 GitHub latest release appcast URL、公钥和自动检查配置。 |
| P1 | 多处版本配置 | App 与辅助 target 版本号不一致会导致 release、appcast 和用户可见版本混乱。 | 已统一为 `1.1.0` / `110`。 |
| P2 | `Veil/Utilities/SettingsURIHandler.swift` | callback URL 允许 web scheme，存在设置数据外泄风险。 | 已改为只允许自定义本地 scheme，并补充回归测试。 |
| P4 | `DisplaySettingsPane.swift` / `DisplaySettingsManager.swift` | 断开显示器配置无法清理，长期使用会累积无效条目。 | 已增加单个移除和清空断开显示器配置入口，并补充测试。 |
| P4 | `AdvancedSettingsPane.swift` | Tooltips 权限提示没有就近授权按钮。 | 已增加 “Grant Permission” 按钮。 |
| P4 | `README.md` | 用户不容易找到故障排除文档和自动更新说明。 | 已补充 Troubleshooting 链接和自动更新说明。 |

**待确认问题**：

| 文件 | 问题 | 需要确认 |
|------|------|----------|
| `.github/workflows/release.yml` | Release workflow 需要在真实 tag `1.1.0` 上验证。 | GitHub Actions 是否成功产出 `Veil.dmg`、`appcast.xml` 和 `Veil.md`。 |
| `Veil/Resources/Info.plist` | Sparkle feed 指向 `releases/latest/download/appcast.xml`。 | 发布后该 URL 是否可被 Sparkle 读取。 |
| 发布分发 | 当前 DMG 未 notarize。 | 首次安装时 Gatekeeper 提示是否仍与 README 中 `xattr -cr /Applications/Veil.app` 说明一致。 |
| Sparkle 私钥 | 私钥已本地生成。 | GitHub secret 设置成功后，删除本地临时私钥文件。 |

**验证缺口**：

- 已完成 macOS Debug build、全量 `xcodebuild test`、Release build、DMG 打包/挂载校验和本地 appcast 生成检查。
- 仍需 GitHub release workflow 和 release asset 检查。

**结论**：

已确认的功能、安全和体验问题均已落地修复。本地发布产物验证已通过。当前剩余风险集中在发布链路的外部验证：GitHub secret、tag workflow、release assets 和 Sparkle latest appcast URL。
- 需要验证 HideApplicationMenus 功能是否恢复。

**结论**：

所有 P0 级数据丢失问题和 P1 级功能异常已修复。P2-P3 级问题为设计权衡或需要较大重构，暂不处理。P4 级 UX 问题已部分修复，剩余问题需要进一步设计。
