#!/bin/bash

# =====================================
# Zen pywal Controller (v1-safe)
# =====================================

ZEN_STATE_DIR="$HOME/.config/zen/state"
PYWAL_STATE_FILE="$ZEN_STATE_DIR/pywal.json"

# Ensure state file exists
ensure_pywal_state() {
  mkdir -p "$ZEN_STATE_DIR"

  if [[ ! -f "$PYWAL_STATE_FILE" ]]; then
    echo '{ "enabled": false }' > "$PYWAL_STATE_FILE"
  fi
}

# Check if pywal is enabled
pywal_enabled() {
  ensure_pywal_state
  jq -e '.enabled == true' "$PYWAL_STATE_FILE" >/dev/null 2>&1
}

# Apply wallpaper respecting pywal state
apply_wallpaper() {
  local image="$1"

  if [[ ! -f "$image" ]]; then
    echo "[Zen] ❌ Wallpaper not found: $image"
    return 1
  fi

  if pywal_enabled; then
    echo "[Zen] 🎨 Applying wallpaper with pywal"
    wal -i "$image"
  else
    echo "[Zen] 🖼️ Applying wallpaper only (pywal disabled)"
    swww img "$image"
  fi
}
