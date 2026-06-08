# 开发日志

## 2026-06-08（1.1.6 发布）

**触发原因**：

用户要求将已确认修复全部提交到 GitHub，推进版本号并发布新的 release。

**修改内容**：
1. `Veil.xcodeproj/project.pbxproj`、`VeilCtl/Resources/Info.plist`、`sonar-project.properties` — 将版本推进到 `1.1.6` / `116`。
2. Git tag `1.1.6` — 发布本轮评审修复版本。
3. `project-log/05-current-status.md`、`project-log/06-dev-log.md` — 记录 1.1.6 发布结果。

**遇到的问题**：
- 本地 `main` 的上一提交已被 tag `1.1.5` 使用，因此本轮发布不能复用 `1.1.5`。

**解决方式**：
- 使用下一个 patch 版本 `1.1.6` / build `116`，保留既有 release tag 历史。

**验证方式**：
- `xcodebuild test -project Veil.xcodeproj -scheme Veil -destination 'platform=macOS' CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO -derivedDataPath /tmp/VeilDerivedData`
- `gh run watch 27122711133 --repo vivalucas/Veil --exit-status`
- `gh release view 1.1.6 --repo vivalucas/Veil`
- `gh run view 27122700082 --repo vivalucas/Veil`

**验证结果**：
- 本地 `xcodebuild test` 通过；测试后已删除 `/tmp/VeilDerivedData`。
- Release workflow `27122711133` 成功，GitHub Release `1.1.6` 已发布，assets 包含 `Veil-1.1.6.dmg`、`appcast.xml`、`Veil.md`。
- main CI `27122700082` 成功。
- `swiftlint --strict` 未运行：本机 shell 未安装 `swiftlint`，加入 `/opt/homebrew/bin` 后仍不可用。

## 2026-06-08（评审问题修复）

**触发原因**：

用户要求先评审项目，并在确认后按评审建议修复已确认问题和优化项。

**修改内容**：
1. `Veil/Settings/SettingsPanes/GeneralSettingsPane.swift`、`Veil/MenuBar/MenuBarSection.swift` — 将 timed rehide 滑块最小值从 0 秒改为 1 秒，并在运行时对旧 defaults / 旧 profile 中的 0 或非有限值做防御性 clamp，避免展开后立即重隐。
2. `Veil/Utilities/HookRunner.swift` — 将 hook stdout/stderr 从 pipe 改为临时文件承接，并限制读取日志长度，避免大量输出阻塞 profile apply。
3. `.github/workflows/ci.yml` — 扩展 CI paths，覆盖 Xcode 工程、GitHub actions/workflows、Info.plist、VeilCtl、Sonar、README 和 docs。
4. `.gitignore` — 移除 `project-log/` 忽略规则，使 private 阶段内部知识库可随仓库同步；public 前仍需重新忽略并清理历史。
5. `Veil.xcodeproj/project.pbxproj`、`VeilCtl/Resources/Info.plist`、`sonar-project.properties` — 将主 App、VeilCtl 和 Sonar 版本推进到 `1.1.6` / `116`，用于发布本轮评审修复。
6. `VeilTests/HookRunnerTests.swift`、`VeilTests/MenuBarSectionNameTests.swift` — 增加大 stdout hook 回归测试和 rehide interval clamp 测试。
7. `project-log/05-current-status.md`、`project-log/06-dev-log.md`、`project-log/07-deployment.md`、`project-log/11-code-review-log.md` — 记录本轮评审、修复和后续验证缺口。

**遇到的问题**：
- `project-log/` 当前未被 Git 跟踪且被 `.gitignore` 忽略，与 private 阶段同步内部知识库的规范冲突。
- 主 App、VeilCtl、Sonar 和 project-log 当前版本记录不一致。

**解决方式**：
- 移除忽略规则，并将版本记录对齐到 `1.1.6` / `116`。
- 对 HookRunner 使用临时文件承接输出，避免 pipe 背压。

**验证方式**：
- `xcodebuild test -project Veil.xcodeproj -scheme Veil -destination 'platform=macOS' CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO -derivedDataPath /tmp/VeilDerivedData`
- `swiftlint --strict`

