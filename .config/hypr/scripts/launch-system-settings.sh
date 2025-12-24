#!/bin/bash

# Launch System Settings with Glassmorphism
# Single instance check
LOCK_FILE="/tmp/system-settings.lock"
if [ -f "$LOCK_FILE" ]; then
    PID=$(cat "$LOCK_FILE")
    if ps -p "$PID" > /dev/null 2>&1; then
        echo "System settings already running - closing..."
        kill "$PID" 2>/dev/null
        rm -f "$LOCK_FILE"
        pkill -x rofi
        exit 0
    else
        rm -f "$LOCK_FILE"
    fi
fi
echo $$ > "$LOCK_FILE"
trap "rm -f $LOCK_FILE" EXIT

# Ensure Hyprland blur is configured
# Add this to your hyprland.conf if not already there:
# windowrulev2 = blur, class:^(Rofi)$
# layerrule = blur, rofi

# Launch rofi with custom modi
rofi -show system-settings \
    -modi "system-settings:~/.config/rofi/scripts/system-settings-modi.sh" \
    -theme ~/.config/rofi/system-settings-glass.rasi \
    -show-icons

rm -f "$LOCK_FILE"
