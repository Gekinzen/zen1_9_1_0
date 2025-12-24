#!/usr/bin/env bash
# Relaunch nwg-dock-hyprland safely + auto-sync pywal colors

CONFIG_DIR="$HOME/.config/nwg-dock-hyprland"
CONFIG_FILE="$CONFIG_DIR/config"
STYLE_FILE="$CONFIG_DIR/style.css"
PYWAL_CSS="$HOME/.cache/wal/colors-waybar.css"

# Kill existing instance to avoid duplicates
pkill -f nwg-dock-hyprland
sleep 0.3

# Rebuild style.css if pywal colors exist
if [[ -f "$PYWAL_CSS" ]]; then
  echo "@import url(\"$PYWAL_CSS\");" > "$STYLE_FILE"
  echo "" >> "$STYLE_FILE"
  echo "/* nwg-dock-hyprland custom styles synced with pywal */" >> "$STYLE_FILE"
  echo ".dock { background-color: var(--background); }" >> "$STYLE_FILE"
  echo ".dock button:hover { background-color: var(--color1); }" >> "$STYLE_FILE"
fi

# Launch dock with your config
nwg-dock-hyprland -l top -x -c "$CONFIG_FILE" &
