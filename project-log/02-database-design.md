# 数据库设计

> 更新频率：中
> 最近更新：2026-05-24

## 结论

不适用。Veil 当前没有传统数据库，也没有远程后端数据库。

## 本地数据来源

| 数据类型 | 存储方式 | 说明 |
|----------|----------|------|
| App 设置 | `UserDefaults` | 通过 `Defaults` 封装读写。 |
| Profiles | Application Support 下的本地文件 | 由 `ProfileManager` 管理。 |
| 日志 | Application Support / Logs | 由 `DiagnosticLogger` 管理。 |
| 菜单栏项目缓存 | 内存 + 本地缓存 | 包含 image cache、PID cache 等。 |
| 更新状态 | 不适用 | 已移除 Sparkle 和在线更新探测，App 内仅打开 GitHub Releases 页面。 |

## 关键文件

- `Veil/Utilities/Defaults.swift`
- `Veil/Settings/Models/Profile.swift`
- `Veil/Settings/Models/ProfileManager.swift`
- `Shared/Utilities/DiagnosticLogger.swift`
- `Veil/MenuBar/MenuBarItems/MenuBarItemImageCache.swift`
- `MenuBarItemService/SourcePIDCache.swift`

## 数据兼容风险

| 风险 | 影响 | 当前策略 |
|------|------|----------|
| Bundle identifier 已改为 `io.github.vivalucas.Veil` | 用户默认设置域会变化，旧 app 设置不会自动沿用 | 第一阶段接受，后续如需迁移再设计迁移逻辑。 |
| 内部 setting key 仍有 `IceBar` / `iceBar` | 直接重命名会破坏已有设置和 profiles | 暂时保留内部 key，产品文案使用 Veil Bar。 |
| Profile 文件结构变更 | 可能导致旧 profile 无法导入 | 保留旧字段解码兼容；已删除的外观、菜单栏间距和菜单项功能不再应用旧值。 |

## 后续如果引入数据迁移

需要在改动前更新：

- `10-planning-log.md`：迁移方案、回滚方案、兼容策略。
- `12-design-decisions.md`：为什么迁移或为什么保持旧 key。
- `06-dev-log.md`：执行和验证记录。
