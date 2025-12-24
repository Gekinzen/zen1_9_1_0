#!/bin/bash

CONFIG_FILE="$HOME/.config/nwg-dock-hyprland/dock.conf"
DOCK_CONFIG="$HOME/.config/nwg-dock-hyprland/config"
DOCK_CONFIG_AUTOHIDE="$HOME/.config/nwg-dock-hyprland/config-autohide"

# Create configs directory
mkdir -p "$HOME/.config/nwg-dock-hyprland"

# Create dock.conf if doesn't exist
if [ ! -f "$CONFIG_FILE" ]; then
    cat > "$CONFIG_FILE" << 'EOF'
DOCK_ENABLED=true
AUTO_HIDE=false
POSITION=bottom
ICON_SIZE=32
EOF
fi

# Create always-visible config
cat > "$DOCK_CONFIG" << 'EOF'
{
  "output": "",
  "layer": "overlay",
  "position": "bottom",
  "css": "style.css",
  "exclusive-zone": true,
  "hotspot-delay": 0,
  "img-size": 32,
  "icon-size": 32,
  "margin-bottom": 20
}
EOF

# Create autohide config
cat > "$DOCK_CONFIG_AUTOHIDE" << 'EOF'
{
  "output": "",
  "layer": "overlay",
  "position": "bottom",
  "css": "style.css",
  "exclusive-zone": false,
  "hotspot-delay": 20,
  "img-size": 32,
  "icon-size": 32,
  "margin-bottom": 20
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
        notify-send "󰘔 Dock" "Always Visible - Windows will not overlap" -i view-grid-symbolic
    else
        sed -i 's/AUTO_HIDE=.*/AUTO_HIDE=true/' "$CONFIG_FILE"
        notify-send "󰘔 Dock" "Auto-hide Enabled" -i view-grid-symbolic
    fi
    
    # Restart dock to apply changes
    kill_dock
    start_dock
}

# Handle commands
case "$1" in
    toggle) toggle_dock ;;
    autohide) toggle_autohide ;;
    start) start_dock ;;
    *) toggle_dock ;;
esac