#!/usr/bin/env sh

hyprland_conf="$HOME/.config/hypr/hyprland.conf"
hy3_conf="\~/.config/hypr/hyprland/hy3/general.conf"
dwindle_conf="\~/.config/hypr/hyprland/dwindle/general.conf"

switch_to_dwindle() {
    hyprctl dispatch exec "hyprpm disable hy3"
    sed -i -e "s|^#\s*source\s*=\s*$dwindle_conf|source = $dwindle_conf|" -e "s|^source\s*=\s*$hy3_conf|# source = $hy3_conf|" "$hyprland_conf"
    hyprctl reload
}

switch_to_hy3() {
    hyprpm enable hy3
    sed -i -e "s|^#\s*source\s*=\s*$hy3_conf|source = $hy3_conf|" -e "s|^source\s*=\s*$dwindle_conf|# source = $dwindle_conf|" "$hyprland_conf"
    hyprctl reload
}

update_hy3() {
    if ! hyprpm update; then
        notify-send "hyprpm update faild, try again with --no-shallow"
        if ! hyprpm update --no-shallow; then
            notify-send "hyprpm update --no-shallow faild"
            return 1
        fi
    fi
    notify-send "hyprpm plugins updated"
}

check_hy3() {
    error_pattern="Config error in file /home/huangqixuan/.config/hypr/hyprland/hy3/keybinds.conf at line [0-9]*: Invalid dispatcher, requested \"hy3:.*\" does not exist"
    switch_to_hy3 >/dev/null 2>&1
    output=$(hyprctl configerrors)
    if [[ "$output" =~ $error_pattern ]]; then
        return 1
    else
        return 0
    fi
}

check_hy3_and_update() {
    if ! check_hy3; then
        notify-send "hy3 not up to date, switch to dwindle config"
        switch_to_dwindle
        if update_hy3; then
            notify-send "updated, switch back to hy3 config"
            if ! check_hy3; then
                notify-send "hy3 still in error, please check. Switch back to dwindle again"
                switch_to_dwindle
            fi
        fi
    else
        notify-send "using hy3"
    fi
}

check_hy3_and_update
