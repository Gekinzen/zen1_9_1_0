#!/bin/bash
set -e

ZEN_DIR="$(cd "$(dirname "$0")/.." && pwd)"
source "$ZEN_DIR/lib/helpers.sh"

DOTFILES_ROOT="$(detect_dotfiles_root)"

yay -S --needed starship

rsync -a "$DOTFILES/.config/starship.toml" ~/.config/

echo "[Zen] Starship installed."
