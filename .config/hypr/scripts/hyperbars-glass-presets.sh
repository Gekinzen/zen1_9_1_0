#!/bin/bash

PRESET=$1

case "$PRESET" in
    "subtle")
        # 93% opacity - subtle glass
        OPACITY="ee"
        ;;
    "balanced")
        # 87% opacity - balanced
        OPACITY="dd"
        ;;
    "strong")
        # 80% opacity - strong glass
        OPACITY="cc"
        ;;
    "extreme")
        # 70% opacity - extreme transparency
        OPACITY="b3"
        ;;
    *)
        echo "Usage: $0 [subtle|balanced|strong|extreme]"
        exit 1
        ;;
esac

source ~/.cache/wal/colors.sh
BG="${background#\#}"

sed -i "s/bar_color = rgba([^)]*)/bar_color = rgba(${BG}${OPACITY})/" ~/.config/hypr/hyprland.conf

hyprctl reload
notify-send "󰖲 Glass Preset" "$PRESET applied" -t 2000
