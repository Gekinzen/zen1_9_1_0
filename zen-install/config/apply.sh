#!/bin/bash
set -e

ZEN_DIR="$(cd "$(dirname "$0")/.." && pwd)"
source "$ZEN_DIR/lib/helpers.sh"

DOTFILES_ROOT="$(detect_dotfiles_root)"

log "Backing up ~/.config..."
mkdir -p ~/.config_backup
rsync -a ~/.config/ ~/.config_backup/

log "Applying configs from dotfiles..."
rsync -a "$DOTFILES_ROOT/.config/" ~/.config/

log "Done."
