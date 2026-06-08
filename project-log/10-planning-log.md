# 规划决策记录

> 更新频率：中
> 最近更新：2026-06-04

## ADR-006：重新引入 Sparkle 自动更新与 tag release appcast

**状态**：已采用
**日期**：2026-06-04

### 背景与需求

需要在 GitHub Releases 上提供可下载的 `Veil.dmg`，并在 App 内支持自动检查更新、下载更新、安装并重启。此前 ADR-005 移除 Sparkle，是因为当时没有 appcast、签名和发布验证链路；本轮补齐这些条件。

### 采用的方案

- 版本号统一到 `1.1.0`，build 号统一到 `110`。
- 重新引入 Sparkle 2.9.2 Swift Package。
- `Veil/Resources/Info.plist` 配置 `SUFeedURL`、`SUPublicEDKey`、自动检查、自动下载和检查间隔。
- App 内 About 页和菜单栏菜单的 “Check for Updates” 调用 Sparkle，不再只是打开 GitHub Releases。
- `.github/workflows/release.yml` 在 tag 推送时构建 `Veil.dmg`，用 `SPARKLE_PRIVATE_KEY` secret 生成签名 `appcast.xml`，并把两者上传到 GitHub Release。

### 备选方案及否定原因

- **只发布 DMG，不做 App 内更新**：无法满足自动更新需求。
- **手写 GitHub API 更新检查**：只能提示下载，不能安全地下载、校验、替换 App 并重启。
- **不签名 appcast / 更新包**：不符合 Sparkle 2 的安全模型，更新链路不可接受。

### 验证重点

- `xcodebuild build/test` 通过。
- Release workflow 在 tag `1.1.0` 上生成 `Veil.dmg` 和 `appcast.xml`。
- GitHub secret `SPARKLE_PRIVATE_KEY` 与 App 内 `SUPublicEDKey` 匹配。
- App 内 “Check for Updates” 能读取 latest release 的 appcast。

## ADR-005：移除 Sparkle 与在线更新探测

**状态**：已废弃（2026-06-04，被 ADR-006 取代）
**日期**：2026-05-24

### 背景与需求

代码评审确认 `SUFeedURL` 指向的 appcast 不存在，当前也没有配套 Sparkle appcast、签名和发布验证链路。继续保留自动更新或“检查更新”探测会让用户看到不可兑现的更新能力。

用户确认本项需要彻底移除。

### 采用的方案

- 移除 Sparkle Swift Package、Info.plist Sparkle keys、更新 consent sheet、更新 manager 和本地通知更新链路。
- About 页和菜单栏菜单只提供打开 GitHub Releases 的人工入口，不再请求 GitHub API 判断是否有新版本。
- Release workflow 直接发布 GitHub Release，使 README 和 App 内 Releases 入口能指向真实可见的下载页面。
- project-log 中 Sparkle 相关内容改为历史说明，后续如重新引入自动更新必须重新做设计记录。

### 备选方案及否定原因

- **修复 appcast 并继续使用 Sparkle**：当前没有 Apple Developer / notarization / appcast 维护链路，成本高于本阶段收益。
- **保留手动 “Check for Updates” 网络探测**：仍会给用户“应用内更新检查”的预期，且依赖 GitHub API 和公开 release 状态，不符合本轮“彻底移除”的要求。

### 验证重点

- 全仓库不再存在 Sparkle package、Info.plist appcast、公钥或更新 manager 引用。
- App 内只打开 Releases 页面，不做更新检测或自动下载。
- `xcodebuild test` 通过。
- README、部署、环境和外部服务文档与实际发布方式一致。

## ADR-004：设置功能大幅精简

**状态**：已采用
**日期**：2026-05-24

### 背景与需求

Veil 进入功能收敛阶段。当前目标不是新增能力，而是删除不再需要的设置项，降低前台复杂度，并同步清理这些入口背后的状态、自动化接口、profile 快照和运行时逻辑。

本轮用户明确删除以下前台功能：

- Displays / 通用显示设置中的菜单栏项目间距调整，保留系统默认间距。
- Menu Bar Appearance / 菜单栏外观整页，不再支持重新设置菜单栏 tint、shape、border、shadow、background 等外观。
- Advanced > Other 中的隐藏应用菜单功能。
- Advanced > Other 中的二级菜单功能，包括二级菜单内的 quit 选项。
- Advanced > Other 中的“使用热键时显示在鼠标指针位置”功能。

### 采用的方案

- 从设置导航中移除菜单栏外观页，并移除二级菜单中的“Edit Menu Bar Appearance”入口。
- 从显示设置页移除菜单栏项目间距 UI，后端不再从 per-display 配置或 profile 应用自定义间距。
- 固定菜单栏项目间距相关运行时读取为默认值，避免旧配置继续影响新版本行为。
- 移除隐藏应用菜单、二级菜单、热键指针位置三个用户可见开关，并让对应运行时行为固定为关闭。
- 保留旧 profile / UserDefaults 字段的解码兼容，避免已有本地配置或导入 profile 失败；新保存的配置不再依赖这些字段。
- URI scheme 中移除这些设置的公开读写入口，避免自动化继续操作已删除功能。

