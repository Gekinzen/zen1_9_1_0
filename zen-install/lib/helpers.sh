#!/bin/bash
set -e

ZEN_PREFIX="[Zen]"

log() {
  echo -e "${ZEN_PREFIX} $1"
}

warn() {
  echo -e "${ZEN_PREFIX} ⚠ $1"
}

error() {
  echo -e "${ZEN_PREFIX} ❌ $1"
  exit 1
}

ask_yes_no() {
  local prompt="$1"
  local default="${2:-y}"

  read -p "$prompt (y/n, default: $default): " choice
  choice="${choice:-$default}"

  [[ "$choice" == "y" || "$choice" == "Y" ]]
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || error "Required command not found: $1"
}

detect_dotfiles_root() {
  local script_dir
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
  local root_dir
  root_dir="$(cd "$script_dir/.." && pwd)"

  if [[ -d "$root_dir/.config" ]]; then
    echo "$root_dir"
  else
    error "Could not detect dotfiles root (missing .config folder)"
  fi
}
