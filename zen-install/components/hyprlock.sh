#!/bin/bash
set -e

ZEN_DIR="$(cd "$(dirname "$0")/.." && pwd)"
source "$ZEN_DIR/lib/helpers.sh"

DOTFILES_ROOT="$(detect_dotfiles_root)"

yay -S --needed hyprlock

rsync -a "$DOTFILES/.config/hypr/hyprlock.conf" ~/.config/hypr/

echo "[Zen] Hyprlock installed."
