#!/usr/bin/env sh

hyprland_conf="$HOME/.config/hypr/hyprland.conf"
hy3_conf="\~/.config/hypr/hyprland/hy3/general.conf"
dwindle_conf="\~/.config/hypr/hyprland/dwindle/general.conf"
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
hy3_logo="$script_dir/hy3_logo.svg"

switch_to_dwindle() {
    sed -i -e "s|^#\s*source\s*=\s*$dwindle_conf|source = $dwindle_conf|" -e "s|^source\s*=\s*$hy3_conf|# source = $hy3_conf|" "$hyprland_conf"
    hyprctl reload
}

switch_to_hy3() {
    sed -i -e "s|^#\s*source\s*=\s*$hy3_conf|source = $hy3_conf|" -e "s|^source\s*=\s*$dwindle_conf|# source = $dwindle_conf|" "$hyprland_conf"
    hyprctl reload
}

check_hy3() {
    error_pattern="Config error in file .*hy3/.*.conf at line [0-9]*: Invalid dispatcher, requested \"hy3:.*\" does not exist"
    output=$(hyprctl configerrors)
    if [[ "$output" =~ $error_pattern ]]; then
        return 1
    else
        return 0
    fi
}

check_hy3_and_failback() {
    switch_to_hy3
    if ! check_hy3; then
        notify-send -i "$hy3_logo" "hy3" "hy3 configuration error detected. Failing back to dwindle configuration."
        switch_to_dwindle
    else
        notify-send -i "$hy3_logo" "hy3" "Using hy3 configuration."
    fi
}

check_hy3_and_failback