**验证结果**：
- `xcodebuild test` 通过，包括新增 `HookRunnerTests.testLargeStdoutDoesNotBlockHookProcess()`。
- `xcodebuild test` 复查通过，包括新增 `HookRunnerTests.testLargeStdoutDoesNotBlockHookProcess()` 和 `MenuBarSectionNameTests.testEffectiveRehideInterval*()`。
- `swiftlint --strict` 未运行：本机 shell 返回 `swiftlint: command not found`；加入 `/opt/homebrew/bin` 后仍不可用。
- 已按 `project-log/README.md` 清理 `/tmp/VeilDerivedData`。

## 2026-06-04（1.1.3 Sparkle 启动崩溃修复）

**触发原因**：
用户安装 `1.1.2` DMG 后打开应用没有反应。macOS 崩溃报告显示进程在启动阶段被 dyld 终止，原因是 `Sparkle.framework` 被 Hardened Runtime library validation 拒绝加载。

**修改内容**：
1. `.github/actions/build/action.yml` — Release build 复制到 `build/Export` 后执行 `codesign --force --deep --sign -`，并用 `codesign --verify --deep --strict` 验证导出产物。
2. `Veil.xcodeproj/project.pbxproj`、`VeilCtl/Resources/Info.plist`、`sonar-project.properties` — 将版本推进到 `1.1.3` / `113`。
3. `project-log/05-current-status.md`、`project-log/06-dev-log.md`、`project-log/07-deployment.md` — 记录本轮启动崩溃修复和发布状态。

**遇到的问题**：
- `1.1.2` DMG 中主 app 与 `Sparkle.framework` 都是 ad-hoc 签名，但 Xcode 仍给主 app 加了 Hardened Runtime。
- `codesign --verify --deep --strict` 对原 DMG 可通过，但实际启动时 macOS 26 的 library validation 会拒绝加载内嵌 Sparkle。

**解决方式**：
- 在导出到 DMG 前对整个 `.app` 做一次 ad-hoc deep re-sign，去掉 `runtime` 标志，使主 app 和内嵌 Sparkle 在当前未公证分发策略下可以启动。

**验证方式**：
- 检查 `~/Library/Logs/DiagnosticReports/Veil-*.ips`，确认崩溃原因为 `Library not loaded: @rpath/Sparkle.framework/Versions/B/Sparkle`。
- 对 DMG 内 app 做本地重签名验证，确认重签名副本可启动。
- `xcodebuild build -project Veil.xcodeproj -scheme Veil -destination platform=macOS -configuration Release -derivedDataPath build/DerivedData MACOSX_DEPLOYMENT_TARGET=26.0 CODE_SIGN_STYLE=Manual CODE_SIGN_IDENTITY="-" CODE_SIGNING_ALLOWED=YES`
- 导出后执行 `codesign --force --deep --sign - build/Export/Veil.app` 与 `codesign --verify --deep --strict --verbose=2 build/Export/Veil.app`。

**验证结果**：
- Release build 成功；导出后的 `Veil.app` 和 `Sparkle.framework` 均为 `flags=0x2(adhoc)`，不再带 Hardened Runtime `runtime` 标志；本地没有新增 Veil 崩溃报告。

## 2026-06-04（1.1.2 视觉刷新版本推进）

**触发原因**：
用户要求替换旧 logo、统一白蓝玻璃视觉风格，并推进新版本发布到现有分发渠道。

**修改内容**：
1. `Resources/Icon.*`、`Veil/Resources/AppIcon.icon/*` — 使用用户提供的最终图标资产，并隐藏旧 mark/ribbon/shine 图层。
2. `Veil/Permissions/PermissionsView.swift`、`Veil/Settings/SettingsPanes/*`、`Veil/MenuBar/*`、`Veil/UI/IceUI/*` — 收敛为更克制的白蓝玻璃风格，移除过大的标题和空状态视觉。
3. `Veil.xcodeproj/project.pbxproj`、`VeilCtl/Resources/Info.plist`、`sonar-project.properties` — 将版本推进到 `1.1.2` / `112`。
4. `project-log/05-current-status.md`、`project-log/06-dev-log.md`、`project-log/07-deployment.md` — 记录本轮视觉刷新发布状态。

