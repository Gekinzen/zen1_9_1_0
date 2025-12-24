#!/bin/bash

# SINGLE INSTANCE CHECK with lock file
LOCK_FILE="/tmp/system-settings.lock"
if [ -f "$LOCK_FILE" ]; then
    PID=$(cat "$LOCK_FILE")
    if ps -p "$PID" > /dev/null 2>&1; then
        echo "System settings already running - closing..."
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

# Small delay
sleep 0.1

# Main menu with Material Icons
show_main_menu() {
    CHOICE=$(echo -e "󰏘 Appearance\n󰒓 Settings\n󰍹 Desktop\n󰌌 Keybindings\n󰅖 Close" | \
        rofi -dmenu -i \
        -p "󰒓 System Settings" \
        -mesg "Configure your Hyprland system appearance, desktop settings, and keybindings. Use search to quickly find options." \
        -theme ~/.config/rofi/system-settings-v2.rasi)
    
    case "$CHOICE" in
        *"Appearance"*) show_appearance_menu ;;
        *"Settings"*) show_system_menu ;;
        *"Desktop"*) show_desktop_menu ;;
        *"Keybindings"*)
            ~/.config/hypr/scripts/keybinding-viewer-interactive.sh
            show_main_menu
            ;;
        *"Close"*|"") rm -f "$LOCK_FILE"; exit 0 ;;
    esac
}

# Appearance submenu
show_appearance_menu() {
    CHOICE=$(echo -e "󰖲 Window Opacity\n󰖲 Window Decorations\n󰚰 Reload Colors\n󰐥 Wlogout Theme\n󰁍 Back" | \
        rofi -dmenu -i \
        -p "󰏘 Appearance" \
        -mesg "Customize the visual appearance of your system including window opacity, decorations, and color schemes." \
        -theme ~/.config/rofi/system-settings-v2.rasi)
    
    case "$CHOICE" in
        *"Opacity"*)
            ~/.config/hypr/scripts/opacity-settings.sh
            show_appearance_menu
            ;;
        *"Decorations"*) show_decorations_menu ;;
        *"Reload"*)
            wal -R
            ~/.config/hypr/scripts/hyprbars-manager.sh colors 2>/dev/null
            notify-send "󰚰 Pywal" "Colors reloaded" -i preferences-desktop-theme
            show_appearance_menu
            ;;
        *"Wlogout"*)
            ~/.config/wlogout/toggle-wallpaper.sh 2>/dev/null
            show_appearance_menu
            ;;
        *"Back"*|"") show_main_menu ;;
    esac
}

# Window decorations submenu
show_decorations_menu() {
    if [ -f ~/.config/hypr/hyperbars.conf ]; then
        source ~/.config/hypr/hyperbars.conf
    else
        HYPERBARS_ENABLED=true
        BAR_HEIGHT=38
        BAR_TITLE_ENABLED=false
        GLASS_ENABLED=true
    fi
    
    # Count minimized windows
    MIN_COUNT=$(hyprctl clients -j 2>/dev/null | jq '[.[] | select(.workspace.name == "special:minimized")] | length' 2>/dev/null || echo "0")
    
    # Status indicators
    if [ "$HYPERBARS_ENABLED" = "true" ]; then
        BAR_STATUS="󰄬 Title Bars ON"
    else
        BAR_STATUS="󰅙 Title Bars OFF"
    fi
    
    if [ "$GLASS_ENABLED" = "true" ]; then
        GLASS_STATUS="󰄬 Glass Effect ON"
    else
        GLASS_STATUS="󰅙 Glass Effect OFF"
    fi
    
    CHOICE=$(echo -e "${BAR_STATUS}\n󰄬 Toggle Bars\n${GLASS_STATUS}\n󰔄 Toggle Glass\n󰘖 Bar Height (${BAR_HEIGHT}px)\n󰖰 Minimized ($MIN_COUNT)\n󰚰 Update Colors\n󰁍 Back" | \
        rofi -dmenu -i \
        -p "󰖲 Window Decorations" \
        -mesg "Manage window title bars, glass effects, and restoration of minimized windows. Current bar height: ${BAR_HEIGHT}px" \
        -theme ~/.config/rofi/system-settings-v2.rasi)
    
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

# Bar height menu
show_bar_height_menu() {
    CHOICE=$(echo -e "󰘖 Compact (24px)\n󰘖 Small (28px)\n󰘖 Standard (32px)\n󰘖 Large (36px)\n󰘖 Extra Large (40px)\n󰁍 Back" | \
        rofi -dmenu -i \
        -p "󰘖 Bar Height" \
        -mesg "Choose the height of window title bars. Larger bars are easier to grab, smaller bars save screen space." \
        -theme ~/.config/rofi/system-settings-v2.rasi)
    
    case "$CHOICE" in
        *"Compact"*) ~/.config/hypr/scripts/hyprbars-manager.sh height 24 ;;
        *"Small"*) ~/.config/hypr/scripts/hyprbars-manager.sh height 28 ;;
        *"Standard"*) ~/.config/hypr/scripts/hyprbars-manager.sh height 32 ;;
        *"Large"*) ~/.config/hypr/scripts/hyprbars-manager.sh height 36 ;;
        *"Extra Large"*) ~/.config/hypr/scripts/hyprbars-manager.sh height 40 ;;
    esac
    show_decorations_menu
}

# System submenu
show_system_menu() {
    if pgrep -x "nwg-dock-hypr" > /dev/null; then
        DOCK_STATUS="󰄬 Dock ON"
        DOCK_ACTION="󰅙 Disable"
    else
        DOCK_STATUS="󰅙 Dock OFF"
        DOCK_ACTION="󰄬 Enable"
    fi
    
    CHOICE=$(echo -e "${DOCK_STATUS}\n${DOCK_ACTION} Dock\n󰒓 Dock Settings\n󰁍 Back" | \
        rofi -dmenu -i \
        -p "󰒓 System" \
        -mesg "Configure system-level features including the application dock. Current dock status: ${DOCK_STATUS}" \
        -theme ~/.config/rofi/system-settings-v2.rasi)
    
    case "$CHOICE" in
        *"Disable"*|*"Enable"*)
            ~/.config/hypr/scripts/dock-manager.sh toggle 2>/dev/null
            show_system_menu
            ;;
        *"Settings"*) show_dock_settings ;;
        *"Back"*|"") show_main_menu ;;
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
        -mesg "Manage dock behavior and appearance. Configure auto-hide, pinned applications, and dock position on screen." \
        -theme ~/.config/rofi/system-settings-v2.rasi)
    
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

# Dock position menu
show_dock_position() {
    CHOICE=$(echo -e "󰁅 Bottom\n󰁝 Top\n󰁍 Left\n󰁔 Right\n󰁍 Back" | \
        rofi -dmenu -i \
        -p "󰹏 Position" \
        -mesg "Select where the dock should be positioned on your screen. The dock will be restarted to apply changes." \
        -theme ~/.config/rofi/system-settings-v2.rasi)
    
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

# Desktop submenu
show_desktop_menu() {
    CHOICE=$(echo -e "󰸉 Wallpaper\n󱂬 Waybar Style\n󰂚 Notifications\n󰁍 Back" | \
        rofi -dmenu -i \
        -p "󰍹 Desktop" \
        -mesg "Personalize your desktop environment with wallpapers, panel styles, and notification settings." \
        -theme ~/.config/rofi/system-settings-v2.rasi)
    
    case "$CHOICE" in
        *"Wallpaper"*)
            ~/.config/hypr/wallpaper.sh
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