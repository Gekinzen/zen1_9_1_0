#!/bin/bash

# Rofi App Launcher with Icon Support
# Uses rofi in drun mode for proper app discovery

# Check if rofi is installed
if ! command -v rofi &> /dev/null; then
    notify-send "Error" "Rofi is not installed" -u critical
    exit 1
fi

# Kill any existing rofi instance
pkill rofi 2>/dev/null

# Launch rofi in drun (desktop run) mode
# This shows all applications with icons from .desktop files
rofi -show drun \
    -theme ~/.config/rofi/launchers/type-1/style-1.rasi \
    -show-icons \
    -icon-theme "Papirus-Dark" \
    -display-drun "Applications" \
    -drun-display-format "{name}" \
    -disable-history \
    -hide-scrollbar \
    -padding 20 \
    -line-padding 4 \
    -lines 10 \
    -columns 2 \
    -width 800 \
    -bw 0

# Alternative minimal config if theme doesn't exist:
# rofi -show drun -show-icons -icon-theme "Papirus-Dark"