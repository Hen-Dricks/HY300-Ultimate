#!/usr/bin/env bash
set -Eeuo pipefail
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
source "$SCRIPT_DIR/lib/common.sh"
require_cmd umount

MOUNT_POINT=${1:-}
[[ -n "$MOUNT_POINT" ]] || die "Usage: $0 MOUNT_POINT"
sync
sudo umount "$MOUNT_POINT"
log "Unmounted $MOUNT_POINT"
