#!/usr/bin/env bash
set -Eeuo pipefail
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
source "$SCRIPT_DIR/lib/common.sh"
require_cmd lpmake
require_cmd stat

CONFIG=${1:-}
IMAGES_DIR=${2:-}
OUTPUT=${3:-}
[[ -f "$CONFIG" && -d "$IMAGES_DIR" && -n "$OUTPUT" ]] || die "Usage: $0 CONFIG_ENV IMAGES_DIR OUTPUT_SUPER"
[[ ! -e "$OUTPUT" ]] || die "Output already exists: $OUTPUT"

# shellcheck disable=SC1090
source "$CONFIG"
: "${DEVICE_SIZE:?Set DEVICE_SIZE}"
: "${METADATA_SIZE:?Set METADATA_SIZE}"
: "${METADATA_SLOTS:?Set METADATA_SLOTS}"
: "${BLOCK_SIZE:?Set BLOCK_SIZE}"
: "${SUPER_NAME:?Set SUPER_NAME}"
: "${GROUP_NAME:?Set GROUP_NAME}"
: "${GROUP_SIZE:?Set GROUP_SIZE}"
: "${PARTITIONS:?Set PARTITIONS}"

(( DEVICE_SIZE > 0 && GROUP_SIZE > 0 )) || die "DEVICE_SIZE and GROUP_SIZE must be greater than zero"
args=(--metadata-size "$METADATA_SIZE" --metadata-slots "$METADATA_SLOTS" --device "$SUPER_NAME:$DEVICE_SIZE" --group "$GROUP_NAME:$GROUP_SIZE" --block-size "$BLOCK_SIZE" --output "$OUTPUT")
[[ ${SPARSE_OUTPUT:-true} == true ]] && args+=(--sparse)

for part in $PARTITIONS; do
  img="$IMAGES_DIR/$part.img"
  [[ -f "$img" ]] || die "Missing image: $img"
  size_var="PART_${part}_SIZE"
  attr_var="PART_${part}_ATTR"
  declared_size=${!size_var:-0}
  attrs=${!attr_var:-readonly}
  actual_size=$(stat -c %s "$img" 2>/dev/null || stat -f %z "$img")
  (( declared_size >= actual_size )) || die "$part image ($actual_size bytes) exceeds declared size ($declared_size bytes)"
  args+=(--partition "$part:$attrs:$declared_size:$GROUP_NAME" --image "$part=$img")
done

log "Building $OUTPUT"
lpmake "${args[@]}"
log "Build completed"
