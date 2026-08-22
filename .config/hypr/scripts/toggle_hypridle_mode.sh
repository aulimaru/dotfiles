#!/usr/bin/env bash

set -uo pipefail

config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/hypr"
long_config="$config_dir/hypridle-long.conf"
runtime_dir="${XDG_RUNTIME_DIR:-/tmp}"
state_file="$runtime_dir/hypridle-long-mode"
lock_file="$runtime_dir/hypridle-long-mode.lock"

notify() {
    notify-send -a "Hypridle" "Hypridle mode" "$1" 2>/dev/null || true
}

start_hypridle() {
    local config=${1:-}
    local pid

    pkill -x hypridle 2>/dev/null || true
    for _ in {1..40}; do
        pgrep -x hypridle >/dev/null || break
        sleep 0.05
    done

    if pgrep -x hypridle >/dev/null; then
        pkill -KILL -x hypridle 2>/dev/null || true
    fi

    if [ -n "$config" ]; then
        hypridle --config "$config" 9>&- >/dev/null 2>&1 &
    else
        hypridle 9>&- >/dev/null 2>&1 &
    fi

    pid=$!
    sleep 0.1
    kill -0 "$pid" 2>/dev/null
}

exec 9>"$lock_file"
if ! flock -w 2 9; then
    notify "Another mode switch is still running."
    exit 1
fi

if [ -e "$state_file" ]; then
    if start_hypridle; then
        rm -f "$state_file"
        notify "Normal mode restored."
    else
        notify "Failed to restore normal mode."
        exit 1
    fi
else
    if [ ! -r "$long_config" ]; then
        notify "Cannot read $long_config."
        exit 1
    fi

    if start_hypridle "$long_config"; then
        touch "$state_file"
        notify "Long-idle mode enabled: lock after 5 minutes; screen-off and suspend disabled."
    else
        notify "Failed to enable long-idle mode; restoring normal mode."
        start_hypridle || true
        exit 1
    fi
fi
