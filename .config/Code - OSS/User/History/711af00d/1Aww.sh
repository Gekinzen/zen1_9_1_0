#!/bin/bash
# SINGLE INSTANCE CHECK
LOCK_FILE="/tmp/wallpaper-selector.lock"
if [ -f "$LOCK_FILE" ]; then
    PID=$(cat "$LOCK_FILE")
    if ps -p "$PID" > /dev/null 2>&1; then
        echo "Wallpaper selector already running - closing..."
        kill "$PID" 2>/dev/null
        rm -f "$LOCK_FILE"
        pkill -9 wofi
        exit 0
    else
        rm -f "$LOCK_FILE"
    fi
fi

echo $$ > "$LOCK_FILE"
trap "rm -f $LOCK_FILE" EXIT

WALLPAPER_DIR="$HOME/wallpapers/walls"

menu() {
    find "${WALLPAPER_DIR}" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) | awk '{print "img:"$0}'
}

# Function to ensure waybar is clickable
fix_waybar_input() {
    # Method 1: Send dummy mouse move to reset input
    hyprctl dispatch movecursor 0 0
    hyprctl dispatch movecursor 0 -0
    
    # Method 2: Toggle a harmless setting to refresh input handling
    local current_follow=$(hyprctl getoption input:follow_mouse -j | jq -r '.int')
    hyprctl keyword input:follow_mouse $current_follow
}

main() {
    choice=$(menu | wofi -c ~/.config/wofi/wallpaper -s ~/.config/wofi/style-wallpaper.css --show dmenu --prompt "Select Wallpaper:" -n)
    
    # Aggressively kill wofi
    pkill -9 wofi 2>/dev/null
    sleep 0.2
    
    # Fix waybar input immediately
    fix_waybar_input
    
    if [ -z "$choice" ]; then
        rm -f "$LOCK_FILE"
        exit 0
    fi
    
    selected_wallpaper=$(echo "$choice" | sed 's/^img://')
    
    notify-send "Wallpaper" "Applying $(basename "$selected_wallpaper")..." -i preferences-desktop-wallpaper
    
    # Apply wallpaper with swww
    swww img "$selected_wallpaper" --transition-type any --transition-fps 60 --transition-duration .5
    
    # Generate pywal colors
    wal -i "$selected_wallpaper" -n --cols16
    
    # Generate rofi colors from pywal
    source ~/.cache/wal/colors.sh
    cat > ~/.cache/wal/colors-rofi-dark.rasi << EOF
* {
    background:     ${background};
    background-alt: ${color0};
    foreground:     ${foreground};
    selected:       ${color12};
    active:         ${color10};
    urgent:         ${color9};
    color0:         ${color0};
    color12:        ${color12};
}
EOF
    
    # Update hyprbars glass effect
    if [ -f ~/.config/hypr/scripts/update-hyprbars-glass.sh ]; then
        ~/.config/hypr/scripts/update-hyprbars-glass.sh
    fi
    
    # Reload dock with new colors
    if [ -f ~/.config/hypr/scripts/dock-manager.sh ]; then
        echo "Refreshing nwg-dock-hyprland colors..."
        pkill -f nwg-dock-hyprland 2>/dev/null
        sleep 0.3
        
        layout=$(hyprctl getoption general:layout | grep -oE '(dwindle|master|float)' | head -n1)
        if [[ "$layout" == "float" ]]; then
            ~/.config/hypr/scripts/dock-manager.sh float &
        else
            ~/.config/hypr/scripts/dock-manager.sh tiling &
        fi
    fi
    
    # Restart waybar with new colors
    pkill waybar 2>/dev/null
    sleep 0.3
    waybar &
    sleep 0.5
    
    # Fix waybar input after restart
    fix_waybar_input
    
    # Reload swaync CSS
    swaync-client --reload-css
    
    # Update kitty theme
    cat ~/.cache/wal/colors-kitty.conf > ~/.config/kitty/current-theme.conf
    
    # Update pywalfox
    pywalfox update 2>/dev/null
    
    # Update cava colors
    color1=$(awk 'match($0, /color2=\47(.*)\47/,a) { print a[1] }' ~/.cache/wal/colors.sh)
    color2=$(awk 'match($0, /color3=\47(.*)\47/,a) { print a[1] }' ~/.cache/wal/colors.sh)
    cava_config="$HOME/.config/cava/config"
    sed -i "s/^gradient_color_1 = .*/gradient_color_1 = '$color1'/" $cava_config
    sed -i "s/^gradient_color_2 = .*/gradient_color_2 = '$color2'/" $cava_config
    pkill -USR2 cava 2>/dev/null
    
    # Copy wallpaper to pywallpaper
    source ~/.cache/wal/colors.sh && cp -r $wallpaper ~/wallpapers/pywallpaper.jpg
    
    # Update SDDM login screen with new wallpaper and colors
    if [ -f ~/.config/hypr/scripts/sddm-pywal-sync.sh ]; then
        ~/.config/hypr/scripts/sddm-pywal-sync.sh &
    fi
    
    # Update Rofi theme with new colors
    if [ -f ~/.config/hypr/scripts/rofi-pywal-sync.sh ]; then
        ~/.config/hypr/scripts/rofi-pywal-sync.sh &
    fi
    
    notify-send "Wallpaper Applied" "$(basename "$selected_wallpaper")" -i preferences-desktop-wallpaper
}

main
rm -f "$LOCK_FILE"