**遇到的问题**：
- 图标应以用户提供的 `/Users/lucas/Downloads/files/Icon.png` 和 `Icon.svg` 为准，不能继续使用临时生成版本。
- 权限页和若干空状态存在过大的标题/图标，不符合当前“优雅、简洁、苹果风”的视觉目标。
- 仓库仍为 private，Sparkle latest appcast URL 对匿名用户可能返回 404。

**解决方式**：
- 统一 PNG/SVG 图标入口到用户提供资产。
- 扫描并移除 `largeTitle`、`.title*`、40px 以上系统字号和下划线强调等过重 UI。
- 继续使用 tag 触发的 GitHub Release workflow 发布 DMG、appcast 和 release notes。

**验证方式**：
- `git diff --check`
- `xcodebuild -project Veil.xcodeproj -scheme Veil -destination 'platform=macOS' -configuration Debug CODE_SIGNING_ALLOWED=NO build`
- `xcodebuild test -project Veil.xcodeproj -scheme Veil -destination 'platform=macOS' CODE_SIGNING_ALLOWED=NO`
- 待推送 tag `1.1.2` 并观察 GitHub Release workflow。

**验证结果**：
- 本地 build、VeilCtl build 和 macOS 全量测试已通过；GitHub Release workflow 待 tag 推送后确认。

## 2026-06-04（1.1.1 patch 版本推进）

**触发原因**：
`1.1.0` release 资产早于后续三语 README、App 本地化、菜单本地化和 CI 修复，用户要求推进新版本号并触发新版本构建。

**修改内容**：
1. `Veil.xcodeproj/project.pbxproj` — 将主 App、测试和服务 target 的版本推进到 `1.1.1` / `111`。
2. `VeilCtl/Resources/Info.plist` — 将辅助工具版本推进到 `1.1.1` / `111`。
3. `sonar-project.properties` — 将 Sonar 显示版本同步为 `1.1.1`。
4. `project-log/05-current-status.md`、`project-log/06-dev-log.md`、`project-log/07-deployment.md` — 记录 patch 发布策略和当前版本状态。

**遇到的问题**：
- 既有 `1.1.0` tag 已经发布，重写 tag 会让 release 历史和已上传资产变得不稳定。

**解决方式**：
- 使用后续 patch 版本 `1.1.1` 承载本地化和 CI 修复，不重写 `1.1.0`。

**验证方式**：
- `xcodebuild test -project Veil.xcodeproj -scheme Veil -destination 'platform=macOS' CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO -derivedDataPath /tmp/VeilRelease111DerivedData`
- 待推送 tag `1.1.1` 并观察 GitHub Release workflow。

**验证结果**：
- macOS 全量测试通过；测试后已删除 `/tmp/VeilRelease111DerivedData`。
- GitHub Release workflow 待 tag 推送后验证。

## 2026-06-04（发布前全面自查）

**触发原因**：
用户要求再次全面自查近期更改，覆盖前端入口、UI 风格、功能风险、新 bug 和文档规范。

**修改内容**：
1. `Veil/Resources/Localizable.xcstrings` — 补齐 hooks/脚本设置、断开显示器清理入口、自动化辅助文案等简体中文和日语翻译，并保留复数条目的 `variations.plural` 结构。
2. `project-log/05-current-status.md`、`project-log/06-dev-log.md` — 记录本轮自查发现、验证结果和 release tag 风险。

**遇到的问题**：
- 精确本地化扫描发现 `Disconnected display settings`、`Clear All`、`Remove`、断开显示器清理说明等新增 UI 文案未进入 string catalog。
- hooks/脚本相关条目在 catalog 中仍处于 `new` 状态，实际会在简中/日文界面显示英文。
- 初版完整性脚本把 `variations.plural` 误判为缺失；修复时必须避免把 Xcode 的复数结构扁平化。
- GitHub Release `1.1.0` 的 tag 指向 `db3f492`，早于后续 README 三语、本地化、菜单和 CI 修复，因此当前 DMG 不包含最新代码。

