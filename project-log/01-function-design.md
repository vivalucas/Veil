# 功能设计

> 更新频率：中
> 最近更新：2026-05-24

## 功能模块总览

| 模块 | 目录 / 文件 | 说明 |
|------|-------------|------|
| App 生命周期 | `Veil/Main` | App 入口、delegate、状态管理、更新管理。 |
| 菜单栏控制入口 | `Veil/MenuBar/ControlItem` | Veil 自身的菜单栏 icon、菜单和控制逻辑。 |
| 菜单栏项目管理 | `Veil/MenuBar/MenuBarItems` | 发现、缓存、隐藏、显示和排序菜单栏项目。 |
| Veil Bar | `Veil/MenuBar/IceBar` | 展示隐藏项目的独立区域。内部命名仍沿用 `IceBar`，产品文案称 Veil Bar。 |
| Layout Bar | `Veil/MenuBar/LayoutBar` | 菜单栏项目布局、拖拽、间距、notch 指示等。 |
| 外观自定义 | `Veil/MenuBar/Appearance` | 旧版外观编辑实现仍保留在代码树中，但当前产品不再暴露可编辑入口。 |
| 设置 | `Veil/Settings` | 设置模型和各设置 pane。 |
| 权限 | `Veil/Permissions` | Accessibility、Screen Recording 等权限说明与引导。 |
| Hotkeys | `Veil/Hotkeys` | 快捷键定义、注册、触发动作。 |
| Profiles | `Veil/Settings/Models/Profile*` | 菜单栏布局保存、导入、应用和切换。 |
| Automation | `HookRunner.swift`、`SettingsURIHandler.swift` | URI scheme、hooks、外部 app 授权和自动化控制。 |
| XPC 服务 | `MenuBarItemService` / `Shared` | 菜单栏项目服务和共享类型。 |
| 测试 | `VeilTests` | 单元测试和快照/配置测试。 |

## 核心用户流程

### 隐藏和显示菜单栏项目

1. Veil 通过系统 API 识别菜单栏项目。
2. 用户在布局 UI 中移动项目到 visible、hidden 或 always hidden section。
3. 设置写入本地状态。
4. `MenuBarItemManager` 根据布局状态控制项目位置和可见性。

### 使用 Veil Bar

1. 用户开启 Veil Bar。
2. 隐藏项目在独立区域中展示，而不是直接在原菜单栏位置展开。
3. 可按显示器分别配置位置、布局和 grid columns。

### Profile 切换

1. 用户保存当前菜单栏布局为 Profile。
2. 通过设置页、菜单、hotkey、URI 或 hook 切换 Profile。
3. 切换前后可执行 automation hook。
4. ProfileManager 更新 active profile 并应用布局。

### URI Scheme 自动化

1. 外部工具调用 `veil://` URL。
2. `SettingsURIHandler` 解析 action、setting key、display scope 和 callback。
3. 对需要授权的读写操作进行 whitelist 检查。
4. 执行动作，并通过 callback URL 或 distributed notification 返回结果。

## 当前第一阶段重点

- 完成 Veil 品牌化和发布链路整理。
- 精简设置界面和运行时行为，移除不再需要的外观、间距、二级菜单和相关自动化入口。
- 保持现有功能可编译、可运行。
- 暂不新增用户功能。
- 暂不重命名内部所有 `Ice*` 类型，避免引入大规模兼容风险。

## 不适用项

- 数据库 CRUD 功能：不适用，Veil 是本地 macOS app。
- Web API 后端：不适用，项目没有远程服务。
