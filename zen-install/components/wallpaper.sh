#!/bin/bash
set -e

# -------------------------------------------------
# Zen Wallpaper Script (pywal-aware)
# -------------------------------------------------

# Locate zen-install
ZEN_DIR="$(cd "$(dirname "$0")/../../../zen-install" && pwd)"

# Load helpers + pywal logic
source "$ZEN_DIR/lib/helpers.sh"
source "$ZEN_DIR/lib/pywal.sh"

# Detect dotfiles root (parent of .config + zen-install)
DOTFILES_ROOT="$(detect_dotfiles_root)"

# Default wallpaper (change if you want)
WALLPAPER="$DOTFILES_ROOT/wallpapers/default.jpg"

# Safety check
if [[ ! -f "$WALLPAPER" ]]; then
  warn "Wallpaper not found: $WALLPAPER"
  exit 1
fi

# Apply wallpaper (pywal ON/OFF respected)
apply_wallpaper "$WALLPAPER"

log "Wallpaper applied successfully."
