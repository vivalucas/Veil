# API 设计

> 更新频率：中
> 最近更新：2026-05-19

## API 类型

Veil 没有 HTTP API。当前对外自动化接口主要是 macOS URL scheme：

- `veil://`
- `veilctl://`

详细参数以 `docs/URI_SCHEMES.md` 为准。

## `veil://` 主要 action

| Action | 示例 | 说明 |
|--------|------|------|
| Toggle section | `veil://toggle-hidden` | 切换隐藏菜单栏 section。 |
| Toggle Veil Bar | `veil://toggle-veilbar` | 切换当前 active display 的 Veil Bar。 |
| Open settings | `veil://open-settings` | 打开设置页。 |
| Authorize | `veil://authorize` | 触发外部 app 授权。 |
| Set setting | `veil://set?key=useIceBar&value=true` | 设置支持的配置项。 |
| Get setting | `veil://get?key=useIceBar&callback=...` | 读取配置项并通过 callback 返回。 |
| Toggle setting | `veil://toggle?key=useIceBar` | 切换 boolean 配置项。 |

## `veilctl://`

`VeilCtl` 用于接收 callback 或辅助自动化。当前实现中 URL scheme 判断使用小写 `veilctl`，避免 `URL.scheme?.lowercased()` 后比较失败。

## 授权模型

部分读写设置的 URI 请求需要 whitelist authorization。外部 app 可先调用 `veil://authorize` 主动申请授权。

授权状态、调用 app 名称、bundle id 和签名信息由现有实现处理。此处不记录敏感信息。

## 兼容性说明

内部 setting key 仍包含 `useIceBar`、`iceBarLocation`、`iceBarLayout` 等历史命名。第一阶段暂不修改这些 key，以降低设置、profiles 和测试的破坏风险。

## 不适用项

- REST API：不适用。
- GraphQL API：不适用。
- 数据库 API：不适用。
