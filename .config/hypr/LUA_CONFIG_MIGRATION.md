# Hyprland Lua 配置迁移说明

Hyprland 0.55 起推荐使用 Lua 配置。本配置的入口已改为：

```text
~/.config/hypr/hyprland.lua
```

旧 `.conf` 文件暂时保留作为迁移前记录，但 Hyprland 会优先读取 `hyprland.lua`。

## 文件结构

```text
hyprland.lua                    # 入口与模块加载顺序
hyprland/lua/general.lua        # 输入、通用、XWayland 等选项
hyprland/lua/monitors.lua       # 显示器和工作区规则
hyprland/lua/rules.lua          # 窗口规则
hyprland/lua/environment.lua    # 环境变量
hyprland/lua/theme.lua          # Tokyo Night 外观与动画
hyprland/lua/hy3.lua            # Hy3 插件选项
hyprland/lua/hy3-binds.lua      # Hy3 插件快捷键
hyprland/lua/dwindle-binds.lua  # Hy3 不可用时的 Dwindle 快捷键
hyprland/lua/layout.lua         # API 检测与布局选择
hyprland/lua/layout-binds.lua   # 对应布局的快捷键选择
hyprland/lua/binds.lua          # 通用快捷键
hyprland/lua/autostart.lua      # 启动事件
```

## 主要语法变化

### 1. 配置块改为 Lua table

旧语法：

```conf
input {
    kb_layout = us
    touchpad {
        natural_scroll = true
    }
}
```

Lua：

```lua
hl.config({
    input = {
        kb_layout = "us",
        touchpad = {
            natural_scroll = true,
        },
    },
})
```

关键区别：

- 字符串需要引号。
- 布尔值直接写 `true` / `false`。
- 字段之间使用逗号。
- 嵌套配置使用 `{}` table。

### 2. `source` 改为 `require`

旧语法：

```conf
source = ~/.config/hypr/hyprland/general.conf
```

Lua：

```lua
require("hyprland.lua.general")
```

Hyprland 会跟踪被 `require` 的配置文件；保存模块也会触发自动重载。

### 3. 变量改为 Lua 局部变量或模块返回值

旧语法：

```conf
$mainMod = SUPER
```

Lua：

```lua
local main_mod = "SUPER"
```

模块也可以返回共享值：

```lua
local theme = require("hyprland.lua.theme")
print(theme.wallpaper)
```

### 4. 快捷键使用 `hl.bind` 和 dispatcher

旧语法：

```conf
bind = $mainMod, V, togglefloating
bindl = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
```

Lua：

```lua
hl.bind(main_mod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(
    "XF86AudioMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
    { locked = true }
)
```

旧的 bind 后缀改成选项 table：

- `bindl` → `{ locked = true }`
- `binde` → `{ repeating = true }`
- `bindr` → `{ release = true }`
- `bindm` → `{ mouse = true }`

工作区快捷键现在由循环生成，不再重复写 1–10：

```lua
for workspace = 1, 10 do
    local key = workspace % 10
    hl.bind(main_mod .. " + " .. key, hl.dsp.focus({ workspace = workspace }))
end
```

亮度快捷键仍调用 `scripts/brightness.sh`，其低亮度步进逻辑没有改变。

### 5. 显示器和规则改用专用函数

```lua
hl.monitor({
    output = "eDP-1",
    mode = "1920x1080@120.00",
    position = "auto",
    scale = 1,
    bitdepth = 10,
})

hl.workspace_rule({
    workspace = "2",
    monitor = "eDP-1",
})
```

窗口规则把匹配条件放进 `match`：

```lua
hl.window_rule({
    name = "keepassxc-1",
    match = {
        class = "org.keepassxc.KeePassXC",
        float = true,
    },
    pin = true,
})
```

### 6. 环境变量使用 `hl.env`

```lua
hl.env("XCURSOR_SIZE", "24")
```

当前配置把环境变量放在 table 中，再通过循环设置，因此重复项只需保留一次。

### 7. Autostart 使用事件

旧 `exec-once` 改为监听 Hyprland 启动：

```lua
hl.on("hyprland.start", function()
    hl.exec_cmd("waybar")
end)
```

`hl.exec_cmd` 是异步的，并通过 shell 执行，因此原有管道、重定向、`&&` 和命令替换仍可使用。窗口启动规则可直接作为第二个参数传入：

```lua
hl.exec_cmd("librewolf", { workspace = "1 silent" })
```

### 8. 插件配置和接口

插件只由 HyprPM 管理和加载。Lua 入口不直接引用 Hy3 `.so` 路径。启动时：

```lua
hl.exec_cmd("hyprpm reload -n && ~/.config/hypr/scripts/check_hy3_lua.sh")
```

检查脚本使用 `hyprctl repl` 读取 `hl.plugin.hy3` 的真实布尔值。若 HyprPM
刚加载 Hy3 而当前布局仍是 Dwindle，脚本在每个会话中最多触发一次受控 reload，
让 Lua 配置重新解析并选择 Hy3。

