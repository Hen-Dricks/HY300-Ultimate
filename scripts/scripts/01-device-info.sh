#!/usr/bin/env bash
set -Eeuo pipefail
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
source "$SCRIPT_DIR/lib/common.sh"
require_cmd adb

OUT=${1:-"output/device-info-$(date +%Y%m%d-%H%M%S)"}
ensure_dir "$OUT"

adb get-state >/dev/null 2>&1 || die "No authorized ADB device detected"
log "Collecting device information in $OUT"

adb devices -l > "$OUT/adb-devices.txt"
adb shell getprop > "$OUT/getprop.txt"
adb shell uname -a > "$OUT/uname.txt"
adb shell cat /proc/cpuinfo > "$OUT/cpuinfo.txt" || true
adb shell cat /proc/meminfo > "$OUT/meminfo.txt" || true
adb shell cat /proc/partitions > "$OUT/proc-partitions.txt" || true
adb shell ls -l /dev/block/by-name > "$OUT/block-by-name.txt" || true
adb shell mount > "$OUT/mount.txt" || true
adb shell df -h > "$OUT/df.txt" || true
adb shell ps -A > "$OUT/processes.txt" || true
adb shell service list > "$OUT/services.txt" || true
adb shell pm list packages -f > "$OUT/packages.txt" || true

log "Device inventory completed"
