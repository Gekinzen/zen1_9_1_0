#!/bin/bash

# SINGLE INSTANCE CHECK
LOCK_FILE="/tmp/keybinding-viewer.lock"
if [ -f "$LOCK_FILE" ]; then
    PID=$(cat "$LOCK_FILE")
    if ps -p "$PID" > /dev/null 2>&1; then
        echo "Keybinding viewer already open - closing..."
        kill "$PID" 2>/dev/null
        rm -f "$LOCK_FILE"
        pkill -f "wofi.*Keybindings"
        exit 0
    fi
fi
echo $$ > "$LOCK_FILE"
trap "rm -f $LOCK_FILE" EXIT

# Create detailed keybindings list
KEYBINDINGS=$(cat << 'EOF'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🪟  WINDOW MANAGEMENT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SUPER + Q                Kill Active Window
SUPER + B                Open Terminal (Kitty)
SUPER + E                Open File Manager (Thunar)
SUPER + V                Toggle Floating Mode
SUPER + P                Toggle Pseudo Tiling
SUPER + J                Toggle Split Direction
SUPER + F                Toggle Fullscreen
SUPER + M                Exit Hyprland

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀  LAUNCHERS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SUPER + R                Simple Wofi Search
ALT + SPACE              App Grid Launcher (Icons)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🎯  FOCUS MOVEMENT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SUPER + ←/→/↑/↓         Move Focus Between Windows

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📦  WINDOW MOVEMENT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
ALT + ←/→/↑/↓           Move Window Position

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🏢  WORKSPACES
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SUPER + 1-9, 0          Switch to Workspace 1-10
SUPER + SHIFT + 1-9, 0  Move Window to Workspace 1-10
SUPER + S               Toggle Special Workspace
SUPER + SHIFT + S       Move to Special Workspace

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📂  SCRATCHPADS (PYPR)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SUPER + SPACE           Toggle Terminal Scratchpad
SUPER + G               Toggle Music Player
SUPER + T               Toggle Taskbar

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚙️  SYSTEM SETTINGS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SUPER + SHIFT + A       System Settings Menu
SUPER + SHIFT + O       Opacity Settings
SUPER + SHIFT + W       Wlogout Wallpaper Toggle
SUPER + SHIFT + K       View Keybindings (This)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔧  SYSTEM TOOLS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
ALT + TAB               Power Menu (Wlogout)
SUPER + L               Lock Screen (Hyprlock)
PRINT                   Screenshot Window
CTRL + PRINT            Screenshot Region
ALT + PRINT             Screenshot Active Output

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🎨  CUSTOM SCRIPTS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
ALT + W                 Change Wallpaper
ALT + A                 Refresh Waybar
ALT + B                 Select Waybar Style
ALT + R                 Refresh Notifications

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔊  MEDIA CONTROLS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
F1                      Volume Up
F2                      Volume Down
F3                      Mute Audio
F4                      Mute Microphone
F5                      Brightness Down
F6                      Brightness Up
F7                      Play/Pause
F8                      Next Track
F9                      Previous Track

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🖱️  MOUSE BINDINGS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SUPER + LEFT CLICK      Move Window
SUPER + RIGHT CLICK     Resize Window
EOF
)

# Show in wofi with proper formatting
echo "$KEYBINDINGS" | wofi --dmenu \
    --prompt "Hyprland Keybindings" \
    --width 800 \
    --height 600 \
    --style ~/.config/wofi/menu-style.css \
    --no-actions

rm -f "$LOCK_FILE"
