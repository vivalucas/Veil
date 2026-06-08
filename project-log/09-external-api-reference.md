# 外部服务参考

> 更新频率：低
> 最近更新：2026-06-04

## GitHub

| 用途 | 地址 / 文件 |
|------|-------------|
| 仓库 | `https://github.com/vivalucas/Veil` |
| Releases | `https://github.com/vivalucas/Veil/releases` |
| Sparkle appcast | `https://github.com/vivalucas/Veil/releases/latest/download/appcast.xml` |
| Actions | `.github/workflows/*.yml` |

当前仓库为 private。准备 public 前需要处理 `project-log/` 历史，详见 `07-deployment.md` 和 `12-design-decisions.md`。

## macOS 系统 API

| API / Framework | 用途 |
|-----------------|------|
| Accessibility API | 识别和操作菜单栏项目。 |
| ScreenCaptureKit | 屏幕/窗口相关观察能力。 |
| SkyLight private framework | 菜单栏和窗口相关系统能力。 |
| AppKit Status Item | Veil 菜单栏控制入口。 |

## GitHub Actions 第三方 actions

| Action | 用途 |
|--------|------|
| `actions/checkout` | 拉取代码。 |
| `actions/upload-artifact` | 上传开发 DMG 或 coverage artifact。 |
| `actions/download-artifact` | 下载 coverage artifact。 |
| `softprops/action-gh-release` | 创建 GitHub Release。 |
| `SonarSource/sonarqube-scan-action` | 可选代码质量扫描。 |

## Sparkle

| 项目 | 用途 |
|------|------|
| Sparkle 2.9.2 | App 内检查、下载、安装并重启完成更新。 |
| `generate_appcast` | Release workflow 中生成并签名 `appcast.xml`。 |
| `SUPublicEDKey` | App 内验证更新包签名。 |
| `SPARKLE_PRIVATE_KEY` | GitHub secret，签名 release asset；不得提交。 |

## 不再使用

- 外部翻译平台：已移除。
- Apple notarization / Developer ID signing：当前无 Apple Developer 账号，已移除。
- GitHub agent issue triage：已移除。
<!-- 旧状态（废弃于 2026-06-04，原因：已重新引入 Sparkle 自动更新） -->
~~Sparkle：2026-05-24 已移除。当前不维护 appcast，也不在 App 内执行在线更新探测；用户通过 GitHub Releases 手动下载。~~