### 备选方案及否定原因

- **只隐藏前台 UI，保留后端行为**：旧配置仍可能生效，用户看不到入口却仍被功能影响，不符合“精简”的目标。
- **一次性删除所有相关类型和迁移历史**：diff 过大，容易破坏 profile 导入、旧版本配置兼容和 Xcode project 引用。先清理可达入口和运行时行为，再视构建结果决定是否删除纯死代码文件。
- **保留菜单栏外观默认配置可被 profile 恢复**：profile 切换会重新激活被删除的外观功能，因此本轮不再应用 profile 中的外观配置。

### 改动范围

- 设置导航和设置 pane：`SettingsNavigationIdentifier`、`SettingsView`、`DisplaySettingsPane`、`AdvancedSettingsPane`。
- 设置模型和默认值：`GeneralSettings`、`AdvancedSettings`、`Defaults`、`SettingsResetter`。
- 运行时逻辑：`MenuBarManager`、`HIDEventManager`、`IceBar`、`DisplaySettingsManager`、`ProfileManager`。
- Profile / URI / 文档：`Profile.swift`、`SettingsURIHandler.swift`、`docs/URI_SCHEMES.md`、`project-log/01-function-design.md`、`05-current-status.md`、`06-dev-log.md`。

### 验证重点

- 设置侧边栏不再显示 Appearance。
- Displays 页面不再显示 Menu bar item spacing。
- Advanced > Other 不再显示隐藏应用菜单、二级菜单和热键指针位置选项。
- 右键菜单栏空白区域不再弹出 Veil 二级菜单。
- Profile 切换不再触发菜单栏间距 relaunch wave，也不再恢复菜单栏外观配置。
- 旧 profile / 旧 defaults 解码不崩溃。

### 落地结果

- 相关设置入口、运行时分支、profile 快照和 URI 读写入口已同步收敛。
- 现阶段保留少量兼容字段，仅用于读取旧数据，不再让旧配置重新激活已删除功能。
- 已完成 macOS 构建与测试验证，当前实现可通过回归检查。

## ADR-001：第一阶段只做 Veil 品牌化和发布基础整理

**状态**：已采用
**日期**：2026-05-19

### 背景与需求

项目需要先以 Veil 的身份稳定下来，再进入功能开发。当前重点是品牌、bundle id、文档、GitHub Release 和内部项目记录。

### 采用的方案

- App、target、scheme、bundle id、README、URI scheme 等对外品牌改为 Veil。
- 对外说明不提中间来源。
- 保留 GPL-3.0 和 Ice attribution。
- 第一阶段不做新功能。

### 备选方案及否定原因

- **同时重构所有 `Ice*` 内部命名**：diff 太大，可能破坏设置、profile、测试和 URI key。
- **立即加入新功能**：会增加验证复杂度，不利于先建立稳定基线。

### 改动范围

README、Xcode project、Info.plist、GitHub workflows、docs、project-log。

## ADR-002：当前采用未公证 GitHub Release 分发

**状态**：已采用
**日期**：2026-05-19

### 背景与需求

当前没有 Apple Developer 账号，但需要能从 GitHub Release 分发可下载版本。

### 采用的方案

- GitHub Actions 在 macOS runner 上构建 app。
- 使用 ad-hoc signing。
- 打包为 DMG 并上传 GitHub Release。
- README 明确说明首次启动时使用 `xattr -cr /Applications/Veil.app` 移除 quarantine。

### 备选方案及否定原因

- **Developer ID signing + notarization**：需要 Apple Developer 账号和 secrets，当前不具备。
- **只发布 zip**：用户体验弱于 DMG，且不利于后续稳定发布流程。

### 风险

Gatekeeper 拦截会增加用户安装门槛。后续如果有 Apple Developer 账号，应重新评估 signing/notarization。

## ADR-003：private 阶段提交 project-log，public 前清理

**状态**：已采用
**日期**：2026-05-19

### 背景与需求

`project-log/` 是内部开发知识库，适合 private 阶段同步给开发者和 AI 助手；但 public 后不应暴露内部开发过程和历史记录。

### 采用的方案

- 当前 GitHub repo 为 private，允许提交 `project-log/`。
- 准备切换 public 前，把 `project-log/` 加入 `.gitignore`。
- 切换 public 前清理历史，移除曾经提交过的 `project-log/` 痕迹。
- 清理方式优先考虑新建干净 public 分支，或使用 `git filter-repo` 等历史重写工具。

### 备选方案及否定原因

- **现在就加入 `.gitignore`**：不利于 private 阶段同步内部上下文。
- **public 后再删除文件但不清历史**：历史中仍可见，不满足“内部记录不公开”的目标。

### 注意事项

历史重写前必须备份 private repo，且需要确认 tags、GitHub Releases 和 collaborators 不受影响。