**解决方式**：
- 使用结构化 JSON 更新 `.xcstrings`，补齐缺失翻译。
- 重新实现本地化检查逻辑，同时识别顶层 `stringUnit` 和 `variations`。
- 对设置、菜单、权限等可见 UI 入口做精确文案扫描，确认非插值文案都有 catalog key。
- 将 release tag 与 HEAD 不一致记录为高优先级待确认发布项。

**验证方式**：
- JSON 解析 `Veil/Resources/Localizable.xcstrings`，确认语言仅为 `en`、`zh-Hans`、`ja`，且所有 key 的简中/日文翻译完整。
- `rg` / Python 静态扫描设置页、控制菜单和权限页可见文案。
- `git diff --check`
- `xcodebuild test -project Veil.xcodeproj -scheme Veil -destination 'platform=macOS' CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO -derivedDataPath /tmp/VeilFullSelfAuditDerivedData`
- `gh release view 1.1.0 --json tagName,targetCommitish,publishedAt,name,url,assets,isDraft,isPrerelease`

**验证结果**：
- 通过。macOS 全量测试成功；测试后已删除 `/tmp/VeilFullSelfAuditDerivedData`。
- 待确认：`1.1.0` release 资产早于当前 HEAD，需要决定重发 `1.1.0` 还是发布 patch 版本。

## 2026-06-04（菜单本地化覆盖审计）

**触发原因**：
用户要求检查各项菜单和相关入口是否都已完成本地化。

**修改内容**：
1. `Veil/MenuBar/ControlItem/ControlItem.swift` — 将控制菜单图标的 accessibility description 改为读取本地化字符串，并移除动态拼接的 section 菜单标题 fallback，避免运行时生成不可翻译 key。
2. `Veil/Resources/Localizable.xcstrings` — 补齐 `Check for Updates`、`Check for Updates…`、`Settings`、`Search`、`Restart` 的简体中文和日语翻译。
3. `project-log/05-current-status.md`、`project-log/06-dev-log.md` — 记录菜单本地化审计和验证结果。

**遇到的问题**：
- 静态扫描会把 Swift 字符串插值误报为缺失 key，需要逐项对照 `.xcstrings` 中的 `%@` / `%lld` 形式自检。
- 控制菜单里 `Check for Updates…` 和 About 页 `Check for Updates` 确认为缺失 key。
- 控制菜单曾有一个动态拼接 fallback：`Show/Hide + section name + Section`，未来新增 section 时会绕过本地化资源。

**解决方式**：
- 对真实 `NSMenuItem` 创建点和设置页更新入口逐项核对，保留用户数据/系统 App 名称等不应翻译的文本。
- 补齐缺失 key，并把菜单图标可访问文本统一改为 `String(localized:)`。
- 对无法覆盖的动态 fallback 改为跳过未知 section，当前 `.hidden` 和 `.alwaysHidden` 已由显式本地化分支覆盖。

**验证方式**：
- JSON 解析 `Veil/Resources/Localizable.xcstrings`，确认新增目标 key 均有 `zh-Hans` 和 `ja` 翻译。
- `rg` 扫描 `NSMenuItem`、`accessibilityDescription`、`Check for Updates` 等菜单/入口文本。
- `git diff --check`
- `xcodebuild test -project Veil.xcodeproj -scheme Veil -destination 'platform=macOS' CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO -derivedDataPath /tmp/VeilMenuLocalizationDerivedData`

**验证结果**：
- 通过。macOS 全量测试成功；测试后已删除 `/tmp/VeilMenuLocalizationDerivedData`。

## 2026-06-04（SonarQube CI 配置收口）

**触发原因**：
菜单本地化提交后的 CI 中 static_analysis 和 build/test 均通过，但 SonarQube job 因 `SONAR_TOKEN` 未配置持续失败。

