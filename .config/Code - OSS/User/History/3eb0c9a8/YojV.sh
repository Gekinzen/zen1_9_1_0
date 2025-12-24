#!/bin/bash

# Get current wallpaper info
get_wallpaper_info() {
    WALLPAPER_DIR="$HOME/wallpapers"
    
    # Try swww cache first
    if command -v swww &> /dev/null; then
        CACHE_FILE="$HOME/.cache/swww/eDP-1"  # Adjust monitor name
        if [ -f "$CACHE_FILE" ]; then
            CURRENT_WP=$(cat "$CACHE_FILE" 2>/dev/null)
        fi
    fi
    
    # Fallback to pywal
    if [ -z "$CURRENT_WP" ]; then
        CURRENT_WP=$(cat ~/.cache/wal/wal 2>/dev/null)
    fi
    
    # Fallback to checking wallpapers directory
    if [ -z "$CURRENT_WP" ] || [ ! -f "$CURRENT_WP" ]; then
        # Check for pywallpaper.jpg
        if [ -f "$WALLPAPER_DIR/pywallpaper.jpg" ]; then
            CURRENT_WP="$WALLPAPER_DIR/pywallpaper.jpg"
        elif [ -f "$WALLPAPER_DIR/pywallpaper.png" ]; then
            CURRENT_WP="$WALLPAPER_DIR/pywallpaper.png"
        else
            # Find most recent wallpaper
            CURRENT_WP=$(find "$WALLPAPER_DIR" -maxdepth 2 -type f \( -name "*.jpg" -o -name "*.png" \) -printf '%T@ %p\n' | sort -rn | head -1 | cut -d' ' -f2-)
        fi
    fi
    
    if [ -n "$CURRENT_WP" ] && [ -f "$CURRENT_WP" ]; then
        WP_NAME=$(basename "$CURRENT_WP")
        WP_DIR=$(dirname "$CURRENT_WP")
        echo "󰸉 $WP_NAME"
    else
        echo "󰸉 No wallpaper set"
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

# Get wallpaper info
WALLPAPER_INFO=$(get_wallpaper_info)

# Main menu
show_main_menu() {
    local DESCRIPTION="━━━━━━━━━━━━━━━━━━━━━━━━
Current Wallpaper:
$WALLPAPER_INFO
━━━━━━━━━━━━━━━━━━━━━━━━

SYSTEM SETTINGS MENU

Select a category:

󰏘 Appearance
  Window opacity, decorations,
  colors, and visual themes

󰒓 System
  Dock settings and system
  level configurations

󰍹 Desktop
  Wallpapers, waybar styles,
  notifications

󰌌 Keybindings
  View all keyboard shortcuts
  and custom keybinds

Press ESC to close"

    CHOICE=$(echo -e "󰏘 Appearance\n󰒓 System\n󰍹 Desktop\n󰌌 Keybindings\n󰅖 Close" | \
        rofi -dmenu -i \
        -p "󰒓 System Settings" \
        -mesg "$DESCRIPTION" \
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
    local DESCRIPTION="━━━━━━━━━━━━━━━━━━━━━━━━
Current Wallpaper:
$WALLPAPER_INFO
━━━━━━━━━━━━━━━━━━━━━━━━

APPEARANCE SETTINGS

Customize visual elements:

󰖲 Window Opacity
  Adjust transparency levels
  for active and inactive windows

󰖲 Window Decorations
  Configure macOS-style title bars
  with glass effects

󰚰 Reload Colors
  Refresh pywal color scheme
  from current wallpaper

󰐥 Wlogout Theme
  Toggle wallpaper display
  in power menu"

    CHOICE=$(echo -e "󰖲 Window Opacity\n󰖲 Window Decorations\n󰚰 Reload Colors\n󰐥 Wlogout Theme\n󰁍 Back" | \
        rofi -dmenu -i \
        -p "󰏘 Appearance" \
        -mesg "$DESCRIPTION" \
        -theme ~/.config/rofi/system-settings-v3.rasi)
    
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

# Window decorations menu
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
    
    local DESCRIPTION="━━━━━━━━━━━━━━━━━━━━━━━━
Current Wallpaper:
$WALLPAPER_INFO
━━━━━━━━━━━━━━━━━━━━━━━━

WINDOW DECORATIONS

Status: Bars $BAR_STATUS | Glass $GLASS_STATUS
Height: ${BAR_HEIGHT}px | Minimized: $MIN_COUNT

󰄬 Toggle Bars
  Enable/disable macOS-style
  title bars with buttons

󰔄 Toggle Glass
  Transparent blur effect
  on title bars

󰘖 Bar Height
  Adjust size (24-40px)
  Compact to Extra Large

󰖰 Minimized Windows
  Restore hidden windows
  from special workspace

󰚰 Update Colors
  Sync with current pywal theme"

    CHOICE=$(echo -e "󰄬 Toggle Bars ($BAR_STATUS)\n󰔄 Toggle Glass ($GLASS_STATUS)\n󰘖 Bar Height (${BAR_HEIGHT}px)\n󰖰 Minimized ($MIN_COUNT)\n󰚰 Update Colors\n󰁍 Back" | \
        rofi -dmenu -i \
        -p "󰖲 Decorations" \
        -mesg "$DESCRIPTION" \
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

# Bar height menu
show_bar_height_menu() {
    local DESCRIPTION="━━━━━━━━━━━━━━━━━━━━━━━━
Current Wallpaper:
$WALLPAPER_INFO
━━━━━━━━━━━━━━━━━━━━━━━━

BAR HEIGHT SELECTION

Choose title bar size:

󰘖 Compact (24px)
  Maximum screen space

󰘖 Small (28px)
  Balanced, modern look

󰘖 Standard (32px)
  Default, comfortable

󰘖 Large (36px)
  Easy to grab, accessible

󰘖 Extra Large (40px)
  Premium, spacious feel

Changes apply immediately"

    CHOICE=$(echo -e "󰘖 Compact (24px)\n󰘖 Small (28px)\n󰘖 Standard (32px)\n󰘖 Large (36px)\n󰘖 Extra Large (40px)\n󰁍 Back" | \
        rofi -dmenu -i \
        -p "󰘖 Bar Height" \
        -mesg "$DESCRIPTION" \
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
    
    local DESCRIPTION="━━━━━━━━━━━━━━━━━━━━━━━━
Current Wallpaper:
$WALLPAPER_INFO
━━━━━━━━━━━━━━━━━━━━━━━━

SYSTEM SETTINGS

Dock Status: $DOCK_STATUS

󰘔 Dock Toggle
  Show/hide macOS-style dock
  with pinned applications

󰒓 Dock Settings
  Configure auto-hide behavior
  pinned apps, and position

The dock provides quick access
to frequently used apps"

    CHOICE=$(echo -e "󰘔 Toggle Dock\n󰒓 Dock Settings\n󰁍 Back" | \
        rofi -dmenu -i \
        -p "󰒓 System" \
        -mesg "$DESCRIPTION" \
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
    
    local DESCRIPTION="━━━━━━━━━━━━━━━━━━━━━━━━
Current Wallpaper:
$WALLPAPER_INFO
━━━━━━━━━━━━━━━━━━━━━━━━

DOCK CONFIGURATION

Auto-hide: $HIDE_STATUS

󰔄 Toggle Auto-hide
  ON: Hidden, shows on hover
  OFF: Always visible

󰐃 Pinned Apps
  Manage permanently pinned
  applications in dock

󰹏 Position
  Bottom, Top, Left, or Right
  edge of screen

Dock restarts to apply changes"

    CHOICE=$(echo -e "󰔄 Toggle Auto-hide ($HIDE_STATUS)\n󰐃 Pinned Apps\n󰹏 Position\n󰁍 Back" | \
        rofi -dmenu -i \
        -p "󰘔 Dock" \
        -mesg "$DESCRIPTION" \
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
    local DESCRIPTION="━━━━━━━━━━━━━━━━━━━━━━━━
Current Wallpaper:
$WALLPAPER_INFO
━━━━━━━━━━━━━━━━━━━━━━━━

DOCK POSITION

Select placement:

󰁅 Bottom
  Traditional (recommended)

󰁝 Top
  Alternative placement

󰁍 Left
  Vertical, saves width

󰁔 Right
  Vertical, right side

Dock restarts automatically"

    CHOICE=$(echo -e "󰁅 Bottom\n󰁝 Top\n󰁍 Left\n󰁔 Right\n󰁍 Back" | \
        rofi -dmenu -i \
        -p "󰹏 Position" \
        -mesg "$DESCRIPTION" \
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
    local DESCRIPTION="━━━━━━━━━━━━━━━━━━━━━━━━
Current Wallpaper:
$WALLPAPER_INFO
━━━━━━━━━━━━━━━━━━━━━━━━

DESKTOP PERSONALIZATION

Customize your environment:

󰸉 Wallpaper
  Browse ~/wallpapers/
  Auto-generates color scheme

󱂬 Waybar Style
  Choose panel theme
  Multiple layouts available

󰂚 Notifications
  Toggle notification center
  System and app alerts

Changes apply immediately"

    CHOICE=$(echo -e "󰸉 Wallpaper\n󱂬 Waybar Style\n󰂚 Notifications\n󰁍 Back" | \
        rofi -dmenu -i \
        -p "󰍹 Desktop" \
        -mesg "$DESCRIPTION" \
        -theme ~/.config/rofi/system-settings-v3.rasi)
    
    case "$CHOICE" in
        *"Wallpaper"*)
            ~/.config/hypr/wallpaper.sh
            # Refresh to show new wallpaper
            WALLPAPER_INFO=$(get_wallpaper_info)
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