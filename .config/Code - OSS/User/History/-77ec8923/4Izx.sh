#!/bin/bash

CONFIG_FILE="$HOME/.config/hypr/hyperbars.conf"
HYPR_CONFIG="$HOME/.config/hypr/hyprland.conf"

# ... (keep existing functions)

# Function to update colors from pywal
update_colors() {
    source ~/.cache/wal/colors.sh
    
    echo "Updating hyprbars colors..."
    echo "Background: $background"
    echo "Foreground: $foreground"
    
    # Remove # from colors
    BG_COLOR="${background#\#}"
    FG_COLOR="${foreground#\#}"
    
    # Update bar_color in hyprland.conf
    sed -i "s/bar_color = rgb([^)]*)/bar_color = rgb($BG_COLOR)/" "$HYPR_CONFIG"
    
    # Update col.text in hyprland.conf
    sed -i "s/col\.text = rgb([^)]*)/col.text = rgb($FG_COLOR)/" "$HYPR_CONFIG"
    
    echo "Colors updated in config"
    
    # Reload to apply
    hyprctl reload
    
    notify-send "󰚰 Hyprbars" "Colors updated from pywal\nBackground: #$BG_COLOR\nText: #$FG_COLOR" -t 3000 -i preferences-desktop-theme
}

# ... (rest of script)