**修改内容**：
1. `.github/workflows/ci.yml` — 在 SonarQube job 中新增 token preflight，未配置 `SONAR_TOKEN` 时跳过下载覆盖率、转换覆盖率和 Sonar 扫描步骤，让缺少外部服务密钥的仓库仍保持 CI 绿色。
2. `sonar-project.properties` — 将 `sonar.projectVersion` 从 `0.1.0` 更新为当前 `1.1.0`。
3. `project-log/06-dev-log.md` — 记录 CI 配置修复。

**遇到的问题**：
- GitHub Actions 日志显示 `SONAR_TOKEN` 为空，Sonar Cloud 返回 `Project not found`，属于外部服务密钥/项目绑定问题，不是本地化代码回归。

**解决方式**：
- 保留 SonarQube job，但只有 token 存在时才执行扫描；没有 token 时输出跳过原因并让 job 正常完成。

**验证方式**：
- `gh run view 26934769429 --job 79462048417 --log`
- `git diff --check`
- GitHub Actions CI run `26935037889`

**验证结果**：
- 通过。CI run `26935037889` 中 static_analysis、build/test 均通过；未配置 `SONAR_TOKEN` 时 SonarQube job 按预期跳过扫描并成功完成。

> 更新频率：高
> 最近更新：2026-06-04

## 2026-06-04（1.1.0 发布与 Sparkle 自动更新）

**触发原因**：
用户需要 GitHub Release 上可下载的 DMG，并要求 App 内自动检查更新、下载更新、安装并重启；同时要求修复此前全面评审中已确认的问题和体验优化项。

**修改内容**：
1. `Veil.xcodeproj/project.pbxproj`、`VeilCtl/Resources/Info.plist` — 将版本统一为 `1.1.0` / `110`。
2. `Veil.xcodeproj/project.pbxproj`、`Package.resolved`、`Veil/Resources/Info.plist`、`Veil/Main/AppDelegate.swift`、`AboutSettingsPane.swift`、`ControlItem.swift` — 重新引入 Sparkle 2.9.2，配置 appcast、公钥、自动检查和 App 内 “Check for Updates”。
3. `.github/workflows/release.yml` — tag 推送时构建 `Veil.dmg`，使用 `SPARKLE_PRIVATE_KEY` 生成 `appcast.xml`，并把两者上传到 GitHub Release。
4. `Veil/MenuBar/MenuBarManager.swift`、`Veil/Settings/Models/AdvancedSettings.swift` — 修复隐藏应用菜单设置读取和加载遗漏。
5. `Veil/Utilities/SettingsURIHandler.swift`、`VeilTests/SettingsURIHandlerTests.swift` — 将 callback URL 校验改为只允许自定义本地 scheme，避免设置数据通过 web callback 外泄。
6. `Veil/Settings/Models/DisplaySettingsManager.swift`、`DisplaySettingsPane.swift`、`VeilTests/DisplaySettingsManagerSpacingGateTests.swift` — 增加断开显示器配置清理能力和 UI。
7. `Veil/Settings/SettingsPanes/AdvancedSettingsPane.swift` — 在 Tooltips 权限提示旁增加直接授权按钮。
8. `README.md`、`docs/URI_SCHEMES.md`、`project-log/07-deployment.md`、`08-env-config.md`、`09-external-api-reference.md`、`10-planning-log.md` — 同步发布、自动更新、安全约束和环境配置说明。

**遇到的问题**：
- Sparkle SwiftPM artifact 初次下载超时，重试后依赖缓存完成并构建通过。
- 当前仍无 Apple Developer ID，因此 1.1.0 继续采用未公证 DMG 分发。

**解决方式**：
- 保留 ad-hoc signing 和 README 的 Gatekeeper 处理说明。
- 使用 Sparkle ed25519 签名保护更新包；私钥只写入 GitHub secret `SPARKLE_PRIVATE_KEY`，不提交仓库。
- 将 release workflow 生成的 `Veil.md` 一并上传，避免 appcast 中的 `sparkle:releaseNotesLink` 指向不存在的 asset。
- 给 workflow 下载 Sparkle SPM zip 的 `curl` 加上重试参数，降低 GitHub 网络 partial transfer 造成的偶发失败。

