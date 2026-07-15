#!/usr/bin/env bash
set -Eeuo pipefail
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
source "$SCRIPT_DIR/lib/common.sh"

MODE=${1:-}
IN=${2:-}
OUT=${3:-}
[[ -n "$MODE" && -f "$IN" && -n "$OUT" ]] || die "Usage: $0 sparse-to-raw|raw-to-sparse INPUT OUTPUT"
[[ ! -e "$OUT" ]] || die "Output already exists: $OUT"

case "$MODE" in
  sparse-to-raw) require_cmd simg2img; simg2img "$IN" "$OUT" ;;
  raw-to-sparse) require_cmd img2simg; img2simg "$IN" "$OUT" ;;
  *) die "Unknown mode: $MODE" ;;
esac
log "Created $OUT"
