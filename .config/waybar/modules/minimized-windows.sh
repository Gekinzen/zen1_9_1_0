#!/bin/bash

# Count minimized windows
COUNT=$(hyprctl clients -j | jq '[.[] | select(.workspace.name == "special:minimized")] | length')

if [ "$COUNT" -gt 0 ]; then
    echo "{\"text\": \"󰖰 $COUNT\", \"tooltip\": \"$COUNT minimized windows\", \"class\": \"minimized\"}"
else
    echo "{\"text\": \"\", \"tooltip\": \"No minimized windows\", \"class\": \"empty\"}"
fi
