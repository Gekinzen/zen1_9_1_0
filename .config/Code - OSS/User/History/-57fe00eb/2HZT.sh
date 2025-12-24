#!/bin/bash

# Single instance check
LOCK_FILE="/tmp/system-settings.lock"
if [ -f "$LOCK_FILE" ]; then
    PID=$(cat "$LOCK_FILE")
    if ps -p "$PID" > /dev/null 2>&1; then
        kill "$PID" 2>/dev/null
        rm -f "$LOCK_FILE"
        pkill -f "rofi.*System Settings"
        exit 0
    fi
fi
echo $$ > "$LOCK_FILE"
trap "rm -f $LOCK_FILE" EXIT

# Main menu with Material Icons
show_main_menu() {
    CHOICE=$(echo -e "󰏘 Appearance\n󰒓 Settings\n󰍹 Desktop\n󰌌 Keybindings\n󰅖 Close" | \
        rofi -dmenu -i \
        -p "󰒓 System Settings v1.2" \
        -theme ~/.config/rofi/system-settings.rasi)
    
    case "$CHOICE" in
        "󰏘 Appearance") show_appearance_menu ;;
        "󰒓 Settings") show_system_menu ;;
        "󰍹 Desktop") show_desktop_menu ;;
        "󰌌 Keybindings")
            ~/.config/hypr/scripts/keybinding-viewer-interactive.sh
            show_main_menu
            ;;
        "󰅖 Close"|"") rm -f "$LOCK_FILE"; exit 0 ;;
    esac
}

# Appearance submenu
show_appearance_menu() {
    CHOICE=$(echo -e "󰖲 Window Opacity\n󰖲 Window Decorations\n󰚰 Reload Colors\n󰐥 Wlogout Theme\n󰁍 Back" | \
        rofi -dmenu -i \
        -p "󰏘 Appearance" \
        -theme ~/.config/rofi/system-settings.rasi)
    
    case "$CHOICE" in
        "󰖲 Window Opacity")
            ~/.config/hypr/scripts/opacity-settings.sh
            show_appearance_menu
            ;;
        "󰖲 Window Decorations") show_decorations_menu ;;
        "󰚰 Reload Colors")
            wal -R
            ~/.config/hypr/scripts/hyprbars-manager.sh colors 2>/dev/null
            notify-send "󰚰 Pywal" "Colors reloaded" -i preferences-desktop-theme
            show_appearance_menu
            ;;
        "󰐥 Wlogout Theme")
            ~/.config/wlogout/toggle-wallpaper.sh 2>/dev/null
            show_appearance_menu
            ;;
        "󰁍 Back"|"") show_main_menu ;;
    esac
}

# Window decorations submenu
show_decorations_menu() {
    if [ -f ~/.config/hypr/hyperbars.conf ]; then
        source ~/.config/hypr/hyperbars.conf
    else
        HYPERBARS_ENABLED=true
        BAR_HEIGHT=28
    fi
    
    if [ "$HYPERBARS_ENABLED" = "true" ]; then
        BAR_STATUS="󰄬 Title Bars ON"
        BAR_ACTION="󰅙"
    else
        BAR_STATUS="󰅙 Title Bars OFF"
        BAR_ACTION="󰄬"
    fi
    
    CHOICE=$(echo -e "${BAR_STATUS}\n${BAR_ACTION} Toggle Bars\n󰘖 Bar Height (${BAR_HEIGHT}px)\n󰚰 Update Colors\n󰁍 Back" | \
        rofi -dmenu -i \
        -p "󰖲 Decorations" \
        -theme ~/.config/rofi/system-settings.rasi)
    
    case "$CHOICE" in
        *"Toggle"*)
            ~/.config/hypr/scripts/hyperbars-manager.sh toggle 2>/dev/null
            show_decorations_menu
            ;;
        "󰘖 Bar Height"*) show_bar_height_menu ;;
        "󰚰 Update Colors")
            ~/.config/hypr/scripts/hyperbars-manager.sh colors 2>/dev/null
            hyprctl reload
            show_decorations_menu
            ;;
        "󰁍 Back"|"") show_appearance_menu ;;
    esac
}

# Bar height menu
show_bar_height_menu() {
    CHOICE=$(echo -e "󰘖 Slim (22px)\n󰘖 Compact (26px)\n󰘖 Standard (28px)\n󰘖 Comfortable (32px)\n󰘖 Large (36px)\n󰁍 Back" | \
        rofi -dmenu -i \
        -p "󰘖 Bar Height" \
        -theme ~/.config/rofi/system-settings.rasi)
    
    case "$CHOICE" in
        *"Slim"*) ~/.config/hypr/scripts/hyperbars-manager.sh height 22 2>/dev/null ;;
        *"Compact"*) ~/.config/hypr/scripts/hyperbars-manager.sh height 26 2>/dev/null ;;
        *"Standard"*) ~/.config/hypr/scripts/hyprbars-manager.sh height 28 2>/dev/null ;;
        *"Comfortable"*) ~/.config/hypr/scripts/hyprbars-manager.sh height 32 2>/dev/null ;;
        *"Large"*) ~/.config/hypr/scripts/hyprbars-manager.sh height 36 2>/dev/null ;;
    esac
    show_decorations_menu
}

