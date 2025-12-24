#!/bin/bash

# Update rofi wallpaper before starting
~/.config/hypr/scripts/update-rofi-wallpaper.sh 2>/dev/null

# Get wallpaper name only (short)
get_wallpaper_name() {
    if [ -f ~/.cache/wal/wal ]; then
        basename "$(cat ~/.cache/wal/wal)"
    elif [ -f ~/wallpapers/pywallpaper.jpg ]; then
        echo "pywallpaper.jpg"
    else
        echo "No wallpaper"
    fi
}

# SINGLE INSTANCE CHECK
LOCK_FILE="/tmp/system-settings.lock"
if [ -f "$LOCK_FILE" ]; then
    PID=$(cat "$LOCK_FILE")
    if ps -p "$PID" > /dev/null 2>&1; then
        kill "$PID" 2>/dev/null
        rm -f "$LOCK_FILE"
        pkill -x rofi
        exit 0
    else
        rm -f "$LOCK_FILE"
    fi
fi
echo $$ > "$LOCK_FILE"
trap "rm -f $LOCK_FILE" EXIT

sleep 0.1

WALLPAPER_NAME=$(get_wallpaper_name)

# Main menu - SHORT description
show_main_menu() {
    local DESC="━━━━━━━━━━━━━━━━━
󰸉 $(get_wallpaper_name)
━━━━━━━━━━━━━━━━━

SYSTEM SETTINGS

Configure appearance,
desktop, and system
options"

    CHOICE=$(echo -e "󰏘 Appearance\n󰒓 System\n󰍹 Desktop\n󰌌 Keybindings\n󰅖 Close" | \
        rofi -dmenu -i \
        -p "󰒓 Settings" \
        -mesg "$DESC" \
        -theme ~/.config/rofi/system-settings-v3.rasi)
    
    case "$CHOICE" in
        *"Appearance"*) show_appearance_menu ;;
        *"System"*) show_system_menu ;;
        *"Desktop"*) show_desktop_menu ;;
        *"Keybindings"*)
            ~/.config/hypr/scripts/keybinding-viewer-interactive.sh
            show_main_menu
            ;;
        *"Close"*|"") rm -f "$LOCK_FILE"; exit 0 ;;
    esac
}

# Appearance menu
show_appearance_menu() {
    local DESC="━━━━━━━━━━━━━━━━━
󰏘 APPEARANCE
━━━━━━━━━━━━━━━━━

Customize visual
appearance:

- Window transparency
- Title bar decorations
- Color schemes
- Theme settings"

    CHOICE=$(echo -e "󰖲 Window Opacity\n󰖲 Window Decorations\n󰚰 Reload Colors\n󰐥 Wlogout Theme\n󰁍 Back" | \
        rofi -dmenu -i \
        -p "󰏘 Appearance" \
        -mesg "$DESC" \
        -theme ~/.config/rofi/system-settings-v3.rasi)
    
    case "$CHOICE" in
        *"Opacity"*)
            ~/.config/hypr/scripts/opacity-settings.sh
            show_appearance_menu
            ;;
        *"Decorations"*) show_decorations_menu ;;
        *"Reload"*)
            wal -R
            ~/.config/hypr/scripts/update-rofi-wallpaper.sh 2>/dev/null
            ~/.config/hypr/scripts/hyprbars-manager.sh colors 2>/dev/null
            notify-send "󰚰 Pywal" "Colors reloaded"
            show_appearance_menu
            ;;
        *"Wlogout"*)
            ~/.config/wlogout/toggle-wallpaper.sh 2>/dev/null
            show_appearance_menu
            ;;
        *"Back"*|"") show_main_menu ;;
    esac
}

