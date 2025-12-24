#!/bin/bash

# Single instance check
source ~/.config/hypr/scripts/single-instance.sh
single_instance_check "swaync-refresh"

# Check if swaync is running
if pgrep -x "swaync" > /dev/null; then
    # Reload config and CSS
    swaync-client --reload-config
    swaync-client --reload-css
    notify-send "Swaync" "Configuration reloaded" -i preferences-desktop
else
    # Start swaync
    swaync &
    notify-send "Swaync" "Notification daemon started" -i preferences-desktop
fi