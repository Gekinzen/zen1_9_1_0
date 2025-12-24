#!/bin/bash
set -e

ZEN_DIR="$(cd "$(dirname "$0")/.." && pwd)"
source "$ZEN_DIR/lib/helpers.sh"

DOTFILES_ROOT="$(detect_dotfiles_root)"

echo "[Zen] Wofi (optional) setup..."

yay -S --needed wofi

if [[ -d "$DOTFILES/.config/wofi" ]]; then
  mkdir -p ~/.config/wofi
  rsync -a "$DOTFILES/.config/wofi/" ~/.config/wofi/
  echo "[Zen] Wofi config copied."
else
  echo "[Zen] No Wofi config found — skipping."
fi
