#!/bin/bash

# Auto-detect monitor orientation and launch appropriate rofi theme

# Get primary monitor resolution
MONITOR_INFO=$(xrandr --current | grep ' connected primary' | head -n1)

# If no primary monitor found, get first connected monitor
if [ -z "$MONITOR_INFO" ]; then
    MONITOR_INFO=$(xrandr --current | grep ' connected' | head -n1)
fi

# Extract resolution
RESOLUTION=$(echo "$MONITOR_INFO" | grep -oP '\d+x\d+' | head -n1)
MONITOR_WIDTH=$(echo "$RESOLUTION" | cut -d 'x' -f1)
MONITOR_HEIGHT=$(echo "$RESOLUTION" | cut -d 'x' -f2)

# Set rofi directory
dir="$HOME/.config/rofi"
theme='search-app'  # Default theme

# Choose theme based on orientation
if [ "$MONITOR_WIDTH" -gt "$MONITOR_HEIGHT" ]; then
    # Landscape/Horizontal monitor (Ultrawide, Normal)
    theme='system-settings-v3'
else
    # Portrait/Vertical monitor
    theme='system-settings-v3-vertical'
fi

## Run rofi with detected theme
rofi \
    -show drun \
    -theme ${dir}/${theme}.rasi