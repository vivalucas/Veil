# 部署与发布

> 更新频率：低
> 最近更新：2026-06-08

## 发布目标

Veil 当前计划通过 GitHub Releases 发布 DMG。仓库当前为 private，release workflow 可先在 private 状态下验证。

## 当前发布方式

1. 推送符合格式的 tag，例如 `1.1.6`。
2. GitHub Actions 在 macOS runner 上构建 `Veil.app`。
3. 使用 ad-hoc signing 构建 app。
4. 导出到 `build/Export` 后再次执行 ad-hoc deep re-sign，并验证签名，避免未公证分发下 Hardened Runtime library validation 拒绝加载 Sparkle。
5. 使用 `create-dmg` 打包为 `Veil.dmg`。
6. 使用 Sparkle `generate_appcast` 和 `SPARKLE_PRIVATE_KEY` secret 生成 `appcast.xml`。
7. 创建并发布 GitHub Release，上传 `Veil.dmg`、`appcast.xml` 和 `Veil.md`。

## 应用内更新

Veil 重新启用 Sparkle 2 自动更新。App 内 `SUFeedURL` 指向：

```text
https://github.com/vivalucas/Veil/releases/latest/download/appcast.xml
```

Release workflow 每次 tag 发布时会把 `appcast.xml` 和 `Veil.md` 作为 release assets 上传。`Veil.md` 是 Sparkle 更新窗口使用的 release notes link，不能漏传。Sparkle 使用 `SUPublicEDKey` 校验更新包签名；对应私钥不得提交到仓库，只能保存为 GitHub secret `SPARKLE_PRIVATE_KEY`。

## 不使用 Apple Developer ID 的影响

当前没有 Apple Developer 账号，因此不做 Developer ID signing 和 notarization。

用户首次启动时，macOS 可能提示应用已损坏或无法验证开发者。这是 Gatekeeper 对未公证应用的拦截。用户需要执行：

```sh
xattr -cr /Applications/Veil.app
```

然后从 `/Applications` 再次启动 Veil。

## 相关文件

- `.github/workflows/release.yml`
- `.github/workflows/build-dmg.yml`
- `.github/actions/build/action.yml`
- `.github/actions/export-and-package/action.yml`
- `README.md`

## macOS 验证清单

- [ ] `Veil.xcodeproj` 能在 Xcode 中打开。
- [ ] `Veil` scheme 能 build。
- [ ] `VeilTests` 能运行。
- [ ] `MenuBarItemService` 能随 app 正常构建。
- [ ] `VeilCtl` 如需发布，可单独验证 build。
- [ ] `Veil.dmg` 能产出。
- [ ] `appcast.xml` 和 `Veil.md` 能产出，并作为 release assets 上传。
- [ ] App 内 “Check for Updates” 能读取 appcast。
- [ ] DMG 拖入 `/Applications` 后 app 可启动。
- [ ] 执行 `xattr -cr /Applications/Veil.app` 后 Gatekeeper 拦截可解除。

## Public 前处理

当前 `project-log/` 可以提交到 private GitHub 仓库，便于内部开发记录同步。准备改为 public 前，需要：

1. 将 `project-log/` 加入 `.gitignore`。
2. 从公开历史中移除 `project-log/` 的提交痕迹。
3. 推荐方式是 public 前新建干净分支或用 `git filter-repo` / 等价工具清理历史。
4. 清理后重新检查 remote、tags、GitHub Releases 和 GitHub Actions。

注意：不要在未备份的情况下直接重写历史。执行前需要保存当前 private 仓库状态。
