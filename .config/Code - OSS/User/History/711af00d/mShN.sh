#!/bin/bash

# Single instance check
source ~/.config/hypr/scripts/single-instance.sh
single_instance_check "wallpaper-selector"

WALLPAPER_DIR="$HOME/wallpapers/walls"

menu() {
    find "${WALLPAPER_DIR}" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) | awk '{print "img:"$0}'
}

main() {
    choice=$(menu | wofi -c ~/.config/wofi/wallpaper -s ~/.config/wofi/style-wallpaper.css --show dmenu --prompt "Select Wallpaper:" -n)
    
    if [ -z "$choice" ]; then
        exit 0
    fi
    
    selected_wallpaper=$(echo "$choice" | sed 's/^img://')
    
    # Show loading notification
    notify-send "Wallpaper" "Applying $(basename "$selected_wallpaper")..." -i preferences-desktop-wallpaper
    
    # Apply wallpaper with swww
    swww img "$selected_wallpaper" --transition-type any --transition-fps 60 --transition-duration .5
    
    # Generate pywal colors
    wal -i "$selected_wallpaper" -n --cols16
    
    # Reload swaync with new colors
    swaync-client --reload-css
    
    # Update kitty colors
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
    
    # Save current wallpaper
    source ~/.cache/wal/colors.sh && cp -r $wallpaper ~/wallpapers/pywallpaper.jpg 
    
    # Success notification
    notify-send "Wallpaper Applied" "$(basename "$selected_wallpaper")" -i preferences-desktop-wallpaper
}

main