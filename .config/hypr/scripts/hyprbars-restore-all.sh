#!/bin/bash

# Get all windows in special:minimized
ADDRESSES=$(hyprctl clients -j | jq -r '.[] | select(.workspace.name == "special:minimized") | .address')

if [ -z "$ADDRESSES" ]; then
    notify-send "󰖰 Minimized Windows" "No minimized windows" -i window
    exit 0
fi

# Move all windows back to current workspace
CURRENT_WS=$(hyprctl activeworkspace -j | jq -r '.id')

while IFS= read -r address; do
    hyprctl dispatch movetoworkspace "$CURRENT_WS,address:$address"
done <<< "$ADDRESSES"

notify-send "󰖰 Minimized Windows" "Restored all windows" -i window