# Window decorations
show_decorations_menu() {
    if [ -f ~/.config/hypr/hyperbars.conf ]; then
        source ~/.config/hypr/hyperbars.conf
    else
        HYPERBARS_ENABLED=true
        BAR_HEIGHT=38
        GLASS_ENABLED=true
    fi
    
    MIN_COUNT=$(hyprctl clients -j 2>/dev/null | jq '[.[] | select(.workspace.name == "special:minimized")] | length' 2>/dev/null || echo "0")
    
    [ "$HYPERBARS_ENABLED" = "true" ] && BAR_STATUS="ON" || BAR_STATUS="OFF"
    [ "$GLASS_ENABLED" = "true" ] && GLASS_STATUS="ON" || GLASS_STATUS="OFF"
    
    local DESC="━━━━━━━━━━━━━━━━━
󰖲 DECORATIONS
━━━━━━━━━━━━━━━━━

Title Bars: $BAR_STATUS
Glass: $GLASS_STATUS
Height: ${BAR_HEIGHT}px
Minimized: $MIN_COUNT

macOS-style window
title bars with glass
blur effects"

    CHOICE=$(echo -e "󰄬 Toggle Bars\n󰔄 Toggle Glass\n󰘖 Bar Height\n󰖰 Minimized\n󰚰 Update Colors\n󰁍 Back" | \
        rofi -dmenu -i \
        -p "󰖲 Decorations" \
        -mesg "$DESC" \
        -theme ~/.config/rofi/system-settings-v3.rasi)
    
    case "$CHOICE" in
        *"Toggle Bars"*)
            ~/.config/hypr/scripts/hyprbars-manager.sh toggle
            show_decorations_menu
            ;;
        *"Toggle Glass"*)
            ~/.config/hypr/scripts/hyprbars-glass-toggle.sh
            show_decorations_menu
            ;;
        *"Bar Height"*) show_bar_height_menu ;;
        *"Minimized"*) 
            ~/.config/hypr/scripts/hyprbars-restore-menu.sh
            show_decorations_menu
            ;;
        *"Update Colors"*)
            ~/.config/hypr/scripts/update-hyprbars-glass.sh
            show_decorations_menu
            ;;
        *"Back"*|"") show_appearance_menu ;;
    esac
}

# Bar height
show_bar_height_menu() {
    local DESC="━━━━━━━━━━━━━━━━━
󰘖 BAR HEIGHT
━━━━━━━━━━━━━━━━━

Choose title bar size:

24px - Compact
28px - Small
32px - Standard
36px - Large
40px - Extra Large"

    CHOICE=$(echo -e "󰘖 Compact (24px)\n󰘖 Small (28px)\n󰘖 Standard (32px)\n󰘖 Large (36px)\n󰘖 Extra Large (40px)\n󰁍 Back" | \
        rofi -dmenu -i \
        -p "󰘖 Height" \
        -mesg "$DESC" \
        -theme ~/.config/rofi/system-settings-v3.rasi)
    
    case "$CHOICE" in
        *"Compact"*) ~/.config/hypr/scripts/hyprbars-manager.sh height 24 ;;
        *"Small"*) ~/.config/hypr/scripts/hyprbars-manager.sh height 28 ;;
        *"Standard"*) ~/.config/hypr/scripts/hyprbars-manager.sh height 32 ;;
        *"Large"*) ~/.config/hypr/scripts/hyprbars-manager.sh height 36 ;;
        *"Extra Large"*) ~/.config/hypr/scripts/hyprbars-manager.sh height 40 ;;
    esac
    show_decorations_menu
}

# System menu
show_system_menu() {
    pgrep -x "nwg-dock-hypr" > /dev/null && DOCK_STATUS="ON" || DOCK_STATUS="OFF"
    
    local DESC="━━━━━━━━━━━━━━━━━
󰒓 SYSTEM
━━━━━━━━━━━━━━━━━

Dock: $DOCK_STATUS

macOS-style application
dock with auto-hide and
pinned apps"

    CHOICE=$(echo -e "󰘔 Toggle Dock\n󰒓 Dock Settings\n󰁍 Back" | \
        rofi -dmenu -i \
        -p "󰒓 System" \
        -mesg "$DESC" \
        -theme ~/.config/rofi/system-settings-v3.rasi)
    
    case "$CHOICE" in
        *"Toggle"*)
            ~/.config/hypr/scripts/dock-manager.sh toggle 2>/dev/null
            show_system_menu
            ;;
        *"Settings"*) show_dock_settings ;;
        *"Back"*|"") show_main_menu ;;
    esac
}

