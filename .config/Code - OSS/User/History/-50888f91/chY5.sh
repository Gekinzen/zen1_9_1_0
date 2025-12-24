#!/bin/bash

# Load monitor config
if [ -f ~/.config/hypr/workspace-monitors.conf ]; then
    source ~/.config/hypr/workspace-monitors.conf
else
    echo "No workspace config found, using defaults"
    PRIMARY_MONITOR="DP-1"
    SECONDARY_MONITOR=""
fi

KEYBINDS_FILE="$HOME/.config/hypr/workspace-keybinds.conf"

cat > "$KEYBINDS_FILE" << 'EOF'
#############################
### WORKSPACE KEYBINDINGS ###
#############################
# Auto-generated workspace keybindings

######################
### PRIMARY MONITOR (1-8)
######################
bind = $mainMod, 1, workspace, 1
bind = $mainMod, 2, workspace, 2
bind = $mainMod, 3, workspace, 3
bind = $mainMod, 4, workspace, 4
bind = $mainMod, 5, workspace, 5
bind = $mainMod, 6, workspace, 6
bind = $mainMod, 7, workspace, 7
bind = $mainMod, 8, workspace, 8

bind = $mainMod SHIFT, 1, movetoworkspace, 1
bind = $mainMod SHIFT, 2, movetoworkspace, 2
bind = $mainMod SHIFT, 3, movetoworkspace, 3
bind = $mainMod SHIFT, 4, movetoworkspace, 4
bind = $mainMod SHIFT, 5, movetoworkspace, 5
bind = $mainMod SHIFT, 6, movetoworkspace, 6
bind = $mainMod SHIFT, 7, movetoworkspace, 7
bind = $mainMod SHIFT, 8, movetoworkspace, 8
EOF

# Add secondary monitor keybinds if it exists
if [ -n "$SECONDARY_MONITOR" ]; then
    cat >> "$KEYBINDS_FILE" << 'EOF'

######################
### SECONDARY MONITOR (11-14)
######################
# Mapped to keys: 9, 0, -, =
bind = $mainMod, 9, workspace, 11
bind = $mainMod, 0, workspace, 12
bind = $mainMod, minus, workspace, 13
bind = $mainMod, equal, workspace, 14

bind = $mainMod SHIFT, 9, movetoworkspace, 11
bind = $mainMod SHIFT, 0, movetoworkspace, 12
bind = $mainMod SHIFT, minus, movetoworkspace, 13
bind = $mainMod SHIFT, equal, movetoworkspace, 14
EOF
fi

cat >> "$KEYBINDS_FILE" << 'EOF'

######################
### WORKSPACE NAVIGATION
######################
# Cycle through workspaces on current monitor
bind = $mainMod, mouse_down, workspace, m+1
bind = $mainMod, mouse_up, workspace, m-1

# Move to next/prev workspace
bind = $mainMod CTRL, right, workspace, m+1
bind = $mainMod CTRL, left, workspace, m-1

# Move window to next/prev workspace
bind = $mainMod CTRL SHIFT, right, movetoworkspace, m+1
bind = $mainMod CTRL SHIFT, left, movetoworkspace, m-1

# Focus monitor
bind = $mainMod, period, focusmonitor, +1
bind = $mainMod, comma, focusmonitor, -1

# Move workspace to other monitor
bind = $mainMod SHIFT, period, movecurrentworkspacetomonitor, +1
bind = $mainMod SHIFT, comma, movecurrentworkspacetomonitor, -1

# Cleanup empty workspaces
bind = $mainMod SHIFT, X, exec, ~/.config/hypr/scripts/remove-empty-workspaces.sh
EOF

echo "✓ Keybindings generated at $KEYBINDS_FILE"