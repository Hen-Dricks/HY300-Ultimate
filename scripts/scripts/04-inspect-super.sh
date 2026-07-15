#!/usr/bin/env bash
set -Eeuo pipefail
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
source "$SCRIPT_DIR/lib/common.sh"
require_cmd lpdump
require_cmd sha256sum
require_cmd file

IMAGE=${1:-}
OUT=${2:-"output/super-inspection"}
[[ -f "$IMAGE" ]] || die "Usage: $0 SUPER_IMAGE [OUTPUT_DIR]"
ensure_dir "$OUT"

file "$IMAGE" | tee "$OUT/file.txt"
sha256sum "$IMAGE" | tee "$OUT/SHA256SUMS"
lpdump "$IMAGE" | tee "$OUT/lpdump.txt"
log "Inspection completed in $OUT"
