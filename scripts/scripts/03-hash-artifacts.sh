#!/usr/bin/env bash
set -Eeuo pipefail
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
source "$SCRIPT_DIR/lib/common.sh"
require_cmd sha256sum

TARGET=${1:-}
OUT=${2:-SHA256SUMS}
[[ -n "$TARGET" ]] || die "Usage: $0 FILE_OR_DIRECTORY [OUTPUT_FILE]"

if [[ -f "$TARGET" ]]; then
  sha256sum "$TARGET" > "$OUT"
elif [[ -d "$TARGET" ]]; then
  find "$TARGET" -type f ! -name "$(basename "$OUT")" -print0 | sort -z | xargs -0 sha256sum > "$OUT"
else
  die "Target does not exist: $TARGET"
fi
log "Wrote $OUT"