# Dock settings
show_dock_settings() {
    if [ -f ~/.config/nwg-dock-hyprland/dock.conf ]; then
        source ~/.config/nwg-dock-hyprland/dock.conf
    else
        AUTO_HIDE=true
    fi
    
    [ "$AUTO_HIDE" = "true" ] && HIDE_STATUS="ON" || HIDE_STATUS="OFF"
    
    local DESC="━━━━━━━━━━━━━━━━━
󰘔 DOCK
━━━━━━━━━━━━━━━━━

Auto-hide: $HIDE_STATUS

Configure dock behavior,
position, and pinned
applications"

    CHOICE=$(echo -e "󰔄 Toggle Auto-hide\n󰐃 Pinned Apps\n󰹏 Position\n󰁍 Back" | \
        rofi -dmenu -i \
        -p "󰘔 Dock" \
        -mesg "$DESC" \
        -theme ~/.config/rofi/system-settings-v3.rasi)
    
    case "$CHOICE" in
        *"Toggle"*)
            ~/.config/hypr/scripts/dock-manager.sh autohide 2>/dev/null
            show_dock_settings
            ;;
        *"Pinned"*)
            thunar ~/.config/nwg-dock-hyprland/
            show_dock_settings
            ;;
        *"Position"*) show_dock_position ;;
        *"Back"*|"") show_system_menu ;;
    esac
}

# Dock position
show_dock_position() {
    local DESC="━━━━━━━━━━━━━━━━━
󰹏 POSITION
━━━━━━━━━━━━━━━━━

Select dock placement:

󰁅 Bottom (default)
󰁝 Top
󰁍 Left (vertical)
󰁔 Right (vertical)"

    CHOICE=$(echo -e "󰁅 Bottom\n󰁝 Top\n󰁍 Left\n󰁔 Right\n󰁍 Back" | \
        rofi -dmenu -i \
        -p "󰹏 Position" \
        -mesg "$DESC" \
        -theme ~/.config/rofi/system-settings-v3.rasi)
    
    case "$CHOICE" in
        *"Bottom"*|*"Top"*|*"Left"*|*"Right"*)
            POS=$(echo "$CHOICE" | sed 's/[^ ]* //' | tr '[:upper:]' '[:lower:]')
            sed -i "s/\"position\": \".*\"/\"position\": \"${POS}\"/" ~/.config/nwg-dock-hyprland/config 2>/dev/null
            ~/.config/hypr/scripts/dock-manager.sh toggle 2>/dev/null
            sleep 0.3
            ~/.config/hypr/scripts/dock-manager.sh toggle 2>/dev/null
            ;;
    esac
    show_dock_settings
}

# Desktop menu
show_desktop_menu() {
    local DESC="━━━━━━━━━━━━━━━━━
󰍹 DESKTOP
━━━━━━━━━━━━━━━━━

Personalize desktop:

- Wallpapers
- Waybar themes
- Notifications

Auto-generates colors
from wallpaper"

    CHOICE=$(echo -e "󰸉 Wallpaper\n󱂬 Waybar Style\n󰂚 Notifications\n󰁍 Back" | \
        rofi -dmenu -i \
        -p "󰍹 Desktop" \
        -mesg "$DESC" \
        -theme ~/.config/rofi/system-settings-v3.rasi)
    
    case "$CHOICE" in
        *"Wallpaper"*)
            ~/.config/hypr/wallpaper.sh
            ~/.config/hypr/scripts/update-rofi-wallpaper.sh 2>/dev/null
            show_desktop_menu
            ;;
        *"Waybar"*)
            ~/.config/waybar/scripts/select.sh 2>/dev/null
            show_desktop_menu
            ;;
        *"Notifications"*)
            swaync-client -t
            show_desktop_menu
            ;;
        *"Back"*|"") show_main_menu ;;
    esac
}

# Start
show_main_menu
rm -f "$LOCK_FILE"