**验证方式**：
- `xcodebuild -project Veil.xcodeproj -scheme Veil -destination 'platform=macOS' CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO -derivedDataPath /tmp/VeilDerivedData build`
- `xcodebuild test -project Veil.xcodeproj -scheme Veil -destination 'platform=macOS' CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO -derivedDataPath /tmp/VeilDerivedData`
- `xcodebuild build -project Veil.xcodeproj -scheme Veil -destination platform=macOS -configuration Release -derivedDataPath build/DerivedData MACOSX_DEPLOYMENT_TARGET=26.0 CODE_SIGN_STYLE=Manual CODE_SIGN_IDENTITY="-" CODE_SIGNING_ALLOWED=YES`
- `create-dmg ... build/Veil.dmg ...`
- `hdiutil verify build/Veil.dmg`
- Sparkle `generate_appcast` 生成 `build/appcast.xml`，并检查 DMG URL、edSignature、`1.1.0` / `110`、release notes link。
- `hdiutil attach -nobrowse -readonly build/Veil.dmg` 后检查 `Veil.app`、`Applications` symlink 和 app 版本。

**验证结果**：
- Debug build、全量测试、Release build、DMG 打包/校验、DMG 挂载检查、本地 appcast 校验和 GitHub Release workflow 均已通过。
- GitHub Release `1.1.0` 已发布，assets 包含 `Veil.dmg`、`appcast.xml` 和 `Veil.md`。
- private 仓库状态下，匿名访问 `https://github.com/vivalucas/Veil/releases/latest/download/appcast.xml` 返回 404；仓库改 public 后需要复测。

## 2026-06-04（三语本地化与 README）

**触发原因**：
用户要求项目增加本地化能力，并参考 `/Users/lucas/projects/dashcat` 的多语言 README 组织方式；本轮只支持简体中文、英语、日语。

**修改内容**：
1. `README.md` — 改为简体中文主 README，并增加简体中文 / English / 日本語语言切换链接。
2. `README.en.md`、`README.ja.md` — 新增英语和日语 README。
3. `Veil/Resources/Localizable.xcstrings` — 删除除 `en`、`zh-Hans`、`ja` 外的旧 localization，保留 358 条简中和日文翻译。
4. `Veil.xcodeproj/project.pbxproj` — 将 `knownRegions` 收敛为 `en`、`zh-Hans`、`ja` 和 `Base`。

**遇到的问题**：
- Veil 原本带有大量历史语言翻译，但当前产品范围只需要三种语言。
- 推送后 GitHub CI 的 SwiftLint 发现两处上一轮 Sparkle 代码格式问题：`AppDelegate.shared` 修饰符顺序和 `AboutSettingsPane` 结尾前空行。

**解决方式**：
- 保留 source language `en`，保留完整 `zh-Hans` 和 `ja` localization，删除其他语言条目，避免对外承诺未维护语言。
- 按 SwiftLint 要求调整修饰符顺序并删除多余空行。

**验证方式**：
- `xcodebuild build -project Veil.xcodeproj -scheme Veil -destination 'platform=macOS' CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO -derivedDataPath /tmp/VeilLocalizationDerivedData`
- `xcodebuild test -project Veil.xcodeproj -scheme Veil -destination 'platform=macOS' CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO -derivedDataPath /tmp/VeilLocalizationDerivedData`
- 检查编译产物 `Veil.app/Contents/Resources`，确认只生成 `en.lproj`、`zh-Hans.lproj`、`ja.lproj`。

**验证结果**：
- 通过。裁剪后的 string catalog 和 Xcode known regions 可正常编译，全量测试通过，编译产物只包含目标三种语言。

## 2026-05-19（品牌、发布与 project-log 初始化）

**触发原因**：
需要把项目整理为 Veil 自己的初始开发状态，并建立内部开发知识库，方便后续人和 AI 接力。

**修改内容**：
1. `README.md` — 重写为 Veil 面向用户的项目说明，保留 GPL-3.0 和 Ice 来源 attribution，不提中间来源。
2. `.github/workflows/release.yml`、`.github/actions/*` — 调整为无需 Apple Developer 账号的 GitHub Release DMG 构建。
3. `.github/` — 删除外部翻译平台、赞助、行为准则、agent triage、notarization 等当前不需要的治理文件。
4. `Veil/Settings/SettingsPanes/AboutSettingsPane.swift`、`Veil/MenuBar/ControlItem/ControlItem.swift` — 移除支持、贡献、致谢等对外入口。
5. `project-log/` — 复制内部文档模板，删除模板自带 `.git`，并按 Veil 当前状态填充 00-12 文档。

