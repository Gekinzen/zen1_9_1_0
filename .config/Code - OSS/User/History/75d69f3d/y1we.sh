#!/bin/bash
CONFIG="$HOME/.config/nwg-dock-hyprland/config"
LOGFILE="/tmp/nwg-dock.log"

# Kill any running instance cleanly
if pgrep -f nwg-dock-hyprland >/dev/null; then
    echo "Killing existing dock instance..."
    pkill -f nwg-dock-hyprland
    sleep 0.4
fi

# Start dock in resident mode (no autohide)
echo "Starting dock..."
nwg-dock-hyprland -m -r -c "$CONFIG" > "$LOGFILE" 2>&1 & disown

echo "Dock launched. Log at: $LOGFILE"
