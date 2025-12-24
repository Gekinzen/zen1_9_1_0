#!/bin/bash

# System Settings - Custom Rofi Modi with Real-time Descriptions
# This script provides dynamic descriptions on hover/select

# Descriptions database
declare -A DESCRIPTIONS=(
    # Main Menu
    ["󰏘 Appearance"]="Customize the visual appearance of your Hyprland system including window opacity, decorations, color schemes, and themes."
    ["󰒓 Settings"]="Configure system-level features and behavior including the application dock, auto-hide settings, and system preferences."
    ["󰍹 Desktop"]="Personalize your desktop environment with wallpapers, panel styles, notification settings, and desktop widgets."
    ["󰌌 Keybindings"]="View and manage keyboard shortcuts for window management, applications, and system controls."
    ["󰅖 Close"]="Exit the system settings menu and return to your desktop."
    
    # Appearance Menu
    ["󰖲 Window Opacity"]="Adjust the transparency level of windows. Make windows more or less transparent to see content behind them."
    ["󰖲 Window Decorations"]="Manage window title bars, glass effects, and visual decorations. Toggle bars on/off and customize their appearance."
    ["󰚰 Reload Colors"]="Reload Pywal color scheme and apply it to all components including window decorations and panels."
    ["󰐥 Wlogout Theme"]="Toggle the wlogout theme between wallpaper background and solid color background."
    
    # Window Decorations
    ["󰄬 Title Bars ON"]="Title bars are currently enabled. Click 'Toggle Bars' to disable them for a cleaner, borderless window look."
    ["󰅙 Title Bars OFF"]="Title bars are currently disabled. Click 'Toggle Bars' to enable them for easier window management."
    ["󰄬 Toggle Bars"]="Switch window title bars on or off. Title bars show window titles and provide buttons for window controls."
    ["󰄬 Glass Effect ON"]="Glass blur effect is enabled on title bars. Gives a modern, translucent appearance."
    ["󰅙 Glass Effect OFF"]="Glass blur effect is disabled. Title bars will have solid colors."
    ["󰔄 Toggle Glass"]="Enable or disable the glass blur effect on window title bars for a modern frosted glass appearance."
    ["󰘖 Bar Height"]="Change the height of window title bars. Larger bars are easier to grab, smaller bars save screen space."
    ["󰖰 Minimized"]="View and restore windows that have been minimized to the special workspace."
    ["󰚰 Update Colors"]="Update title bar colors to match your current Pywal color scheme."
    
    # Bar Height Options
    ["󰘖 Compact (24px)"]="Extra small title bars (24px) - Maximum screen space, minimal window chrome."
    ["󰘖 Small (28px)"]="Small title bars (28px) - Balanced between space saving and usability."
    ["󰘖 Standard (32px)"]="Standard title bars (32px) - Default size, good for most use cases."
    ["󰘖 Large (36px)"]="Large title bars (36px) - Easier to click and drag, more prominent."
    ["󰘖 Extra Large (40px)"]="Extra large title bars (40px) - Maximum visibility and ease of use."
    
    # System Settings
    ["󰄬 Dock ON"]="Application dock is currently running and visible on your screen."
    ["󰅙 Dock OFF"]="Application dock is currently disabled. Enable it to have quick access to applications."
    ["󰅙 Disable Dock"]="Stop the application dock. It will no longer appear on your screen until re-enabled."
    ["󰄬 Enable Dock"]="Start the application dock to have a persistent launcher bar on your screen."
    ["󰒓 Dock Settings"]="Configure dock behavior including auto-hide, position, and pinned applications."
    
    # Dock Settings
    ["󰄬 Auto-hide ON"]="Dock automatically hides when not in use and appears when you hover near its edge."
    ["󰅙 Auto-hide OFF"]="Dock is always visible on screen. It will not hide automatically."
    ["󰔄 Toggle Auto-hide"]="Switch dock auto-hide behavior. When enabled, dock hides until you hover over it."
    ["󰐃 Pinned Apps"]="Open the dock configuration folder to manage pinned applications and their order."
    ["󰹏 Position"]="Change where the dock appears on your screen - bottom, top, left, or right edge."
    
    # Dock Position
    ["󰁅 Bottom"]="Place the dock at the bottom of the screen. Most common and traditional position."
    ["󰁝 Top"]="Place the dock at the top of the screen. Good for ultrawide monitors."
    ["󰁍 Left"]="Place the dock on the left edge of the screen. Vertical orientation."
    ["󰁔 Right"]="Place the dock on the right edge of the screen. Vertical orientation."
    
    # Desktop Settings
    ["󰸉 Wallpaper"]="Change your desktop wallpaper. Select from your wallpaper collection or add new ones."
    ["󱂬 Waybar Style"]="Switch between different Waybar panel layouts and styles. Choose from various pre-configured themes."
    ["󰂚 Notifications"]="Toggle notification center visibility. View and manage system notifications."
    
    # Navigation
    ["󰁍 Back"]="Return to the previous menu."
)

