#!/bin/bash

THEME_DIR="/usr/share/sddm/themes/hyprland-glass"

# Source pywal colors
source ~/.cache/wal/colors.sh

# Get current wallpaper
WALLPAPER=$(cat ~/.cache/wal/wal)

# Copy wallpaper to SDDM theme
sudo cp "$WALLPAPER" "$THEME_DIR/background.jpg"

# Update theme.conf with pywal colors
sudo tee "$THEME_DIR/theme.conf" > /dev/null << CONF
[General]
Background="background.jpg"
FormPosition="right"
FullBlur="true"
PartialBlur="true"
MainColor="$color12"
AccentColor="$color9"
BackgroundColor="$color0"

[Design]
Font="CodeNewRoman Nerd Font"
FontSize="12"
Padding="50"

[Components]
UserPicture="true"
SessionButton="true"
SuspendButton="true"
RebootButton="true"
ShutdownButton="true"
CONF

# Update Main.qml with pywal colors
sudo sed -i "s/property string accentColor: .*/property string accentColor: \"$color12\"/" "$THEME_DIR/Main.qml"
sudo sed -i "s/property string backgroundColor: .*/property string backgroundColor: \"$color0\"/" "$THEME_DIR/Main.qml"
sudo sed -i "s/property string textColor: .*/property string textColor: \"$foreground\"/" "$THEME_DIR/Main.qml"

notify-send "SDDM Theme" "Synced with pywal colors" -i preferences-desktop-theme
