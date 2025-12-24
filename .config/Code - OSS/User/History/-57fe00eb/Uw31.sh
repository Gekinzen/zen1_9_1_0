#!/bin/bash

# Single instance check
LOCK_FILE="/tmp/system-settings.lock"
if [ -f "$LOCK_FILE" ]; then
    PID=$(cat "$LOCK_FILE")
    if ps -p "$PID" > /dev/null 2>&1; then
        kill "$PID" 2>/dev/null
        rm -f "$LOCK_FILE"
        pkill -f "rofi.*System Settings Alpha v1.1.2"
        exit 0
    fi
fi
echo $$ > "$LOCK_FILE"
trap "rm -f $LOCK_FILE" EXIT

# Main menu with Material Symbols
show_main_menu() {
    CHOICE=$(echo -e " Appearance\n Settings\n Desktop\n Keybindings\n Close" | \
        rofi -dmenu -i \
        -p " System Settings Alpha v1.1.2" \
        -theme ~/.config/rofi/system-settings.rasi)
    
    case "$CHOICE" in
        " Appearance") show_appearance_menu ;;
        " Settings") show_system_menu ;;
        " Desktop") show_desktop_menu ;;
        " Keybindings")
            ~/.config/hypr/scripts/keybinding-viewer-interactive.sh
            show_main_menu
            ;;
        " Close"|"") rm -f "$LOCK_FILE"; exit 0 ;;
    esac
}

# Appearance submenu
show_appearance_menu() {
    CHOICE=$(echo -e " Window Opacity\n Window Decorations\n Reload Colors\n Wlogout Theme\n Back" | \
        rofi -dmenu -i -p " Appearance" -theme ~/.config/rofi/system-settings.rasi)
    
    case "$CHOICE" in
        " Window Opacity")
            ~/.config/hypr/scripts/opacity-settings.sh
            show_appearance_menu
            ;;
        " Window Decorations") show_decorations_menu ;;
        " Reload Colors")
            wal -R
            ~/.config/hypr/scripts/hyprbars-manager.sh colors 2>/dev/null
            ~/.config/hypr/scripts/setup-icons.sh
            notify-send " Pywal" "Colors reloaded" -i preferences-desktop-theme
            show_appearance_menu
            ;;
        " Wlogout Theme")
            ~/.config/wlogout/toggle-wallpaper.sh 2>/dev/null
            show_appearance_menu
            ;;
        " Back"|"") show_main_menu ;;
    esac
}

# Window decorations submenu
show_decorations_menu() {
    if [ -f ~/.config/hypr/hyprbars.conf ]; then
        source ~/.config/hypr/hyprbars.conf
    else
        HYPERBARS_ENABLED=true
        BAR_HEIGHT=28
    fi
    
    if [ "$HYPERBARS_ENABLED" = "true" ]; then
        BAR_STATUS=" Title Bars Enabled"
        BAR_ACTION="Disable"
    else
        BAR_STATUS=" Title Bars Disabled"
        BAR_ACTION="Enable"
    fi
    
    CHOICE=$(echo -e "${BAR_STATUS}\n $BAR_ACTION Title Bars\n Bar Height (${BAR_HEIGHT}px)\n Update Colors\n Back" | \
        rofi -dmenu -i -p " Window Decorations" -theme ~/.config/rofi/system-settings.rasi)
    
    case "$CHOICE" in
        *"$BAR_ACTION"*)
            ~/.config/hypr/scripts/hyperbars-manager.sh toggle 2>/dev/null
            show_decorations_menu
            ;;
        " Bar Height"*) show_bar_height_menu ;;
        " Update Colors")
            ~/.config/hypr/scripts/hyprbars-manager.sh colors 2>/dev/null
            hyprctl reload
            show_decorations_menu
            ;;
        " Back"|"") show_appearance_menu ;;
    esac
}