# System submenu
show_system_menu() {
    if pgrep -x "nwg-dock-hypr" > /dev/null; then
        DOCK_STATUS="󰄬 Dock ON"
        DOCK_ACTION="󰅙"
    else
        DOCK_STATUS="󰅙 Dock OFF"
        DOCK_ACTION="󰄬"
    fi
    
    CHOICE=$(echo -e "${DOCK_STATUS}\n${DOCK_ACTION} Toggle Dock\n󰒓 Dock Settings\n󰁍 Back" | \
        rofi -dmenu -i \
        -p "󰒓 System" \
        -theme ~/.config/rofi/system-settings.rasi)
    
    case "$CHOICE" in
        *"Toggle"*)
            ~/.config/hypr/scripts/dock-manager.sh toggle 2>/dev/null
            show_system_menu
            ;;
        "󰒓 Dock Settings") show_dock_settings ;;
        "󰁍 Back"|"") show_main_menu ;;
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
        HIDE_STATUS="󰄬 Auto-hide ON"
    else
        HIDE_STATUS="󰅙 Auto-hide OFF"
    fi
    
    CHOICE=$(echo -e "${HIDE_STATUS}\n󰔄 Toggle Auto-hide\n󰐃 Pinned Apps\n󰹏 Position\n󰁍 Back" | \
        rofi -dmenu -i \
        -p "󰘔 Dock" \
        -theme ~/.config/rofi/system-settings.rasi)
    
    case "$CHOICE" in
        "󰔄 Toggle"*)
            ~/.config/hypr/scripts/dock-manager.sh autohide 2>/dev/null
            show_dock_settings
            ;;
        "󰐃 Pinned"*)
            thunar ~/.config/nwg-dock-hyprland/
            show_dock_settings
            ;;
        "󰹏 Position") show_dock_position ;;
        "󰁍 Back"|"") show_system_menu ;;
    esac
}

# Dock position menu
show_dock_position() {
    CHOICE=$(echo -e "󰁅 Bottom\n󰁝 Top\n󰁍 Left\n󰁔 Right\n󰁍 Back" | \
        rofi -dmenu -i \
        -p "󰹏 Position" \
        -theme ~/.config/rofi/system-settings.rasi)
    
    case "$CHOICE" in
        " Bottom")
            sed -i 's/"position": ".*"/"position": "bottom"/' ~/.config/nwg-dock-hyprland/config 2>/dev/null
            ~/.config/hypr/scripts/dock-manager.sh toggle 2>/dev/null
            sleep 0.3
            ~/.config/hypr/scripts/dock-manager.sh toggle 2>/dev/null
            ;;
        "󰁝 Top")
            sed -i 's/"position": ".*"/"position": "top"/' ~/.config/nwg-dock-hyprland/config 2>/dev/null
            ~/.config/hypr/scripts/dock-manager.sh toggle 2>/dev/null
            sleep 0.3
            ~/.config/hypr/scripts/dock-manager.sh toggle 2>/dev/null
            ;;
        "󰁍 Left")
            sed -i 's/"position": ".*"/"position": "left"/' ~/.config/nwg-dock-hyprland/config 2>/dev/null
            ~/.config/hypr/scripts/dock-manager.sh toggle 2>/dev/null
            sleep 0.3
            ~/.config/hypr/scripts/dock-manager.sh toggle 2>/dev/null
            ;;
        "󰁔 Right")
            sed -i 's/"position": ".*"/"position": "right"/' ~/.config/nwg-dock-hyprland/config 2>/dev/null
            ~/.config/hypr/scripts/dock-manager.sh toggle 2>/dev/null
            sleep 0.3
            ~/.config/hypr/scripts/dock-manager.sh toggle 2>/dev/null
            ;;
    esac
    show_dock_settings
}

# Desktop submenu
show_desktop_menu() {
    CHOICE=$(echo -e "󰸉 Wallpaper\n󱂬 Waybar Style\n󰂚 Notifications\n󰁍 Back" | \
        rofi -dmenu -i \
        -p "󰍹 Desktop" \
        -theme ~/.config/rofi/system-settings.rasi)
    
    case "$CHOICE" in
        "󰸉 Wallpaper")
            ~/.config/hypr/wallpaper.sh
            show_desktop_menu
            ;;
        "󱂬 Waybar"*)
            ~/.config/waybar/scripts/select.sh 2>/dev/null
            show_desktop_menu
            ;;
        "󰂚 Notifications")
            swaync-client -t
            show_desktop_menu
            ;;
        "󰁍 Back"|"") show_main_menu ;;
    esac
}

# Start
show_main_menu
rm -f "$LOCK_FILE"