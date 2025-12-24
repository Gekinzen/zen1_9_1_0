#!/bin/bash

# SINGLE INSTANCE CHECK
LOCK_FILE="/tmp/keybinding-viewer.lock"
if [ -f "$LOCK_FILE" ]; then
    PID=$(cat "$LOCK_FILE")
    if ps -p "$PID" > /dev/null 2>&1; then
        echo "Keybinding viewer already open - closing..."
        kill "$PID" 2>/dev/null
        rm -f "$LOCK_FILE"
        pkill -f "rofi.*Keybindings"
        exit 0
    fi
fi
echo $$ > "$LOCK_FILE"
trap "rm -f $LOCK_FILE" EXIT

# Create detailed keybindings list
KEYBINDINGS=$(cat << 'EOF'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                      🪟  WINDOW MANAGEMENT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  SUPER + Q                      Kill Active Window
  SUPER + B                      Open Terminal (Kitty)
  SUPER + E                      Open File Manager (Thunar)
  SUPER + V                      Toggle Floating Mode
  SUPER + P                      Toggle Pseudo Tiling
  SUPER + J                      Toggle Split Direction
  SUPER + F                      Toggle Fullscreen
  SUPER + M                      Exit Hyprland

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                           🚀  LAUNCHERS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  SUPER + R                      Simple Search Menu
  ALT + SPACE                    App Grid Launcher (Icons)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                         🎯  FOCUS MOVEMENT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  SUPER + ← / → / ↑ / ↓         Move Focus Between Windows

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                        📦  WINDOW MOVEMENT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ALT + ← / → / ↑ / ↓           Move Window Position

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                          🏢  WORKSPACES
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  SUPER + 1-9, 0                 Switch to Workspace 1-10
  SUPER + SHIFT + 1-9, 0         Move Window to Workspace 1-10
  SUPER + S                      Toggle Special Workspace
  SUPER + SHIFT + S              Move to Special Workspace
  SUPER + SHIFT + X              Remove Empty Workspaces

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                      📂  SCRATCHPADS (PYPR)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  SUPER + SPACE                  Toggle Terminal Scratchpad
  SUPER + G                      Toggle Music Player
  SUPER + T                      Toggle Taskbar

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                       ⚙️  SYSTEM SETTINGS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  SUPER + SHIFT + A              System Settings Menu
  SUPER + SHIFT + O              Opacity Settings
  SUPER + SHIFT + W              Wlogout Wallpaper Toggle
  SUPER + SHIFT + K              View Keybindings (This)
  SUPER + SHIFT + D              Display Settings

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                         🔧  SYSTEM TOOLS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ALT + TAB                      Power Menu (Wlogout)
  SUPER + L                      Lock Screen (Hyprlock)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                        📸  SCREENSHOTS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  PRINT                          Screenshot Window
  CTRL + PRINT                   Screenshot Region
  ALT + PRINT                    Screenshot Active Output

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                       🎨  CUSTOM SCRIPTS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ALT + W                        Change Wallpaper
  ALT + A                        Refresh Waybar
  ALT + B                        Select Waybar Style
  ALT + R                        Refresh Notifications

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                       🔊  MEDIA CONTROLS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  XF86AudioRaiseVolume           Volume Up
  XF86AudioLowerVolume           Volume Down
  XF86AudioMute                  Mute Audio
  XF86AudioMicMute               Mute Microphone
  XF86MonBrightnessUp            Brightness Up
  XF86MonBrightnessDown          Brightness Down
  XF86AudioPlay                  Play/Pause
  XF86AudioNext                  Next Track
  XF86AudioPrev                  Previous Track

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                        🖱️  MOUSE BINDINGS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  SUPER + LEFT CLICK             Move Window
  SUPER + RIGHT CLICK            Resize Window
EOF
)

# Show in rofi with proper formatting
echo "$KEYBINDINGS" | rofi -dmenu -i \
    -p "Hyprland Keybindings" \
    -theme ~/.config/rofi/keybindings.rasi \
    -no-custom

rm -f "$LOCK_FILE"