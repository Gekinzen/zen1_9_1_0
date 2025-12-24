#!/bin/bash
set -e

ZEN_DIR="$(cd "$(dirname "$0")/.." && pwd)"
source "$ZEN_DIR/lib/helpers.sh"

DOTFILES_ROOT="$(detect_dotfiles_root)"

log "Dotfiles root detected at: $DOTFILES_ROOT"

# Safety checks
if [[ ! -d "$DOTFILES_ROOT/.config" ]]; then
  error "Dotfiles .config folder not found in $DOTFILES_ROOT"
fi

# Ensure rsync exists
require_cmd rsync

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
