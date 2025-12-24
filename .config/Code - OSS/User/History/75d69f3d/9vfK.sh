#!/usr/bin/env bash
# Dock manager - ensures single instance + auto sync Pywal colors

CONFIG_DIR="$HOME/.config/nwg-dock-hyprland"
CONFIG_FILE="$CONFIG_DIR/config"
STYLE_FILE="$CONFIG_DIR/style.css"
PYWAL_CSS="$HOME/.cache/wal/colors-waybar.css"

start_dock() {
    # Kill existing dock (avoid duplicates)
    pkill -f nwg-dock-hyprland
    sleep 0.3

    # Sync Pywal colors to dock
    if [[ -f "$PYWAL_CSS" ]]; then
        echo "@import url(\"$PYWAL_CSS\");" > "$STYLE_FILE"
        echo "" >> "$STYLE_FILE"
        echo "/* nwg-dock-hyprland synced with pywal */" >> "$STYLE_FILE"
        echo ".dock { background-color: var(--background); }" >> "$STYLE_FILE"
        echo ".dock button:hover { background-color: var(--color1); }" >> "$STYLE_FILE"
    fi

    # Launch dock (top, exclusive zone)
    nwg-dock-hyprland -l top -x -c "$CONFIG_FILE" &
}

case "$1" in
    start)
        start_dock
        ;;
    restart)
        start_dock
        ;;
    stop)
        pkill -f nwg-dock-hyprland
        ;;
    *)
        echo "Usage: $0 {start|restart|stop}"
        exit 1
        ;;
esac
