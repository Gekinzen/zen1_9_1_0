#!/bin/bash
set -e

ZEN_DIR="$(cd "$(dirname "$0")/.." && pwd)"
source "$ZEN_DIR/lib/helpers.sh"

DOTFILES_ROOT="$(detect_dotfiles_root)"

yay -S --needed neovim lazygit

rsync -a "$DOTFILES/.config/nvim/" ~/.config/nvim/

echo "[Zen] Neovim installed."
