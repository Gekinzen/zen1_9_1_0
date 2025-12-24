#!/bin/bash

# Get cursor theme and size from GTK settings
CURSOR_THEME=$(grep "gtk-cursor-theme-name" ~/.config/gtk-3.0/settings.ini | cut -d'=' -f2)
CURSOR_SIZE=$(grep "gtk-cursor-theme-size" ~/.config/gtk-3.0/settings.ini | cut -d'=' -f2)

# Apply to Hyprland immediately
hyprctl setcursor $CURSOR_THEME $CURSOR_SIZE

# Reload GTK applications
gsettings set org.gnome.desktop.interface cursor-theme "$CURSOR_THEME"
gsettings set org.gnome.desktop.interface cursor-size $CURSOR_SIZE

# Restart Waybar to apply changes
pkill waybar
waybar &

notify-send "Cursor Applied" "Theme: $CURSOR_THEME, Size: $CURSOR_SIZE"
