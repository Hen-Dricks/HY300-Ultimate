#!/usr/bin/env bash
set -Eeuo pipefail
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
source "$SCRIPT_DIR/lib/common.sh"
require_cmd mount

MODE=ro
if [[ ${1:-} == "--rw" ]]; then MODE=rw; shift; fi
IMAGE=${1:-}
MOUNT_POINT=${2:-}
[[ -f "$IMAGE" && -n "$MOUNT_POINT" ]] || die "Usage: $0 [--rw] IMAGE MOUNT_POINT"
ensure_dir "$MOUNT_POINT"

if [[ $MODE == rw ]]; then
  warn "Read-write mounting can modify the image"
  confirm "Mount $IMAGE read-write?"
fi
sudo mount -o "loop,$MODE" "$IMAGE" "$MOUNT_POINT"
log "Mounted $IMAGE at $MOUNT_POINT ($MODE)"
