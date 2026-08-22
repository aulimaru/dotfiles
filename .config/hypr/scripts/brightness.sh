#!/usr/bin/env sh

case "${1:-}" in
    up|down) direction=$1 ;;
    *)
        printf 'Usage: %s {up|down}\n' "$0" >&2
        exit 2
        ;;
esac

current=$(brightnessctl get) || exit 1
maximum=$(brightnessctl max) || exit 1
current_scaled=$((current * 100))
five_percent=$((maximum * 5))
ten_percent=$((maximum * 10))

if [ "$direction" = down ]; then
    if [ "$current_scaled" -le "$five_percent" ]; then
        exec brightnessctl set 1%-
    elif [ "$current_scaled" -le "$ten_percent" ]; then
        exec brightnessctl set 5%
    else
        exec brightnessctl set 5%-
    fi
else
    if [ "$current_scaled" -lt "$five_percent" ]; then
        exec brightnessctl set 1%+
    else
        exec brightnessctl set 5%+
    fi
fi
