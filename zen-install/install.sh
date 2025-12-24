#!/bin/bash
set -e

ZEN_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$ZEN_DIR/lib/helpers.sh"

clear
echo "====================================="
echo "   Zen Installer v1.9.1"
echo "====================================="
echo "1. Full install (recommended)"
echo "2. Waybar"
echo "3. Rofi"
echo "4. SwayNC"
echo "5. Hyprlock"
echo "6. Neovim"
echo "7. Wlogout"
echo "8. Wallpaper solution"
echo "9. Starship"
echo "0. GTK Themes"
echo "q. Quit"
echo
read -p "Choose: " choice

case "$choice" in
  1)
    bash "$ZEN_DIR/core/base.sh"
    bash "$ZEN_DIR/core/services.sh"
    bash "$ZEN_DIR/config/apply.sh"
    ;;
  2) bash "$ZEN_DIR/components/waybar.sh" ;;
  3) bash "$ZEN_DIR/components/rofi.sh" ;;
  4) bash "$ZEN_DIR/components/swaync.sh" ;;
  5) bash "$ZEN_DIR/components/hyprlock.sh" ;;
  6) bash "$ZEN_DIR/components/nvim.sh" ;;
  7) bash "$ZEN_DIR/components/wlogout.sh" ;;
  8) bash "$ZEN_DIR/components/wallpaper.sh" ;;
  9) bash "$ZEN_DIR/components/starship.sh" ;;
  0) bash "$ZEN_DIR/themes/gtk.sh" ;;
  q) exit 0 ;;
  *) echo "Invalid choice"; sleep 1 ;;
esac