**遇到的问题**：
- 当前环境是 Windows，无法执行 Xcode build/test。
- 模板目录复制时带入了自身 `.git`，需要删除。

**解决方式**：
- 将 macOS 编译验证记录为阻塞事项。
- 删除 `project-log/.git`，避免把模板仓库历史带进 Veil。

**验证方式**：
- 使用 `rg` 扫描旧品牌、外部翻译平台、赞助、notarization 等残留关键词。
- 使用 PowerShell XML 解析检查 plist。
- 运行 `git diff --check`。

**验证结果**：
- 文档和 plist 检查通过。
- `git diff --check` 仅提示 Windows LF/CRLF 行尾转换。
- Xcode 编译未运行，原因：当前环境不是 macOS。

## 2026-05-24（设置功能大幅精简）

**触发原因**：
用户确认要删除菜单栏外观、菜单栏间距、二级菜单和相关自动化入口，需要同步收紧前台和后端逻辑。

**修改内容**：
1. `README.md`、`docs/URI_SCHEMES.md`、`project-log/01-function-design.md`、`project-log/05-current-status.md`、`project-log/10-planning-log.md` — 更新文档，记录 ADR-004，并移除已删除功能的公开说明和 URI 示例。
2. `Veil/Settings/SettingsPanes/DisplaySettingsPane.swift`、`Veil/Settings/SettingsPanes/AdvancedSettingsPane.swift`、`Veil/Settings/SettingsView.swift`、`Veil/Main/Navigation/NavigationIdentifiers/SettingsNavigationIdentifier.swift` — 删除菜单栏外观页、菜单栏间距控件，以及高级设置里已取消的二级菜单、隐藏应用菜单和热键指针位置入口。
3. `Veil/MenuBar/MenuBarManager.swift`、`Veil/Events/HIDEventManager.swift`、`Veil/MenuBar/IceBar/IceBar.swift` — 关闭二级菜单、自动隐藏应用菜单和热键指针位置等相关运行时分支。
4. `Veil/MenuBar/Appearance/MenuBarAppearanceManager.swift`、`Veil/Settings/Models/ProfileManager.swift`、`Veil/Settings/Models/Profile.swift`、`Veil/Settings/Models/AdvancedSettings.swift`、`Veil/Settings/Models/GeneralSettings.swift`、`Veil/Settings/Models/SettingsResetter.swift`、`Veil/Utilities/Defaults.swift`、`Veil/Utilities/SettingsURIHandler.swift`、`Veil/Settings/Models/DisplayIceBarConfiguration.swift` — 将旧配置入口固定为默认值，避免历史 UserDefaults、profile 和 URI 继续恢复已删除功能。

**遇到的问题**：
- `DisplaySettingsPane.swift` 在删掉间距控制后，残留了 `maxSliderLabelWidth` 的引用。
- `xcodebuild` 初次构建被签名证书挡住，无法直接看到编译错误。

**解决方式**：
- 删除残留的宽度约束引用，改回普通 label。
- 使用 `CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO` 重新构建，拿到真实编译结果。

**验证方式**：
- `xcodebuild -project Veil.xcodeproj -scheme Veil -destination 'platform=macOS' -derivedDataPath /tmp/VeilDerivedData build`
- `xcodebuild -project Veil.xcodeproj -scheme Veil -destination 'platform=macOS' CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO -derivedDataPath /tmp/VeilDerivedData build`

**验证结果**：
- 通过。第二次构建成功。

## 2026-05-24（设置功能精简收尾与日志补全）

**触发原因**：
前一轮设置功能精简的代码修复已经完成，需要把项目规划、当前状态和评审记录补齐到一致状态，并确认回归测试结果。

