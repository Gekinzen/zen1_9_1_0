#!/bin/bash
# ───────────────────────────────────────────────────────────────
# Wallpaper Selector + Dynamic Theming Script for Hyprland
# by paul 🖼️
# ───────────────────────────────────────────────────────────────

LOCK_FILE="/tmp/wallpaper-selector.lock"
WALLPAPER_DIR="$HOME/wallpapers/walls"

# ── SINGLE INSTANCE CHECK ──────────────────────────────────────
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

# ── WALLPAPER MENU FUNCTION ────────────────────────────────────
menu() {
    if [ ! -d "$WALLPAPER_DIR" ]; then
        notify-send "Error" "Wallpaper directory not found: $WALLPAPER_DIR"
        exit 1
    fi
    find "${WALLPAPER_DIR}" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) \
        | awk '{print "img:"$0}'
}

# ── FIX WAYBAR INPUT BUG ───────────────────────────────────────
fix_waybar_input() {
    hyprctl dispatch movecursor 0 0
    hyprctl dispatch movecursor 0 -0

    local current_follow
    current_follow=$(hyprctl getoption input:follow_mouse -j | jq -r '.int')
    hyprctl keyword input:follow_mouse "$current_follow" >/dev/null 2>&1
}

# ── MAIN LOGIC ─────────────────────────────────────────────────
main() {
    choice=$(menu | wofi -c ~/.config/wofi/wallpaper -s ~/.config/wofi/style-wallpaper.css \
        --show dmenu --prompt "Select Wallpaper:" -n)

    pkill -9 wofi 2>/dev/null
    sleep 0.2
    fix_waybar_input

    [ -z "$choice" ] && exit 0

    selected_wallpaper=$(echo "$choice" | sed 's/^img://')
    [ ! -f "$selected_wallpaper" ] && {
        notify-send "Error" "Selected wallpaper not found!"
        exit 1
    }

    notify-send "Wallpaper" "Applying $(basename "$selected_wallpaper")..." -i preferences-desktop-wallpaper

    # ── Apply wallpaper via swww
    swww img "$selected_wallpaper" --transition-type any --transition-fps 60 --transition-duration .5

    # ── Pywal colors
    wal -i "$selected_wallpaper" -n --cols16
    source ~/.cache/wal/colors.sh

    # ── Rofi color theme
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

    # ── Update Hyprbars Glass (if exists)
    [ -x ~/.config/hypr/scripts/update-hyprbars-glass.sh ] && \
        ~/.config/hypr/scripts/update-hyprbars-glass.sh


    # ── Restart Waybar
    pkill waybar 2>/dev/null
    sleep 0.3
    waybar &
    sleep 0.5
    fix_waybar_input

    # ── Reload swaync CSS
    swaync-client --reload-css 2>/dev/null

    # ── Update Kitty
    cat ~/.cache/wal/colors-kitty.conf > ~/.config/kitty/current-theme.conf 2>/dev/null

    # ── Pywalfox Update
    pywalfox update 2>/dev/null


# 3. Finally reload dock LAST
if [ -x ~/.config/hypr/scripts/dock-launcher.sh ]; then
    echo "Reloading nwg-dock-hyprland..."

        # Launch fresh dock with new colors
        ~/.config/hypr/scripts/dock-launcher.sh
        
fi


    # ── Cava color update
    color1=$(awk 'match($0, /color2=\47(.*)\47/,a) { print a[1] }' ~/.cache/wal/colors.sh)
    color2=$(awk 'match($0, /color3=\47(.*)\47/,a) { print a[1] }' ~/.cache/wal/colors.sh)
    cava_config="$HOME/.config/cava/config"
    sed -i "s/^gradient_color_1 = .*/gradient_color_1 = '$color1'/" $cava_config
    sed -i "s/^gradient_color_2 = .*/gradient_color_2 = '$color2'/" $cava_config
    pkill -USR2 cava 2>/dev/null

    # ── Copy wallpaper to pywallpaper
    cp -f "$selected_wallpaper" ~/wallpapers/pywallpaper.jpg 2>/dev/null

    # ── Update SDDM and Rofi themes if scripts exist
    [ -x ~/.config/hypr/scripts/sddm-pywal-sync.sh ] && ~/.config/hypr/scripts/sddm-pywal-sync.sh &
    [ -x ~/.config/hypr/scripts/rofi-pywal-sync.sh ] && ~/.config/hypr/scripts/rofi-pywal-sync.sh &

    notify-send "Wallpaper Applied" "$(basename "$selected_wallpaper")" -i preferences-desktop-wallpaper
}

main
rm -f "$LOCK_FILE"
