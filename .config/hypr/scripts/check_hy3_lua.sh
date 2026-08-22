#!/usr/bin/env sh

runtime_dir="${XDG_RUNTIME_DIR:-/tmp}/hypr/${HYPRLAND_INSTANCE_SIGNATURE}"
reload_state="$runtime_dir/hy3-lua-reloaded"
hy3_logo="$HOME/.config/hypr/scripts/hy3_logo.svg"

notify() {
    notify-send -i "$hy3_logo" "hy3" "$1" 2>/dev/null || true
}

mkdir -p "$runtime_dir"
sleep 1

hy3_available=$(hyprctl repl 'return hl.plugin.hy3 ~= nil' 2>/dev/null)
layout=$(hyprctl getoption general:layout -j 2>/dev/null | jq -r '.str // empty')

if [ "$hy3_available" != "true" ]; then
    notify "HyprPM 尚未提供 Hy3 Lua API；保持 Dwindle。"
    exit 0
fi

if [ "$layout" = "hy3" ]; then
    : > "$reload_state"
    notify "Hy3 已由 HyprPM 加载，Lua 配置正在使用 Hy3。"
    exit 0
fi

if [ -e "$reload_state" ]; then
    notify "Hy3 已加载，但本会话已尝试过配置重载；保持当前布局。"
    exit 1
fi

: > "$reload_state"
notify "Hy3 已由 HyprPM 加载，重新解析 Lua 配置以启用 Hy3。"
hyprctl reload
