#!/bin/bash
set -e

ZEN_DIR="$(cd "$(dirname "$0")/.." && pwd)"
source "$ZEN_DIR/lib/helpers.sh"

DOTFILES_ROOT="$(detect_dotfiles_root)"

log "Dotfiles root detected at: $DOTFILES_ROOT"

# Ensure rsync exists
if ! command -v rsync >/dev/null 2>&1; then
  log "rsync not found, installing..."
  yay -S --needed rsync
fi

# Backup existing ~/.config (only if not empty)
if [[ -d "$HOME/.config" && "$(ls -A "$HOME/.config")" ]]; then
  log "Backing up existing ~/.config..."
  mkdir -p "$HOME/.config_backup"
  rsync -a "$HOME/.config/" "$HOME/.config_backup/"
else
  log "~/.config is empty or new — skipping backup."
fi

# Apply configs
log "Applying configs from dotfiles..."
rsync -a "$DOTFILES_ROOT/.config/" "$HOME/.config/"

log "Configs applied successfully."
