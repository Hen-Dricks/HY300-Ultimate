#!/usr/bin/env bash
set -Eeuo pipefail
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
source "$SCRIPT_DIR/lib/common.sh"

required=(adb sha256sum file python3)
optional=(lpdump lpunpack lpmake simg2img img2simg e2fsck resize2fs mount umount docker)

log "Checking required tools"
for cmd in "${required[@]}"; do
  require_cmd "$cmd"
  printf '  %-14s OK\n' "$cmd"
done

log "Checking optional tools"
for cmd in "${optional[@]}"; do
  if command -v "$cmd" >/dev/null 2>&1; then
    printf '  %-14s OK\n' "$cmd"
  else
    printf '  %-14s MISSING\n' "$cmd"
  fi
done

log "Host check completed"
