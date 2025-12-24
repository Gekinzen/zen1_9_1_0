#!/bin/bash

CONFIG_FILE="$HOME/.config/nwg-dock-hyprland/dock.conf"
DOCK_CONFIG="$HOME/.config/nwg-dock-hyprland/config"
DOCK_CONFIG_AUTOHIDE="$HOME/.config/nwg-dock-hyprland/config-autohide"
CSS_FILE="$HOME/.config/nwg-dock-hyprland/style.css"

# Create configs directory
mkdir -p "$HOME/.config/nwg-dock-hyprland"

# Create dock.conf if doesn't exist
if [ ! -f "$CONFIG_FILE" ]; then
    cat > "$CONFIG_FILE" << 'EOF'
DOCK_ENABLED=true
AUTO_HIDE=false
POSITION=bottom
ICON_SIZE=40
EOF
fi

# Create always-visible config with custom launcher
cat > "$DOCK_CONFIG" << 'EOF'
{
  "output": "",
  "layer": "overlay",
  "position": "bottom",
  "css": "style.css",
  "exclusive-zone": true,
  "hotspot-delay": 0,
  "img-size": 40,
  "icon-size": 40,
  "margin-bottom": 0,
  "launcher-cmd": "~/.config/hypr/scripts/rofi-app-launcher.sh"
}
EOF

# Create autohide config with custom launcher
cat > "$DOCK_CONFIG_AUTOHIDE" << 'EOF'
{
  "output": "",
  "layer": "overlay",
  "position": "bottom",
  "css": "style.css",
  "exclusive-zone": false,
  "hotspot-delay": 20,
  "img-size": 40,
  "icon-size": 40,
  "margin-bottom": 8,
  "launcher-cmd": "~/.config/hypr/scripts/rofi-app-launcher.sh"
}
EOF

# Create pywal-synced CSS
cat > "$CSS_FILE" << 'EOF'
@import url("/home/paul/.cache/wal/colors-waybar.css");

window {
    background-color: alpha(@background, 0.75);
    border-radius: 16px;
    padding: 6px;
    margin: 8px;
    border: 1px solid alpha(@color12, 0.25);
    box-shadow: 0 6px 25px rgba(0, 0, 0, 0.5);
}

#box {
    padding: 3px;
    background-color: transparent;
}

button {
    all: unset;
    background-color: transparent;
    border-radius: 10px;
    padding: 6px;
    margin: 2px;
    transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
    min-width: 40px;
    min-height: 40px;
}

button:hover {
    background-color: alpha(@color12, 0.35);
    box-shadow: 0 3px 10px alpha(@color12, 0.3);
    transform: translateY(-2px);
}

button:active {
    background-color: alpha(@color12, 0.5);
    transform: translateY(0px);
}

button image {
    background-color: transparent;
    border-radius: 8px;
    min-width: 40px;
    min-height: 40px;
}

/* Launcher button special styling */
#launcher {
    background-color: alpha(@color12, 0.2);
    border: 1px solid alpha(@color12, 0.3);
}

#launcher:hover {
    background-color: alpha(@color12, 0.45);
}
EOF

# Load config
source "$CONFIG_FILE"

# Function to kill dock
kill_dock() {
    pkill -9 nwg-dock-hypr 2>/dev/null
    pkill -9 nwg-dock-hyprland 2>/dev/null
    sleep 0.3
}

# Function to start dock based on auto-hide setting
start_dock() {
    source "$CONFIG_FILE"
    
    if [ "$AUTO_HIDE" = "true" ]; then
        nwg-dock-hyprland -c "$DOCK_CONFIG_AUTOHIDE" -d &
    else
        nwg-dock-hyprland -c "$DOCK_CONFIG" &
    fi
}

# Function to toggle dock
toggle_dock() {
    if pgrep -x "nwg-dock-hypr" > /dev/null; then
        kill_dock
        sed -i 's/DOCK_ENABLED=.*/DOCK_ENABLED=false/' "$CONFIG_FILE"
        notify-send "󰘔 Dock" "Disabled" -i view-grid-symbolic
    else
        kill_dock
        start_dock
        sed -i 's/DOCK_ENABLED=.*/DOCK_ENABLED=true/' "$CONFIG_FILE"
        notify-send "󰘔 Dock" "Enabled" -i view-grid-symbolic
    fi
}

# Function to toggle auto-hide
toggle_autohide() {
    source "$CONFIG_FILE"
    
    if [ "$AUTO_HIDE" = "true" ]; then
        sed -i 's/AUTO_HIDE=.*/AUTO_HIDE=false/' "$CONFIG_FILE"
        notify-send "󰘔 Dock" "Always Visible" -i view-grid-symbolic
    else
        sed -i 's/AUTO_HIDE=.*/AUTO_HIDE=true/' "$CONFIG_FILE"
        notify-send "󰘔 Dock" "Auto-hide Enabled" -i view-grid-symbolic
    fi
    
    # Restart dock to apply changes
    kill_dock
    sleep 0.3
    start_dock
}

# Handle commands
case "$1" in
    toggle) toggle_dock ;;
    autohide) toggle_autohide ;;
    start) start_dock ;;
    *) toggle_dock ;;
esac