# Menu state management
CURRENT_MENU="main"
MENU_STACK=()

# Generate menu items based on current state
generate_menu() {
    case "$CURRENT_MENU" in
        main)
            echo "󰏘 Appearance"
            echo "󰒓 Settings"
            echo "󰍹 Desktop"
            echo "󰌌 Keybindings"
            echo "󰅖 Close"
            ;;
        appearance)
            echo "󰖲 Window Opacity"
            echo "󰖲 Window Decorations"
            echo "󰚰 Reload Colors"
            echo "󰐥 Wlogout Theme"
            echo "󰁍 Back"
            ;;
        decorations)
            # Check current status
            if [ -f ~/.config/hypr/hyperbars.conf ]; then
                source ~/.config/hypr/hyperbars.conf
            else
                HYPERBARS_ENABLED=true
                GLASS_ENABLED=true
                BAR_HEIGHT=38
            fi
            
            MIN_COUNT=$(hyprctl clients -j 2>/dev/null | jq '[.[] | select(.workspace.name == "special:minimized")] | length' 2>/dev/null || echo "0")
            
            if [ "$HYPERBARS_ENABLED" = "true" ]; then
                echo "󰄬 Title Bars ON"
            else
                echo "󰅙 Title Bars OFF"
            fi
            echo "󰄬 Toggle Bars"
            
            if [ "$GLASS_ENABLED" = "true" ]; then
                echo "󰄬 Glass Effect ON"
            else
                echo "󰅙 Glass Effect OFF"
            fi
            echo "󰔄 Toggle Glass"
            echo "󰘖 Bar Height (${BAR_HEIGHT}px)"
            echo "󰖰 Minimized ($MIN_COUNT)"
            echo "󰚰 Update Colors"
            echo "󰁍 Back"
            ;;
        bar_height)
            echo "󰘖 Compact (24px)"
            echo "󰘖 Small (28px)"
            echo "󰘖 Standard (32px)"
            echo "󰘖 Large (36px)"
            echo "󰘖 Extra Large (40px)"
            echo "󰁍 Back"
            ;;
        system)
            if pgrep -x "nwg-dock-hypr" > /dev/null; then
                echo "󰄬 Dock ON"
                echo "󰅙 Disable Dock"
            else
                echo "󰅙 Dock OFF"
                echo "󰄬 Enable Dock"
            fi
            echo "󰒓 Dock Settings"
            echo "󰁍 Back"
            ;;
        dock_settings)
            if [ -f ~/.config/nwg-dock-hyprland/dock.conf ]; then
                source ~/.config/nwg-dock-hyprland/dock.conf
            else
                AUTO_HIDE=true
            fi
            
            if [ "$AUTO_HIDE" = "true" ]; then
                echo "󰄬 Auto-hide ON"
            else
                echo "󰅙 Auto-hide OFF"
            fi
            echo "󰔄 Toggle Auto-hide"
            echo "󰐃 Pinned Apps"
            echo "󰹏 Position"
            echo "󰁍 Back"
            ;;
        dock_position)
            echo "󰁅 Bottom"
            echo "󰁝 Top"
            echo "󰁍 Left"
            echo "󰁔 Right"
            echo "󰁍 Back"
            ;;
        desktop)
            echo "󰸉 Wallpaper"
            echo "󱂬 Waybar Style"
            echo "󰂚 Notifications"
            echo "󰁍 Back"
            ;;
    esac
}

