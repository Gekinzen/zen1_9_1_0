#!/bin/bash

# Kill any existing wofi processes first (TOGGLE BEHAVIOR)
if pgrep -x "wofi" > /dev/null; then
    pkill -x "wofi"
    sleep 0.2
    exit 0
fi

# SINGLE INSTANCE CHECK
LOCK_FILE="/tmp/app-grid-launcher.lock"
if [ -f "$LOCK_FILE" ]; then
    PID=$(cat "$LOCK_FILE")
    if ps -p "$PID" > /dev/null 2>&1; then
        echo "Already running - exiting..."
        exit 0
    else
        rm -f "$LOCK_FILE"
    fi
fi

echo $$ > "$LOCK_FILE"
trap "rm -f $LOCK_FILE" EXIT

sleep 0.1

# Get screen resolution
SCREEN_WIDTH=$(hyprctl monitors -j | jq '.[0].width')
SCREEN_HEIGHT=$(hyprctl monitors -j | jq '.[0].height')

# Calculate 80% of screen size
WOFI_WIDTH=$((SCREEN_WIDTH * 30 / 100))
WOFI_HEIGHT=$((SCREEN_HEIGHT * 30 / 100))

# Calculate centering offset (10% from each edge)
X_OFFSET=$((SCREEN_WIDTH * 20 / 100))
Y_OFFSET=$((SCREEN_HEIGHT * 4 / 100))

# Launch fullscreen app grid with proper centering
wofi --show drun \
    --allow-images \
    --insensitive \
    --columns 6 \
    --lines 4 \
    --width $WOFI_WIDTH \
    --height $WOFI_HEIGHT \
    --xoffset $X_OFFSET \
    --yoffset $Y_OFFSET \
    --image-size 72 \
    --prompt "Search..." \
    --style ~/.config/wofi/app-grid-pywal.css \
    --no-actions

rm -f "$LOCK_FILE"