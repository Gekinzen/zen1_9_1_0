#!/bin/bash
set -e

ZEN_DIR="$(cd "$(dirname "$0")/.." && pwd)"
source "$ZEN_DIR/lib/helpers.sh"

DOTFILES_ROOT="$(detect_dotfiles_root)"

log "Installing Rofi (optional)..."

yay -S --needed rofi rofi-emoji rofi-calc

if [[ -d "$DOTFILES_ROOT/.config/rofi" ]]; then
  mkdir -p ~/.config/rofi
  rsync -a "$DOTFILES_ROOT/.config/rofi/" ~/.config/rofi/
  log "Rofi config copied."
else
  warn "No Rofi config found — skipping."
fi
