#!/usr/bin/env bash

set -uo pipefail

external_output="DP-1"
runtime_dir="${XDG_RUNTIME_DIR:-/tmp}"
lock_file="$runtime_dir/hypr-monitor-profile.lock"
pid_file="$runtime_dir/hypr-monitor-profile.pid"
log_file="$runtime_dir/hypr-monitor-profiles.log"
active_profile=""
last_error=""
manual_requested=0

log() {
    printf '%(%F %T)T %s\n' -1 "$1" >> "$log_file"
}

notify() {
    notify-send -a "Hyprland Monitor Profiles" "Monitor profiles" "$1" 2>/dev/null || true
}

connector_connected() {
    local status

    for status in /sys/class/drm/card*-"$external_output"/status; do
        [ -r "$status" ] || continue
        [ "$(<"$status")" = "connected" ] && return 0
    done

    return 1
}

apply_monitor() {
    local description=$1
    local config=$2
    local output

    if output=$(hyprctl eval "hl.monitor($config)" 2>&1); then
        log "$description: applied."
        return 0
    fi

    last_error="$description: $output"
    log "$last_error"
    return 1
}

apply_internal() {
    apply_monitor \
        "Confirm eDP-1" \
        '{ output = "eDP-1", mode = "2880x1800@120.00", position = "auto", scale = 1.5, bitdepth = 10 }'
}

apply_mirror() {
    apply_monitor \
        "Confirm eDP-1" \
        '{ output = "eDP-1", mode = "1920x1080@120.00", position = "auto", scale = 1, bitdepth = 10 }' || return 1
    apply_monitor \
        "Enable DP-1 mirror" \
        '{ output = "DP-1", mode = "1920x1080@100.00", position = "auto", scale = 1, mirror = "eDP-1", bitdepth = 10 }'
}

reconcile_profile() {
    local reason=$1
    local force=$2
    local profile

    notify "Trigger: $reason."
    log "Reconciliation triggered: $reason (force=$force)."
    sleep 0.5

    if connector_connected; then
        profile="aoc-mirror"
    else
        profile="internal"
    fi

    if [ "$force" != "true" ] && [ "$profile" = "$active_profile" ]; then
        log "Profile unchanged: $profile."
        notify "Result: $profile is already active."
        return 0
    fi

    last_error=""
    if [ "$profile" = "aoc-mirror" ]; then
        if apply_mirror; then
            :
        else
            active_profile=""
            log "Profile application failed: $profile. $last_error"
            notify "Result: failed to apply $profile."
            return 1
        fi
    elif apply_internal; then
        :
    else
        active_profile=""
        log "Profile application failed: $profile. $last_error"
        notify "Result: failed to apply $profile."
        return 1
    fi

    active_profile="$profile"
    log "Profile applied: $active_profile."
    notify "Result: switched to $active_profile."
    return 0
}

process_start_time() {
    local pid=$1

    awk '{print $22}' "/proc/$pid/stat" 2>/dev/null
}

request_daemon_reconcile() {
    local daemon_pid daemon_start current_start

    if ! read -r daemon_pid daemon_start < "$pid_file"; then
        log "Manual reconciliation requested, but no daemon PID record exists."
        return 1
    fi

    if ! [[ "$daemon_pid" =~ ^[0-9]+$ ]] || ! kill -0 "$daemon_pid" 2>/dev/null; then
        log "Manual reconciliation found a stale daemon PID record."
        rm -f "$pid_file"
        return 1
    fi

    current_start=$(process_start_time "$daemon_pid")
    if [ -z "$current_start" ] || [ "$current_start" != "$daemon_start" ]; then
        log "Manual reconciliation refused to signal a stale daemon PID record."
        rm -f "$pid_file"
        return 1
    fi

    kill -USR1 "$daemon_pid"
    log "Manual reconciliation requested from daemon PID $daemon_pid."
}

run_one_shot() {
    exec 9>"$lock_file"
    if flock -n 9; then
        reconcile_profile "manual shortcut" false
        return $?
    fi

    request_daemon_reconcile
}

cleanup_daemon() {
    rm -f "$pid_file"
}

run_daemon() {
    local socket event event_fd event_pid

    exec 9>"$lock_file"
    if ! flock -n 9; then
        log "Monitor profile listener is already running; daemon startup exits."
        return 0
    fi

    socket="$runtime_dir/hypr/${HYPRLAND_INSTANCE_SIGNATURE:-}/.socket2.sock"
    if [ ! -S "$socket" ]; then
        log "Hyprland event socket is unavailable; daemon exits: $socket"
        return 1
    fi

    printf '%s %s\n' "$$" "$(process_start_time "$$")" > "$pid_file"
    trap cleanup_daemon EXIT
    trap 'manual_requested=1' USR1

    reconcile_profile "Hyprland startup" false

    coproc EVENT_STREAM { ncat -U "$socket"; }
    event_fd=${EVENT_STREAM[0]}
    event_pid=$EVENT_STREAM_PID
    log "Monitor profile listener started (PID $$)."

    while kill -0 "$event_pid" 2>/dev/null; do
        event=""
        if IFS= read -r -t 1 event <&"$event_fd"; then
            case "$event" in
                monitoradded*)
                    reconcile_profile "monitor added" false
                    ;;
                monitorremoved*)
                    reconcile_profile "monitor removed" false
                    ;;
                configreloaded*)
                    reconcile_profile "Hyprland configuration reloaded" true
                    ;;
            esac
        fi

        if [ "$manual_requested" -eq 1 ]; then
            manual_requested=0
            reconcile_profile "manual shortcut" false
        fi
    done

    wait "$event_pid" || true
    log "Hyprland event socket disconnected; daemon exits."
    return 1
}

case "${1:---daemon}" in
    --daemon)
        run_daemon
        ;;
    --reconcile)
        run_one_shot
        ;;
    *)
        printf 'Usage: %s [--daemon|--reconcile]\n' "$0" >&2
        exit 2
        ;;
esac
