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

# Debug info (optional - comment out if not needed)
# echo "Monitor: $MONITOR_WIDTH x $MONITOR_HEIGHT"

# Choose theme based on orientation
if [ "$MONITOR_WIDTH" -gt "$MONITOR_HEIGHT" ]; then
    # Landscape/Horizontal monitor (Ultrawide, Normal)
    THEME="$HOME/.config/rofi/system-settings-v3.rasi"
else
    # Portrait/Vertical monitor
    THEME="$HOME/.config/rofi/system-settings-v3-vertical.rasi"
fi

# Launch rofi with appropriate theme
rofi -show drun -theme "$THEME"