**修改内容**：
1. `project-log/10-planning-log.md` — 将 ADR-004 状态改为已采用，补充落地结果。
2. `project-log/05-current-status.md` — 更新当前可信度、已完成事项、待处理项和任务交接，反映本轮收尾状态。
3. `project-log/11-code-review-log.md` — 补充本轮评审发现、验证缺口和结论，保留问题与修复依据。

**遇到的问题**：
- 需要保证 project-log 的状态、规划和评审记录互相一致，避免后续接手时误判当前进度。

**解决方式**：
- 逐项对齐 project-log 的状态描述，明确哪些问题已确认修复，哪些只是暂时保留的兼容层。

**验证方式**：
- 复查 `project-log/README.md` 的更新规范。
- 复查 `project-log/05-current-status.md`、`10-planning-log.md`、`11-code-review-log.md` 的一致性。
- 参考前一轮 `xcodebuild test` 结果。

**验证结果**：
- 通过。project-log 已补齐，当前状态与已完成修复一致。

## 2026-05-24（Profile 空 JSON 默认名测试修正）

**触发原因**：
全量 `xcodebuild test` 暴露出 `ProfileFullTests.testDecodeProfileWithEmptyJSON()` 对默认名称的断言过于死板，在当前系统语言下会把 `Untitled` 误判为失败。

**修改内容**：
1. `VeilTests/ProfileTests.swift` — 将空 JSON 的默认名断言改为 `String(localized: "Untitled")`，与 `Profile` 的实际回退逻辑保持一致。

**遇到的问题**：
- 默认名是本地化字符串，测试硬编码英文会导致跨语言环境误报。

**解决方式**：
- 让测试直接使用同一套本地化回退值，避免环境语言改变时出现假失败。

**验证方式**：
- `xcodebuild test -project Veil.xcodeproj -scheme Veil -destination 'platform=macOS' CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO -derivedDataPath /tmp/VeilDerivedData -only-testing:VeilTests/ProfileFullTests/testDecodeProfileWithEmptyJSON`
- `xcodebuild test -project Veil.xcodeproj -scheme Veil -destination 'platform=macOS' CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO -derivedDataPath /tmp/VeilDerivedData`

**验证结果**：
- 通过。相关单测和全量测试均已恢复。

## 2026-05-24（Sparkle 与在线更新链路清理）

**触发原因**：
确认需要彻底移除 Sparkle、应用内版本探测和更新 consent 流程，只保留打开 GitHub Releases 的人工入口，并让 release workflow 与 README 对齐。

**修改内容**：
1. `Veil/Settings/SettingsPanes/AboutSettingsPane.swift`、`Veil/MenuBar/ControlItem/ControlItem.swift`、`Veil/Utilities/Constants.swift` — 去掉应用内在线更新检查，只保留打开 GitHub Releases 的入口。
2. `Veil/Resources/Info.plist`、`Veil.xcodeproj/project.pbxproj`、`Veil.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved` — 删除 Sparkle appcast keys、package 引用和残留 pin。
3. `.github/workflows/release.yml` — 将 release workflow 从 draft 改为直接发布，和 `releases/latest` 入口保持一致。
4. `VeilTests/AdvancedSettingsSnapshotTests.swift`、`VeilTests/DisplayIceBarConfigurationTests.swift`、`VeilTests/GeneralSettingsSnapshotTests.swift`、`VeilTests/ProfileTests.swift`、`VeilTests/SettingsResetterTests.swift` — 补充回归测试，覆盖删除后的默认值和兼容行为。
5. `project-log/*.md`、`README.md`、`sonar-project.properties` — 同步清理文档、规划记录和静态分析配置中的旧更新引用。

**遇到的问题**：
- 本地化资源里还残留旧的更新相关文案，需要同步清理。

**解决方式**：
- 直接删除已废弃的更新相关字符串条目，保留其余本地化资源不动。

**验证方式**：
- `xcodebuild test -project Veil.xcodeproj -scheme Veil -destination 'platform=macOS' CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO -derivedDataPath /tmp/VeilDerivedData`

**验证结果**：
- 通过。macOS 全量测试成功，说明删除更新链路没有引入新的编译或单测回归。
