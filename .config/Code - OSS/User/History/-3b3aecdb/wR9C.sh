#!/bin/bash

# Single instance check
source ~/.config/hypr/scripts/single-instance.sh
single_instance_check "waybar-select"

WAYBAR_DIR="$HOME/.config/waybar"
STYLECSS="$WAYBAR_DIR/style.css"
CONFIG="$WAYBAR_DIR/config"
ASSETS="$WAYBAR_DIR/assets"
THEMES="$WAYBAR_DIR/themes"

menu() {
    find "${ASSETS}" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) | awk '{print "img:"$0}'
}

main() {
    choice=$(menu | wofi -c ~/.config/wofi/waybar -s ~/.config/wofi/style-waybar.css --show dmenu --prompt "  Select Waybar (Scroll with Arrows)" -n)
    
    if [ -z "$choice" ]; then
        exit 0
    fi
    
    selected_wallpaper=$(echo "$choice" | sed 's/^img://')
    echo $selected_wallpaper
    
    if [[ "$selected_wallpaper" == "$ASSETS/experimental.png" ]]; then
        cat $THEMES/experimental/style-experimental.css > $STYLECSS
        cat $THEMES/experimental/config-experimental > $CONFIG
        pkill waybar && waybar &
        notify-send "Waybar" "Switched to Experimental theme" -i preferences-desktop
        
    elif [[ "$selected_wallpaper" == "$ASSETS/main.png" ]]; then
        cat $THEMES/default/style-default.css > $STYLECSS
        cat $THEMES/default/config-default > $CONFIG
        pkill waybar && waybar &
        notify-send "Waybar" "Switched to Default theme" -i preferences-desktop
        
    elif [[ "$selected_wallpaper" == "$ASSETS/line.png" ]]; then
        cat $THEMES/line/style-line.css > $STYLECSS
        cat $THEMES/line/config-line > $CONFIG
        pkill waybar && waybar &
        notify-send "Waybar" "Switched to Line theme" -i preferences-desktop
        
    elif [[ "$selected_wallpaper" == "$ASSETS/zen.png" ]]; then
        cat $THEMES/zen/style-zen.css > $STYLECSS
        cat $THEMES/zen/config-zen > $CONFIG
        pkill waybar && waybar &
        notify-send "Waybar" "Switched to Zen theme" -i preferences-desktop
    fi
}

main