插件配置与插件函数只在 API 存在时执行：

```lua
if hl.plugin.hy3 ~= nil then
    hl.config({
        plugin = {
            hy3 = {
                group_inset = 10,
            },
        },
    })
end
```

Hy3 快捷键直接使用插件提供的 Lua dispatcher factory，例如：

```lua
local hy3 = hl.plugin.hy3
hl.bind("SUPER + H", hy3.move_focus("l", { visible = true }))
```

配置不模拟旧 Hy3 dispatcher 或旧插件配置接口。布局选择逻辑位于
`hyprland/lua/layout.lua`：只有 `hl.plugin.hy3` 存在时才使用 Hy3，否则使用
Dwindle，并加载 `dwindle-binds.lua`。

启动时 HyprPM 是唯一插件加载方；`scripts/check_hy3_lua.sh` 将加载完成状态
桥接回 Lua 配置。若 API 不存在就保持 Dwindle；若 API 已存在但配置尚未选择
Hy3，则每个会话只重载一次。

## 显示器自动布局

`hyprland/lua/monitors.lua` 保存通用 fallback、内屏配置和 workspace 规则。
`scripts/monitor_profiles.sh` 保存两个自动预设：

- 仅检测到内屏时：只确认 `eDP-1`，不再对已经移除的镜像对象发送配置。
- sysfs 检测到 `DP-1` 时：先确认内屏，再启用外屏并镜像 `eDP-1`。

脚本由 autostart 以 `--daemon` 模式启动，通过 Hyprland 事件 socket 监听显示器接入、移除和配置重载。事件发生后等待 500ms，并从 `/sys/class/drm/*-DP-1/status` 读取物理连接状态，再通过 Lua `hl.monitor` API 应用预设；单实例文件锁和当前 profile 记录会避免重复监听或重复应用。DP-1 的静态镜像规则已从 `monitors.lua` 删除，避免两个控制源竞争；收到 `configreloaded` 时，监听器会强制重应用当前物理 profile，因此重载后的通用 fallback 不会持续覆盖外屏布局。未知输出继续使用通用 `preferred` / `auto` 规则，不会被脚本自动禁用。

按 `SUPER + SHIFT + P` 可请求一次手动检查。监听器正在运行时，该请求会转交给监听器并串行执行；监听器未运行时，命令会以一次性模式完成检查。每次检查只显示触发原因和最终结果两条桌面通知，完整诊断记录写入 `${XDG_RUNTIME_DIR}/hypr-monitor-profiles.log`。

修改分辨率、刷新率、缩放或镜像关系时，直接编辑
`scripts/monitor_profiles.sh` 内传给 `hl.monitor` 的字段。例如将镜像改成扩展桌面，
可以删除：

```lua
mirror = "eDP-1",
```

并把外屏 `position` 改成 `"auto-right"`。新增显示器时，可在脚本的
`apply_profile()` 中增加连接器判断及对应的一组 `hl.monitor` 调用。

## Lua 配置带来的功能

- 使用 `for` 循环生成重复配置。
- 使用 `local` 避免全局变量污染。
- 使用 table 组织主题、命令和方向映射。
- 使用函数与模块复用配置。
- 使用事件回调处理启动、窗口、显示器等事件。
- `hl.bind`、窗口规则等会返回 handle，可在运行时启用、禁用或移除。
- 可使用标准 Lua 库处理字符串、表和条件逻辑。
- Hyprland 提供 Lua REPL：`hyprctl repl`。
- 编辑器类型信息位于 `/usr/share/hypr/stubs/hl.meta.lua`。

Lua 配置可以执行任意程序，只应加载可信配置。

## 验证与重载

检查 Lua 语法：

```sh
luac -p ~/.config/hypr/hyprland.lua ~/.config/hypr/hyprland/lua/*.lua
```

让 Hyprland 验证配置但不启动会话：

```sh
Hyprland --verify-config --config ~/.config/hypr/hyprland.lua
```

重载并检查错误：

```sh
hyprctl reload
hyprctl configerrors
```

## 回滚

由于 `hyprland.lua` 优先于 `hyprland.conf`，临时回滚可将 Lua 入口改名，然后重启 Hyprland：

```sh
mv ~/.config/hypr/hyprland.lua ~/.config/hypr/hyprland.lua.disabled
```

恢复时再改回 `hyprland.lua`。旧 `.conf` 文件目前未删除。

## 参考资料

- [Hyprland: Start Here](https://wiki.hypr.land/Configuring/Start/)
- [官方 Lua 示例](https://github.com/hyprwm/Hyprland/blob/v0.56.1/example/hyprland.lua)
- [Binds](https://wiki.hypr.land/Configuring/Basics/Binds/)
- [Window Rules](https://wiki.hypr.land/Configuring/Basics/Window-Rules/)
- [Using Plugins](https://wiki.hypr.land/Plugins/Using-Plugins/)
