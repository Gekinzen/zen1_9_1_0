#!/bin/bash

CONFIG_FILE="$HOME/.config/hypr/hyperbars.conf"
HYPR_CONFIG="$HOME/.config/hypr/hyprland.conf"

# Create config if doesn't exist
if [ ! -f "$CONFIG_FILE" ]; then
    cat > "$CONFIG_FILE" << 'EOF'
HYPERBARS_ENABLED=true
BAR_HEIGHT=32
BAR_TITLE_ENABLED=true
BUTTON_SIZE=15
EOF
fi

source "$CONFIG_FILE"

# Function to toggle hyperbars
toggle_hyperbars() {
    if [ "$HYPERBARS_ENABLED" = "true" ]; then
        # Disable
        sed -i 's/HYPERBARS_ENABLED=.*/HYPERBARS_ENABLED=false/' "$CONFIG_FILE"
        hyprpm disable hyprbars
        notify-send "󰖲 Hyprbars" "Disabled" -i window-close
    else
        # Enable
        sed -i 's/HYPERBARS_ENABLED=.*/HYPERBARS_ENABLED=true/' "$CONFIG_FILE"
        hyprpm enable hyprbars
        notify-send "󰖲 Hyprbars" "Enabled" -i window-new
    fi
    
    # Reload Hyprland
    hyprctl reload
}

# Function to toggle title bar
toggle_title() {
    if [ "$BAR_TITLE_ENABLED" = "true" ]; then
        sed -i 's/BAR_TITLE_ENABLED=.*/BAR_TITLE_ENABLED=false/' "$CONFIG_FILE"
        sed -i 's/bar_text_enabled = true/bar_text_enabled = false/' "$HYPR_CONFIG"
        notify-send "󰖲 Title Bar" "Title hidden" -i window
    else
        sed -i 's/BAR_TITLE_ENABLED=.*/BAR_TITLE_ENABLED=true/' "$CONFIG_FILE"
        sed -i 's/bar_text_enabled = false/bar_text_enabled = true/' "$HYPR_CONFIG"
        notify-send "󰖲 Title Bar" "Title visible" -i window
    fi
    hyprctl reload
}

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


# Function to change bar height
change_height() {
    HEIGHT=$1
    sed -i "s/bar_height = .*/bar_height = $HEIGHT/" "$HYPR_CONFIG"
    sed -i "s/BAR_HEIGHT=.*/BAR_HEIGHT=$HEIGHT/" "$CONFIG_FILE"
    notify-send "󰘖 Hyprbars" "Bar height set to ${HEIGHT}px" -i preferences-desktop
    hyprctl reload
}

# Function to check status
check_status() {
    if hyprpm list | grep -q "enabled.*hyprbars"; then
        echo "󰄬 Enabled"
    else
        echo "󰅙 Disabled"
    fi
}

# Handle commands
case "$1" in
    toggle) toggle_hyperbars ;;
    title) toggle_title ;;
    colors) update_colors ;;
    height) change_height "$2" ;;
    status) check_status ;;
    *) toggle_hyperbars ;;
esac