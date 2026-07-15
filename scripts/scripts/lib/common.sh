#!/usr/bin/env bash
set -Eeuo pipefail

log() { printf '[INFO] %s\n' "$*"; }
warn() { printf '[WARN] %s\n' "$*" >&2; }
die() { printf '[ERROR] %s\n' "$*" >&2; exit 1; }
require_cmd() { command -v "$1" >/dev/null 2>&1 || die "Missing required command: $1"; }
ensure_dir() { mkdir -p "$1"; }
confirm() {
  local prompt=${1:-"Continue?"}
  read -r -p "$prompt [y/N] " answer
  [[ "$answer" =~ ^[Yy]$ ]] || die "Cancelled."
}
abs_path() {
  python3 - "$1" <<'PY'
import os, sys
print(os.path.abspath(sys.argv[1]))
PY
}
