#!/bin/bash

# Kill existing Waybar instances
killall waybar 2>/dev/null

# Wait a bit
sleep 0.5

# Load monitor config and generate dynamic workspace config
if [ -f ~/.config/hypr/workspace-monitors.conf ]; then
    source ~/.config/hypr/workspace-monitors.conf
    
    # Generate temporary config with dynamic persistent-workspaces
    TEMP_CONFIG="/tmp/waybar-config-$$.jsonc"
    BASE_CONFIG="$HOME/.config/waybar/config.jsonc"
    
    # Read base config and inject persistent-workspaces
    jq --arg primary "$PRIMARY_MONITOR" \
       --arg secondary "$SECONDARY_MONITOR" \
       '."hyprland/workspaces"."persistent-workspaces" = (
           if $secondary != "" then
               {($primary): [1,2,3,4,5], ($secondary): [6,7,8,9,10]}
           else
               {($primary): [1,2,3,4,5]}
           end
       )' "$BASE_CONFIG" > "$TEMP_CONFIG"
    
    # Launch Waybar with modified config
    waybar -c "$TEMP_CONFIG" &
else
    # Fallback to default config
    waybar &
fi
