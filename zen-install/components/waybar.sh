#!/bin/bash
set -e

ZEN_DIR="$(cd "$(dirname "$0")/.." && pwd)"
source "$ZEN_DIR/lib/helpers.sh"

DOTFILES_ROOT="$(detect_dotfiles_root)"

yay -S --needed waybar hyprpicker otf-codenewroman-nerd

rsync -a "$DOTFILES/.config/waybar/" ~/.config/waybar/

echo "[Zen] Waybar installed."
