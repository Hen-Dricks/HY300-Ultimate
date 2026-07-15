#!/usr/bin/env bash
set -Eeuo pipefail
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
source "$SCRIPT_DIR/lib/common.sh"
require_cmd adb
require_cmd sha256sum

OUT=${1:-}
shift || true
[[ -n "$OUT" ]] || die "Usage: $0 OUTPUT_DIR partition [partition ...]"
[[ $# -gt 0 ]] || die "Provide at least one partition name"
ensure_dir "$OUT"
adb get-state >/dev/null 2>&1 || die "No authorized ADB device detected"

REMOTE_DIR="/data/local/tmp/hy300-dumps-$$"
adb shell mkdir -p "$REMOTE_DIR"
trap 'adb shell rm -rf "$REMOTE_DIR" >/dev/null 2>&1 || true' EXIT

for part in "$@"; do
  [[ "$part" =~ ^[A-Za-z0-9._-]+$ ]] || die "Unsafe partition name: $part"
  remote="$REMOTE_DIR/$part.img"
  local_img="$OUT/$part.img"
  log "Dumping $part"
  adb shell "test -e /dev/block/by-name/$part" || die "Partition not found: $part"
  adb shell "dd if=/dev/block/by-name/$part of=$remote bs=4M" || die "Dump failed: $part"
  adb pull "$remote" "$local_img" >/dev/null
  adb shell rm -f "$remote"
  sha256sum "$local_img" | tee "$local_img.sha256"
done

log "Partition dumps completed"
