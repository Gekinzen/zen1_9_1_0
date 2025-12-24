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
    else
        rm -f "$LOCK_FILE"
    fi
fi
echo $$ > "$LOCK_FILE"
trap "rm -f $LOCK_FILE" EXIT

# Main menu
show_main_menu() {
    CHOICE=$(echo -e "🎨 Appearance\n⚙️ System\n🖥️ Desktop\n⌨️ Keybindings\n❌ Close" | \
        rofi -dmenu -i \
        -p "System Settings" \
        -theme ~/.config/rofi/system-settings.rasi)
    
    case "$CHOICE" in
        "🎨 Appearance")
            show_appearance_menu
            ;;
        "⚙️ System")
            show_system_menu
            ;;
        "🖥️ Desktop")
            show_desktop_menu
            ;;
        "⌨️ Keybindings")
            ~/.config/hypr/scripts/keybinding-viewer-interactive.sh
            show_main_menu
            ;;
        "❌ Close"|"")
            rm -f "$LOCK_FILE"
            exit 0
            ;;
    esac
}

# Appearance submenu
show_appearance_menu() {
    CHOICE=$(echo -e "🪟 Window Opacity\n🎨 Reload Colors\n⚡ Wlogout Theme\n◀️ Back" | \
        rofi -dmenu -i \
        -p "Appearance" \
        -theme ~/.config/rofi/system-settings.rasi)
    
    case "$CHOICE" in
        "🪟 Window Opacity")
            ~/.config/hypr/scripts/opacity-settings.sh
            show_appearance_menu
            ;;
        "🎨 Reload Colors")
            wal -R
            notify-send "Pywal" "Colors reloaded" -i preferences-desktop-theme
            show_appearance_menu
            ;;
        "⚡ Wlogout Theme")
            ~/.config/wlogout/toggle-wallpaper.sh
            show_appearance_menu
            ;;
        "◀️ Back"|"")
            show_main_menu
            ;;
    esac
}

# System submenu
show_system_menu() {
    # Check current states
    if pgrep -x "nwg-dock-hypr" > /dev/null; then
        DOCK_STATUS="✓ Dock Enabled"
        DOCK_ACTION="Disable"
    else
        DOCK_STATUS="✗ Dock Disabled"
        DOCK_ACTION="Enable"
    fi
    
    CHOICE=$(echo -e "${DOCK_STATUS}\n🎯 ${DOCK_ACTION} Dock\n🎚️ Dock Settings\n◀️ Back" | \
        rofi -dmenu -i \
        -p "System" \
        -theme ~/.config/rofi/system-settings.rasi)
    
    case "$CHOICE" in
        *"Enable Dock"*|*"Disable Dock"*)
            ~/.config/hypr/scripts/dock-manager.sh toggle
            show_system_menu
            ;;
        "🎚️ Dock Settings")
            show_dock_settings
            ;;
        "◀️ Back"|"")
            show_main_menu
            ;;
    esac
}

# Dock settings submenu
show_dock_settings() {
    source ~/.config/nwg-dock-hyprland/dock.conf
    
    if [ "$AUTO_HIDE" = "true" ]; then
        HIDE_STATUS="✓ Auto-hide Enabled"
    else
        HIDE_STATUS="✗ Auto-hide Disabled"
    fi
    
    CHOICE=$(echo -e "${HIDE_STATUS}\n🔄 Toggle Auto-hide\n📌 Manage Pinned Apps\n📐 Dock Position\n◀️ Back" | \
        rofi -dmenu -i \
        -p "Dock Settings" \
        -theme ~/.config/rofi/system-settings.rasi)
    
    case "$CHOICE" in
        "🔄 Toggle Auto-hide")
            ~/.config/hypr/scripts/dock-manager.sh autohide
            show_dock_settings
            ;;
        "📌 Manage Pinned Apps")
            thunar ~/.config/nwg-dock-hyprland/
            show_dock_settings
            ;;
        "📐 Dock Position")
            show_dock_position
            ;;
        "◀️ Back"|"")
            show_system_menu
            ;;
    esac
}

# Dock position menu
show_dock_position() {
    CHOICE=$(echo -e "⬇️ Bottom\n⬆️ Top\n⬅️ Left\n➡️ Right\n◀️ Back" | \
        rofi -dmenu -i \
        -p "Dock Position" \
        -theme ~/.config/rofi/system-settings.rasi)
    
    case "$CHOICE" in
        "⬇️ Bottom") 
            sed -i 's/"position": ".*"/"position": "bottom"/' ~/.config/nwg-dock-hyprland/config
            ~/.config/hypr/scripts/dock-manager.sh toggle
            sleep 0.3
            ~/.config/hypr/scripts/dock-manager.sh toggle
            ;;
        "⬆️ Top") 
            sed -i 's/"position": ".*"/"position": "top"/' ~/.config/nwg-dock-hyprland/config
            ~/.config/hypr/scripts/dock-manager.sh toggle
            sleep 0.3
            ~/.config/hypr/scripts/dock-manager.sh toggle
            ;;
        *) ;;
    esac
    show_dock_settings
}

# Desktop submenu
show_desktop_menu() {
    CHOICE=$(echo -e "🖼️ Change Wallpaper\n📊 Waybar Style\n🔔 Notification Style\n◀️ Back" | \
        rofi -dmenu -i \
        -p "Desktop" \
        -theme ~/.config/rofi/system-settings.rasi)
    
    case "$CHOICE" in
        "🖼️ Change Wallpaper")
            ~/.config/hypr/wallpaper.sh
            show_desktop_menu
            ;;
        "📊 Waybar Style")
            ~/.config/waybar/scripts/select.sh
            show_desktop_menu
            ;;
        "🔔 Notification Style")
            swaync-client -t
            show_desktop_menu
            ;;
        "◀️ Back"|"")
            show_main_menu
            ;;
    esac
}

# Start
show_main_menu
rm -f "$LOCK_FILE"