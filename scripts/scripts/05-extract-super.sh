#!/usr/bin/env bash
set -Eeuo pipefail
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
source "$SCRIPT_DIR/lib/common.sh"
require_cmd lpunpack
require_cmd sha256sum

IMAGE=${1:-}
OUT=${2:-}
[[ -f "$IMAGE" && -n "$OUT" ]] || die "Usage: $0 SUPER_IMAGE OUTPUT_DIR"
[[ ! -e "$OUT" || -z "$(find "$OUT" -mindepth 1 -maxdepth 1 2>/dev/null)" ]] || die "Output directory is not empty: $OUT"
ensure_dir "$OUT"

log "Extracting logical partitions"
lpunpack "$IMAGE" "$OUT"
find "$OUT" -type f -name '*.img' -print0 | sort -z | xargs -0 sha256sum > "$OUT/SHA256SUMS"
log "Extraction completed in $OUT"
