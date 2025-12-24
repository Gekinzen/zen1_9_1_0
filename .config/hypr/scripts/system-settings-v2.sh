#!/bin/bash

# Update rofi wallpaper cache
update_wallpaper_cache() {
    WALLPAPER_CACHE="$HOME/.cache/current-wallpaper.jpg"
    
    # Get current wallpaper
    if [ -f ~/.cache/wal/wal ]; then
        CURRENT_WP=$(cat ~/.cache/wal/wal)
    elif [ -f ~/wallpapers/pywallpaper.jpg ]; then
        CURRENT_WP="$HOME/wallpapers/pywallpaper.jpg"
    fi
    
    # Copy to cache
    if [ -n "$CURRENT_WP" ] && [ -f "$CURRENT_WP" ]; then
        cp "$CURRENT_WP" "$WALLPAPER_CACHE" 2>/dev/null
    fi
}

# Get wallpaper name
get_wallpaper_name() {
    if [ -f ~/.cache/wal/wal ]; then
        basename "$(cat ~/.cache/wal/wal)"
    elif [ -f ~/wallpapers/pywallpaper.jpg ]; then
        echo "pywallpaper.jpg"
    else
        echo "No wallpaper"
    fi
}

# Update cache before showing menu
update_wallpaper_cache

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

# Main menu
show_main_menu() {
    local DESC="━━━━━━━━━━━━━━━━━━━━━
󰸉 $(get_wallpaper_name)
━━━━━━━━━━━━━━━━━━━━━

SYSTEM SETTINGS

󰏘 Appearance
   Opacity, decorations, colors

󰒓 System
   Dock and system settings

󰍹 Desktop
   Wallpaper, waybar, notifications

󰌌 Keybindings
   View shortcuts"

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

# Appearance menu - Each option explained
show_appearance_menu() {
    local DESC="━━━━━━━━━━━━━━━━━━━━━
󰏘 APPEARANCE
━━━━━━━━━━━━━━━━━━━━━

󰖲 Window Opacity
   Control window transparency
   Active/inactive levels

󰖲 Window Decorations
   macOS-style title bars
   Glass effects, height

󰚰 Reload Colors
   Refresh pywal theme
   From current wallpaper

󰐥 Wlogout Theme
   Power menu wallpaper toggle"

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
            update_wallpaper_cache
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

# Window decorations - Status + Options
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
    
    local DESC="━━━━━━━━━━━━━━━━━━━━━
󰖲 WINDOW DECORATIONS
━━━━━━━━━━━━━━━━━━━━━

Current Status:
Bars: $BAR_STATUS | Glass: $GLASS_STATUS
Height: ${BAR_HEIGHT}px | Hidden: $MIN_COUNT

󰄬 Toggle Bars
   Enable/disable title bars

󰔄 Toggle Glass
   Transparent blur effect

󰘖 Bar Height
   24px to 40px sizes

󰖰 Restore Minimized
   Show hidden windows

󰚰 Update Colors
   Sync with pywal theme"

    CHOICE=$(echo -e "󰄬 Toggle Bars\n󰔄 Toggle Glass\n󰘖 Bar Height\n󰖰 Minimized ($MIN_COUNT)\n󰚰 Update Colors\n󰁍 Back" | \
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

# Bar height - Clear size options
show_bar_height_menu() {
    local DESC="━━━━━━━━━━━━━━━━━━━━━
󰘖 TITLE BAR HEIGHT
━━━━━━━━━━━━━━━━━━━━━

Select size:

󰘖 24px - Compact
   Maximum screen space

󰘖 28px - Small
   Balanced look

󰘖 32px - Standard
   Default comfortable size

󰘖 36px - Large
   Easy to grab

󰘖 40px - Extra Large
   Premium spacious feel"

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

# System menu - Dock controls
show_system_menu() {
    pgrep -x "nwg-dock-hypr" > /dev/null && DOCK_STATUS="ON" || DOCK_STATUS="OFF"
    
    local DESC="━━━━━━━━━━━━━━━━━━━━━
󰒓 SYSTEM SETTINGS
━━━━━━━━━━━━━━━━━━━━━

Dock Status: $DOCK_STATUS

󰘔 Toggle Dock
   Show/hide application dock

󰒓 Dock Settings
   Auto-hide, position, apps

macOS-style dock with
quick app access"

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

# Dock settings - Configuration
show_dock_settings() {
    if [ -f ~/.config/nwg-dock-hyprland/dock.conf ]; then
        source ~/.config/nwg-dock-hyprland/dock.conf
    else
        AUTO_HIDE=true
    fi
    
    [ "$AUTO_HIDE" = "true" ] && HIDE_STATUS="ON" || HIDE_STATUS="OFF"
    
    local DESC="━━━━━━━━━━━━━━━━━━━━━
󰘔 DOCK CONFIGURATION
━━━━━━━━━━━━━━━━━━━━━

Auto-hide: $HIDE_STATUS

󰔄 Toggle Auto-hide
   ON: Shows on hover
   OFF: Always visible

󰐃 Pinned Apps
   Manage dock apps

󰹏 Position
   Bottom, Top, Left, Right"

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

# Dock position - Placement options
show_dock_position() {
    local DESC="━━━━━━━━━━━━━━━━━━━━━
󰹏 DOCK POSITION
━━━━━━━━━━━━━━━━━━━━━

󰁅 Bottom
   Traditional placement

󰁝 Top
   Alternative top edge

󰁍 Left
   Vertical left side

󰁔 Right
   Vertical right side"

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

# Desktop menu - Personalization
show_desktop_menu() {
    local DESC="━━━━━━━━━━━━━━━━━━━━━
󰍹 DESKTOP
━━━━━━━━━━━━━━━━━━━━━

󰸉 Wallpaper
   Browse ~/wallpapers/
   Auto-generates colors

󱂬 Waybar Style
   Choose panel theme

󰂚 Notifications
   Toggle notification center"

    CHOICE=$(echo -e "󰸉 Wallpaper\n󱂬 Waybar Style\n󰂚 Notifications\n󰁍 Back" | \
        rofi -dmenu -i \
        -p "󰍹 Desktop" \
        -mesg "$DESC" \
        -theme ~/.config/rofi/system-settings-v3.rasi)
    
    case "$CHOICE" in
        *"Wallpaper"*)
            ~/.config/hypr/wallpaper.sh
            update_wallpaper_cache
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