#!/bin/bash
# SINGLE INSTANCE CHECK - Direct implementation
LOCK_FILE="/tmp/wallpaper-selector.lock"
if [ -f "$LOCK_FILE" ]; then
    PID=$(cat "$LOCK_FILE")
    if ps -p "$PID" > /dev/null 2>&1; then
        echo "Wallpaper selector already running - closing..."
        kill "$PID" 2>/dev/null
        rm -f "$LOCK_FILE"
        pkill -f "wofi.*wallpaper"
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

main() {
    choice=$(menu | wofi -c ~/.config/wofi/wallpaper -s ~/.config/wofi/style-wallpaper.css --show dmenu --prompt "Select Wallpaper:" -n)
    
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
    
    # === ADD THIS: UPDATE SDDM THEME ===
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