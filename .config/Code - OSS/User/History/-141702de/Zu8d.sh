#!/bin/bash
# Detect monitors and setup workspaces
echo "Setting up workspaces per monitor..."

# Get monitor information
MONITORS=$(hyprctl monitors -j | jq -r '.[].name')
MONITOR_COUNT=$(echo "$MONITORS" | wc -l)

echo "Detected $MONITOR_COUNT monitors:"
echo "$MONITORS"

# Get primary and secondary monitors
PRIMARY=$(hyprctl monitors -j | jq -r '.[0].name')
SECONDARY=$(hyprctl monitors -j | jq -r '.[1].name // empty')

echo "Primary: $PRIMARY"
echo "Secondary: $SECONDARY"

# Save to config
CONFIG_FILE="$HOME/.config/hypr/workspace-monitors.conf"
cat > "$CONFIG_FILE" << EOF
# Auto-generated workspace monitor mapping
# Generated on: $(date)
PRIMARY_MONITOR=$PRIMARY
SECONDARY_MONITOR=$SECONDARY
MONITOR_COUNT=$MONITOR_COUNT
EOF

echo "✓ Workspace config saved"

# Generate workspace rules
RULES_FILE="$HOME/.config/hypr/workspace-rules.conf"
cat > "$RULES_FILE" << EOF
#############################
### WORKSPACE MONITOR RULES ###
#############################
# Auto-generated workspace rules
# Primary: $PRIMARY (workspaces 1-5)
# Secondary: $SECONDARY (workspaces 6-10)

# Bind workspaces to monitors
workspace = 1, monitor:$PRIMARY, default:true
workspace = 2, monitor:$PRIMARY
workspace = 3, monitor:$PRIMARY
workspace = 4, monitor:$PRIMARY
workspace = 5, monitor:$PRIMARY
EOF

if [ -n "$SECONDARY" ]; then
cat >> "$RULES_FILE" << EOF

workspace = 6, monitor:$SECONDARY, default:true
workspace = 7, monitor:$SECONDARY
workspace = 8, monitor:$SECONDARY
workspace = 9, monitor:$SECONDARY
workspace = 10, monitor:$SECONDARY
EOF
fi

echo "✓ Workspace rules generated at $RULES_FILE"

# Move existing windows to correct workspaces
echo "Moving existing workspaces to correct monitors..."
hyprctl dispatch moveworkspacetomonitor 1 $PRIMARY 2>/dev/null
hyprctl dispatch moveworkspacetomonitor 2 $PRIMARY 2>/dev/null
hyprctl dispatch moveworkspacetomonitor 3 $PRIMARY 2>/dev/null
hyprctl dispatch moveworkspacetomonitor 4 $PRIMARY 2>/dev/null
hyprctl dispatch moveworkspacetomonitor 5 $PRIMARY 2>/dev/null

if [ -n "$SECONDARY" ]; then
    hyprctl dispatch moveworkspacetomonitor 6 $SECONDARY 2>/dev/null
    hyprctl dispatch moveworkspacetomonitor 7 $SECONDARY 2>/dev/null
    hyprctl dispatch moveworkspacetomonitor 8 $SECONDARY 2>/dev/null
    hyprctl dispatch moveworkspacetomonitor 9 $SECONDARY 2>/dev/null
    hyprctl dispatch moveworkspacetomonitor 10 $SECONDARY 2>/dev/null
fi

# Generate Waybar workspace config
~/.config/hypr/scripts/generate-waybar-workspaces.sh

notify-send "󰍹 Workspaces" "Configured for $MONITOR_COUNT monitors" -t 2000