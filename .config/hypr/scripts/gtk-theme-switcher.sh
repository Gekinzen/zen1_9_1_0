#!/bin/bash

# Theme directories
THEME_DIR="/usr/share/themes"
ICON_DIR="/usr/share/icons"
USER_THEME_DIR="$HOME/.themes"
USER_ICON_DIR="$HOME/.icons"

# Rofi picker function
pick_theme() {
    echo "$(printf '%s\n' "$@" | rofi -dmenu -p "$1")"
}

# Collect lists
gtk_themes=$(ls "$THEME_DIR" "$USER_THEME_DIR" 2>/dev/null | sort -u)
icon_themes=$(ls "$ICON_DIR" "$USER_ICON_DIR" 2>/dev/null | sort -u)
cursor_themes=$(grep -l "cursor" -R "$ICON_DIR" "$USER_ICON_DIR" 2>/dev/null | sed 's/.*\/icons\///;s/\/.*//' | sort -u)

# Main Menu
choice=$(printf "GTK Theme\nIcon Theme\nCursor Theme" | rofi -dmenu -p "Select Option")

case "$choice" in

    "GTK Theme")
        theme=$(printf '%s\n' $gtk_themes | rofi -dmenu -p "Select GTK Theme")
        [ -z "$theme" ] && exit

        mkdir -p ~/.config/gtk-3.0 ~/.config/gtk-4.0

        # apply GTK3
        crudini --set ~/.config/gtk-3.0/settings.ini Settings gtk-theme-name "$theme"
        # apply GTK4
        crudini --set ~/.config/gtk-4.0/settings.ini Settings gtk-theme-name "$theme"

        notify-send "GTK Theme Applied" "$theme"
    ;;

    "Icon Theme")
        icon=$(printf '%s\n' $icon_themes | rofi -dmenu -p "Select Icon Theme")
        [ -z "$icon" ] && exit

        crudini --set ~/.config/gtk-3.0/settings.ini Settings gtk-icon-theme-name "$icon"
        notify-send "Icon Theme Applied" "$icon"
    ;;

    "Cursor Theme")
        cursor=$(printf '%s\n' $cursor_themes | rofi -dmenu -p "Select Cursor Theme")
        [ -z "$cursor" ] && exit

        crudini --set ~/.config/gtk-3.0/settings.ini Settings gtk-cursor-theme-name "$cursor"

        echo "env = XCURSOR_THEME,$cursor" > ~/.config/hypr/cursor.conf

        notify-send "Cursor Theme Applied" "$cursor"
    ;;

esac

# Reload Hyprland cursor
hyprctl reload >/dev/null 2>&1
