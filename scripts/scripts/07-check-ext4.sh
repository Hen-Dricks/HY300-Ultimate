#!/usr/bin/env bash
set -Eeuo pipefail
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
source "$SCRIPT_DIR/lib/common.sh"
require_cmd e2fsck

REPAIR=0
if [[ ${1:-} == "--repair" ]]; then REPAIR=1; shift; fi
IMAGE=${1:-}
[[ -f "$IMAGE" ]] || die "Usage: $0 [--repair] IMAGE"

if (( REPAIR )); then
  warn "Repair mode may modify the image"
  confirm "Run e2fsck repair on $IMAGE?"
  e2fsck -fy "$IMAGE"
else
  e2fsck -fn "$IMAGE"
fi