# System submenu
show_system_menu() {
    if pgrep -x "nwg-dock-hypr" > /dev/null; then
        DOCK_STATUS=" Dock Enabled"
        DOCK_ACTION="Disable"
    else
        DOCK_STATUS=" Dock Disabled"
        DOCK_ACTION="Enable"
    fi
    
    CHOICE=$(echo -e "${DOCK_STATUS}\n $DOCK_ACTION Dock\n Dock Settings\n Back" | \
        rofi -dmenu -i -p " System" -theme ~/.config/rofi/system-settings.rasi)
    
    case "$CHOICE" in
        *"$DOCK_ACTION"*)
            ~/.config/hypr/scripts/dock-manager.sh toggle 2>/dev/null
            show_system_menu
            ;;
        " Dock Settings") show_dock_settings ;;
        " Back"|"") show_main_menu ;;
    esac
}

# Desktop submenu
show_desktop_menu() {
    CHOICE=$(echo -e " Change Wallpaper\n Waybar Style\n Notification Center\n Back" | \
        rofi -dmenu -i -p " Desktop" -theme ~/.config/rofi/system-settings.rasi)
    
    case "$CHOICE" in
        " Change Wallpaper")
            ~/.config/hypr/wallpaper.sh
            show_desktop_menu
            ;;
        " Waybar Style")
            ~/.config/waybar/scripts/select.sh 2>/dev/null
            show_desktop_menu
            ;;
        " Notification Center")
            swaync-client -t
            show_desktop_menu
            ;;
        " Back"|"") show_main_menu ;;
    esac
}

# Dock settings submenu
show_dock_settings() {
    if [ -f ~/.config/nwg-dock-hyprland/dock.conf ]; then
        source ~/.config/nwg-dock-hyprland/dock.conf
    else
        AUTO_HIDE=true
    fi
    
    if [ "$AUTO_HIDE" = "true" ]; then
        HIDE_STATUS=" Auto-hide Enabled"
    else
        HIDE_STATUS=" Auto-hide Disabled"
    fi
    
    CHOICE=$(echo -e "${HIDE_STATUS}\n Toggle Auto-hide\n Manage Pinned Apps\n Dock Position\n Back" | \
        rofi -dmenu -i -p " Dock Settings" -theme ~/.config/rofi/system-settings.rasi)
    
    case "$CHOICE" in
        " Toggle Auto-hide")
            ~/.config/hypr/scripts/dock-manager.sh autohide 2>/dev/null
            show_dock_settings
            ;;
        " Manage Pinned Apps")
            thunar ~/.config/nwg-dock-hyprland/
            show_dock_settings
            ;;
        " Dock Position") show_dock_position ;;
        " Back"|"") show_system_menu ;;
    esac
}

# Bar height menu
show_bar_height_menu() {
    CHOICE=$(echo -e " Slim (22px)\n Compact (26px)\n Standard (28px)\n Comfortable (32px)\n Large (36px)\n Back" | \
        rofi -dmenu -i -p " Title Bar Height" -theme ~/.config/rofi/system-settings.rasi)
    
    case "$CHOICE" in
        " Slim (22px)") ~/.config/hypr/scripts/hyperbars-manager.sh height 22 2>/dev/null ;;
        " Compact (26px)") ~/.config/hypr/scripts/hyprbars-manager.sh height 26 2>/dev/null ;;
        " Standard (28px)") ~/.config/hypr/scripts/hyprbars-manager.sh height 28 2>/dev/null ;;
        " Comfortable (32px)") ~/.config/hypr/scripts/hyprbars-manager.sh height 32 2>/dev/null ;;
        " Large (36px)") ~/.config/hypr/scripts/hyprbars-manager.sh height 36 2>/dev/null ;;
    esac
    show_decorations_menu
}

# Dock position menu
show_dock_position() {
    CHOICE=$(echo -e " Bottom\n Top\n Left\n Right\n Back" | \
        rofi -dmenu -i -p " Dock Position" -theme ~/.config/rofi/system-settings.rasi)
    
    case "$CHOICE" in
        " Bottom"|" Top"|" Left"|" Right")
            POS=$(echo "$CHOICE" | awk '{print tolower($2)}')
            sed -i "s/\"position\": \".*\"/\"position\": \"${POS}\"/" ~/.config/nwg-dock-hyprland/config 2>/dev/null
            ~/.config/hypr/scripts/dock-manager.sh toggle 2>/dev/null
            sleep 0.3
            ~/.config/hypr/scripts/dock-manager.sh toggle 2>/dev/null
            ;;
    esac
    show_dock_settings
}

# Start
show_main_menu
rm -f "$LOCK_FILE"