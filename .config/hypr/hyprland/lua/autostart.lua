local M = {}

function M.setup(theme)
    hl.on("hyprland.start", function()
        hl.exec_cmd("hyprpm reload -n && ~/.config/hypr/scripts/check_hy3_lua.sh")
        hl.exec_cmd("~/.config/hypr/scripts/monitor_profiles.sh --daemon")

        hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
        hl.exec_cmd("dbus-update-activation-environment --all")
        hl.exec_cmd("xrdb ~/.Xresources")
        hl.exec_cmd("sleep 1 && dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

        hl.exec_cmd("awww-daemon")
        hl.exec_cmd("sleep 0.1 && awww img ~/.config/hypr/wallpapers/" .. theme.wallpaper)
        hl.exec_cmd("waybar")
        hl.exec_cmd("fcitx5")

        hl.exec_cmd("systemctl --user start hyprpolkitagent")
        hl.exec_cmd("hypridle")
        hl.exec_cmd("swaync")

        hl.exec_cmd("musnify-mpd")
        hl.exec_cmd("mpDris2")

        hl.exec_cmd("wl-paste --watch ~/.config/hypr/scripts/cliprust.sh")
        hl.exec_cmd([[wl-clip-persist -c both -f "^(?!x-kde-passwordManagerHint\$).+"]])

        hl.exec_cmd("cc-switch", {workspace = "8 silent"})

        hl.exec_cmd("librewolf", { workspace = "1 silent" })
        hl.exec_cmd("clash-verge", { workspace = "8 silent" })
        hl.exec_cmd("wechat.sh", { workspace = "9 silent" })
        hl.exec_cmd("keepassxc", { workspace = "10 silent" })
        -- hl.exec_cmd("sleep 1 && hyprctl dispatch movetoworkspacesilent 10, class:org.keepassxc.KeePassXC")

        hl.exec_cmd("sleep 1 && systemctl --user restart emacs.service")
    end)
end

return M
