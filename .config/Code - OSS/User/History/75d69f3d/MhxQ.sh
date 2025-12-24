#!/bin/bash

CONFIG_FILE="$HOME/.config/nwg-dock-hyprland/dock.conf"
DOCK_CONFIG="$HOME/.config/nwg-dock-hyprland/config"

# Create config directory
mkdir -p "$HOME/.config/nwg-dock-hyprland"

# Create dock.conf if doesn't exist
if [ ! -f "$CONFIG_FILE" ]; then
    cat > "$CONFIG_FILE" << 'EOF'
DOCK_ENABLED=true
AUTO_HIDE=true
POSITION=bottom
ICON_SIZE=48
EOF
fi

# Create main config if doesn't exist
if [ ! -f "$DOCK_CONFIG" ]; then
    cat > "$DOCK_CONFIG" << 'EOF'
{
  "output": "",
  "layer": "overlay",
  "position": "bottom",
  "css": "style.css",
  "exclusive-zone": false,
  "hotspot-delay": 20,
  "img-size": 48,
  "icon-size": 48,
  "margin-bottom": 8
}
EOF
fi

# Load config
source "$CONFIG_FILE"

# Function to kill all dock instances
kill_dock() {
    pkill -9 nwg-dock-hypr 2>/dev/null
    pkill -9 nwg-dock-hyprland 2>/dev/null
    sleep 0.3
}

# Function to toggle dock
toggle_dock() {
    if pgrep -x "nwg-dock-hypr" > /dev/null; then
        kill_dock
        sed -i 's/DOCK_ENABLED=.*/DOCK_ENABLED=false/' "$CONFIG_FILE"
        notify-send "󰘔 Dock" "Disabled" -i view-grid-symbolic
    else
        kill_dock  # Kill any existing instances first
        nwg-dock-hyprland -d > /tmp/nwg-dock.log 2>&1 &
        sed -i 's/DOCK_ENABLED=.*/DOCK_ENABLED=true/' "$CONFIG_FILE"
        notify-send "󰘔 Dock" "Enabled" -i view-grid-symbolic
    fi
}

# Function to toggle auto-hide
toggle_autohide() {
    source "$CONFIG_FILE"
    
    if [ "$AUTO_HIDE" = "true" ]; then
        sed -i 's/AUTO_HIDE=.*/AUTO_HIDE=false/' "$CONFIG_FILE"
        sed -i 's/"exclusive-zone": false/"exclusive-zone": true/' "$DOCK_CONFIG"
        notify-send "󰘔 Dock" "Auto-hide disabled - Always visible" -i view-grid-symbolic
    else
        sed -i 's/AUTO_HIDE=.*/AUTO_HIDE=true/' "$CONFIG_FILE"
        sed -i 's/"exclusive-zone": true/"exclusive-zone": false/' "$DOCK_CONFIG"
        notify-send "󰘔 Dock" "Auto-hide enabled" -i view-grid-symbolic
    fi
    
    # Restart dock to apply changes
    kill_dock
    sleep 0.3
    nwg-dock-hyprland -d > /tmp/nwg-dock.log 2>&1 &
}

# Handle commands
case "$1" in
    toggle) toggle_dock ;;
    autohide) toggle_autohide ;;
    *) toggle_dock ;;
esac