# 环境配置

> 更新频率：低
> 最近更新：2026-06-04

## 本地开发环境

| 项目 | 要求 | 说明 |
|------|------|------|
| macOS | macOS 26+ | 当前代码和 CI 以 macOS 26 为目标。 |
| Xcode | Xcode 26+ | CI 当前选择 `/Applications/Xcode_26.5.app`。 |
| SwiftLint | 最新 Homebrew 版本 | CI 中通过 `brew install swiftlint` 安装。 |
| SwiftFormat | 推荐安装 | Contributing 中要求本地格式化。 |
| create-dmg | Homebrew 安装 | Release workflow 中用于打包 DMG。 |

当前对话环境是 macOS，可运行 Xcode build/test。构建产物需按 `project-log/README.md` 要求清理。

## GitHub Actions 环境

| Workflow | Runner | 说明 |
|----------|--------|------|
| `ci.yml` | `macos-26` | SwiftLint、Xcode test、coverage 处理。 |
| `release.yml` | `macos-26` | 构建并上传 `Veil.dmg` 和 Sparkle `appcast.xml`。 |
| `build-dmg.yml` | `macos-26` | 手动构建开发 DMG artifact。 |

## Secrets

当前 release 方式不需要 Apple Developer secrets，但 Sparkle appcast 签名需要 Sparkle 私钥 secret。

| Secret | 是否需要 | 说明 |
|--------|----------|------|
| `GITHUB_TOKEN` | GitHub 自动提供 | 用于创建 GitHub Release。 |
| `SPARKLE_PRIVATE_KEY` | 必需 | Sparkle EdDSA 私钥，供 `generate_appcast --ed-key-file -` 签名更新包和 appcast；不得提交到仓库。 |
| Apple Developer certificate secret | 不需要 | 已移除 Developer ID signing。 |
| Apple account secret | 不需要 | 已移除 notarization。 |
| Apple team secret | 不需要 | 已移除 notarization。 |
| `SONAR_TOKEN` | 可选 | CI 中 SonarQube job 仍引用；如不使用可后续移除该 job。 |

## App 配置

| 配置 | 当前值 | 位置 |
|------|--------|------|
| Bundle ID | `io.github.vivalucas.Veil` | `Veil.xcodeproj/project.pbxproj` |
| Service Bundle ID | `io.github.vivalucas.Veil.MenuBarItemService` | `Veil.xcodeproj/project.pbxproj` |
| Tests Bundle ID | `io.github.vivalucas.VeilTests` | `Veil.xcodeproj/project.pbxproj` |
| URL Scheme | `veil` | `Veil/Resources/Info.plist` |
| Repo URL | `https://github.com/vivalucas/Veil` | `Veil/Resources/Info.plist` |
| Release URL | `https://github.com/vivalucas/Veil/releases/latest` | `Constants.releasesURL` 基于 Repo URL 拼接 |
| Sparkle Feed URL | `https://github.com/vivalucas/Veil/releases/latest/download/appcast.xml` | `Veil/Resources/Info.plist` |
| Sparkle Public Key | `SUPublicEDKey` | `Veil/Resources/Info.plist`；私钥在 GitHub secret 中 |

## 敏感信息规则

- 不要把真实 token、cookie、private key 或 Apple 账号信息写入仓库。
- 示例值统一使用占位符。
- 如果后续引入 Developer ID notarization，需要先在 `10-planning-log.md` 记录方案。