# Handle selection
handle_selection() {
    local choice="$1"
    
    case "$choice" in
        "󰏘 Appearance")
            MENU_STACK+=("$CURRENT_MENU")
            CURRENT_MENU="appearance"
            generate_menu
            ;;
        "󰒓 Settings")
            MENU_STACK+=("$CURRENT_MENU")
            CURRENT_MENU="system"
            generate_menu
            ;;
        "󰍹 Desktop")
            MENU_STACK+=("$CURRENT_MENU")
            CURRENT_MENU="desktop"
            generate_menu
            ;;
        "󰌌 Keybindings")
            ~/.config/hypr/scripts/keybinding-viewer-interactive.sh &
            generate_menu
            ;;
        "󰅖 Close")
            exit 0
            ;;
        "󰖲 Window Opacity")
            ~/.config/hypr/scripts/opacity-settings.sh &
            generate_menu
            ;;
        "󰖲 Window Decorations")
            MENU_STACK+=("$CURRENT_MENU")
            CURRENT_MENU="decorations"
            generate_menu
            ;;
        "󰚰 Reload Colors")
            wal -R
            ~/.config/hypr/scripts/hyprbars-manager.sh colors 2>/dev/null
            notify-send "󰚰 Pywal" "Colors reloaded" -i preferences-desktop-theme
            generate_menu
            ;;
        "󰐥 Wlogout Theme")
            ~/.config/wlogout/toggle-wallpaper.sh 2>/dev/null
            generate_menu
            ;;
        "󰄬 Toggle Bars")
            ~/.config/hypr/scripts/hyprbars-manager.sh toggle
            CURRENT_MENU="decorations"
            generate_menu
            ;;
        "󰔄 Toggle Glass")
            ~/.config/hypr/scripts/hyprbars-glass-toggle.sh
            CURRENT_MENU="decorations"
            generate_menu
            ;;
        "󰘖 Bar Height"*)
            MENU_STACK+=("$CURRENT_MENU")
            CURRENT_MENU="bar_height"
            generate_menu
            ;;
        "󰘖 Compact (24px)")
            ~/.config/hypr/scripts/hyprbars-manager.sh height 24
            CURRENT_MENU="${MENU_STACK[-1]}"
            unset 'MENU_STACK[-1]'
            generate_menu
            ;;
        "󰘖 Small (28px)")
            ~/.config/hypr/scripts/hyprbars-manager.sh height 28
            CURRENT_MENU="${MENU_STACK[-1]}"
            unset 'MENU_STACK[-1]'
            generate_menu
            ;;
        "󰘖 Standard (32px)")
            ~/.config/hypr/scripts/hyprbars-manager.sh height 32
            CURRENT_MENU="${MENU_STACK[-1]}"
            unset 'MENU_STACK[-1]'
            generate_menu
            ;;
        "󰘖 Large (36px)")
            ~/.config/hypr/scripts/hyprbars-manager.sh height 36
            CURRENT_MENU="${MENU_STACK[-1]}"
            unset 'MENU_STACK[-1]'
            generate_menu
            ;;
        "󰘖 Extra Large (40px)")
            ~/.config/hypr/scripts/hyprbars-manager.sh height 40
            CURRENT_MENU="${MENU_STACK[-1]}"
            unset 'MENU_STACK[-1]'
            generate_menu
            ;;
        "󰖰 Minimized"*)
            ~/.config/hypr/scripts/hyprbars-restore-menu.sh &
            generate_menu
            ;;
        "󰚰 Update Colors")
            ~/.config/hypr/scripts/update-hyprbars-glass.sh
            generate_menu
            ;;
        *"Disable Dock"|*"Enable Dock")
            ~/.config/hypr/scripts/dock-manager.sh toggle 2>/dev/null
            CURRENT_MENU="system"
            generate_menu
            ;;
        "󰒓 Dock Settings")
            MENU_STACK+=("$CURRENT_MENU")
            CURRENT_MENU="dock_settings"
            generate_menu
            ;;
        "󰔄 Toggle Auto-hide")
            ~/.config/hypr/scripts/dock-manager.sh autohide 2>/dev/null
            CURRENT_MENU="dock_settings"
            generate_menu
            ;;
        "󰐃 Pinned Apps")
            thunar ~/.config/nwg-dock-hyprland/ &
            generate_menu
            ;;
        "󰹏 Position")
            MENU_STACK+=("$CURRENT_MENU")
            CURRENT_MENU="dock_position"
            generate_menu
            ;;
        "󰁅 Bottom"|"󰁝 Top"|"󰁍 Left"|"󰁔 Right")
            POS=$(echo "$choice" | sed 's/[^ ]* //' | tr '[:upper:]' '[:lower:]')
            sed -i "s/\"position\": \".*\"/\"position\": \"${POS}\"/" ~/.config/nwg-dock-hyprland/config 2>/dev/null
            ~/.config/hypr/scripts/dock-manager.sh toggle 2>/dev/null
            sleep 0.3
            ~/.config/hypr/scripts/dock-manager.sh toggle 2>/dev/null
            CURRENT_MENU="${MENU_STACK[-1]}"
            unset 'MENU_STACK[-1]'
            generate_menu
            ;;
        "󰸉 Wallpaper")
            ~/.config/hypr/wallpaper.sh &
            generate_menu
            ;;
        "󱂬 Waybar Style")
            ~/.config/waybar/scripts/select.sh 2>/dev/null &
            generate_menu
            ;;
        "󰂚 Notifications")
            swaync-client -t
            generate_menu
            ;;
        "󰁍 Back")
            if [ ${#MENU_STACK[@]} -gt 0 ]; then
                CURRENT_MENU="${MENU_STACK[-1]}"
                unset 'MENU_STACK[-1]'
            fi
            generate_menu
            ;;
        *)
            generate_menu
            ;;
    esac
}

# Modi interface
if [ -z "$@" ]; then
    # Initial call - generate menu
    generate_menu
else
    # Selection made or info request
    if [ "$ROFI_RETV" = "1" ]; then
        # Item selected
        handle_selection "$@"
    elif [ "$ROFI_RETV" = "0" ]; then
        # Just generating list or showing info
        # Check if requesting info for an item
        if [ -n "${DESCRIPTIONS[$@]}" ]; then
            echo -en "\0message\x1f${DESCRIPTIONS[$@]}\n"
        fi
        generate_menu
    fi
fi
