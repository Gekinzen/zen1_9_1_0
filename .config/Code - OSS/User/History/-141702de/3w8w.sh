#!/bin/bash
# Detect monitors and setup workspaces
echo "Setting up dynamic workspaces per monitor..."

# Configuration
WORKSPACES_PER_MONITOR=10  # Change this if you want more/less

# Get monitor information
MONITORS=$(hyprctl monitors -j | jq -r '.[].name')
MONITOR_COUNT=$(echo "$MONITORS" | wc -l)

echo "Detected $MONITOR_COUNT monitors:"
echo "$MONITORS"

# Save to config
CONFIG_FILE="$HOME/.config/hypr/workspace-monitors.conf"
cat > "$CONFIG_FILE" << EOF
# Auto-generated workspace monitor mapping
# Generated on: $(date)
MONITOR_COUNT=$MONITOR_COUNT
WORKSPACES_PER_MONITOR=$WORKSPACES_PER_MONITOR
MONITORS="$MONITORS"
EOF

echo "✓ Workspace config saved"

# Generate workspace rules - NO fixed monitor assignment!
RULES_FILE="$HOME/.config/hypr/workspace-rules.conf"
cat > "$RULES_FILE" << EOF
#############################
### WORKSPACE MONITOR RULES ###
#############################
# Auto-generated dynamic workspace rules
# Each monitor gets workspaces 1-$WORKSPACES_PER_MONITOR dynamically

# Dynamic workspace behavior
# Workspaces will automatically assign to whatever monitor they're created on
EOF

# Add workspace defaults (but no specific monitor binding!)
for i in $(seq 1 $WORKSPACES_PER_MONITOR); do
    echo "workspace = $i" >> "$RULES_FILE"
done

echo "✓ Workspace rules generated at $RULES_FILE"

notify-send "󰍹 Workspaces" "Dynamic workspaces for $MONITOR_COUNT monitors" -t 2000