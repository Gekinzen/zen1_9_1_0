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
# Primary: $PRIMARY (workspaces 1-8)
# Secondary: $SECONDARY (workspaces 11-14)

# Bind workspaces to monitors
workspace = 1, monitor:$PRIMARY, default:true
workspace = 2, monitor:$PRIMARY
workspace = 3, monitor:$PRIMARY
workspace = 4, monitor:$PRIMARY
workspace = 5, monitor:$PRIMARY
workspace = 6, monitor:$PRIMARY
workspace = 7, monitor:$PRIMARY
workspace = 8, monitor:$PRIMARY
EOF

if [ -n "$SECONDARY" ]; then
    cat >> "$RULES_FILE" << EOF

workspace = 11, monitor:$SECONDARY, default:true
workspace = 12, monitor:$SECONDARY
workspace = 13, monitor:$SECONDARY
workspace = 14, monitor:$SECONDARY
EOF
fi

echo "✓ Workspace rules generated at $RULES_FILE"
notify-send "󰍹 Workspaces" "Configured for $MONITOR_COUNT monitors" -t 2000