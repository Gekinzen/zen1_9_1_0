#!/bin/bash

# Load monitor config
if [ -f ~/.config/hypr/workspace-monitors.conf ]; then
    source ~/.config/hypr/workspace-monitors.conf
else
    echo "No workspace config found!"
    exit 1
fi

WAYBAR_WORKSPACE_CONFIG="$HOME/.config/waybar/workspace-config.json"

# Generate the workspace config for Waybar
cat > "$WAYBAR_WORKSPACE_CONFIG" << EOF
{
    "hyprland/workspaces": {
        "active-only": false,
        "all-outputs": false,
        "show-special": false,
        "on-click": "activate",
        "format": "{icon}",
        "on-scroll-up": "hyprctl dispatch workspace m+1",
        "on-scroll-down": "hyprctl dispatch workspace m-1",
        "format-icons": {
            "active": "",
            "default": "",
            "empty": ""
        },
        "persistent-workspaces": {
            "$PRIMARY_MONITOR": [1, 2, 3, 4, 5]$([ -n "$SECONDARY_MONITOR" ] && echo ",
            \"$SECONDARY_MONITOR\": [6, 7, 8, 9, 10]")
        }
    }
}
EOF

echo "✓ Waybar workspace config generated at $WAYBAR_WORKSPACE_CONFIG"

# Restart Waybar to apply changes
pkill -SIGUSR2 waybar 2>/dev/null || (killall waybar 2>/dev/null && waybar &)
