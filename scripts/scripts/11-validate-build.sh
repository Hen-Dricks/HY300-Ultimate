#!/usr/bin/env bash
set -Eeuo pipefail
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
source "$SCRIPT_DIR/lib/common.sh"
require_cmd lpdump
require_cmd lpunpack
require_cmd sha256sum
require_cmd file

IMAGE=${1:-}
OUT=${2:-"output/validation-$(date +%Y%m%d-%H%M%S)"}
[[ -f "$IMAGE" ]] || die "Usage: $0 SUPER_IMAGE [OUTPUT_DIR]"
ensure_dir "$OUT/extracted"

file "$IMAGE" | tee "$OUT/file.txt"
sha256sum "$IMAGE" | tee "$OUT/SHA256SUMS"
lpdump "$IMAGE" | tee "$OUT/lpdump.txt"
lpunpack "$IMAGE" "$OUT/extracted"

if command -v e2fsck >/dev/null 2>&1; then
  for img in "$OUT"/extracted/*.img; do
    [[ -e "$img" ]] || continue
    log "Checking $(basename "$img")"
    e2fsck -fn "$img" > "$img.e2fsck.txt" 2>&1 || {
      rc=$?
      # e2fsck bit 1 means errors corrected; with -n it may report issues. Keep report and fail for serious codes.
      (( rc <= 4 )) || die "Serious filesystem error in $img (e2fsck rc=$rc)"
    }
  done
else
  warn "e2fsck not found; filesystem checks skipped"
fi

find "$OUT/extracted" -type f -name '*.img' -print0 | sort -z | xargs -0 sha256sum > "$OUT/extracted/SHA256SUMS"
log "Validation completed in $OUT"
