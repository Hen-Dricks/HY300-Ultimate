#!/usr/bin/env bash
set -Eeuo pipefail

# HY300 Ultimate device collector
# Default mode is PUBLIC: obvious identifiers are redacted from copied text logs.
# Use --private only for a local, non-published archive.

MODE="public"
SERIAL=""
OUT_ROOT=""
PULL_APKS=1
RUN_RE=1
FULL_DUMPSYS=0
COLLECT_TIMEOUT="${COLLECT_TIMEOUT:-90}"
LOGCAT_LINES="${LOGCAT_LINES:-20000}"

usage() {
  cat <<'EOF'
Usage:
  ./device/collect-all.sh [options]

Options:
  --serial SERIAL       Select a specific ADB device.
  --output PATH         Repository root containing assets/.
  --public              Redact common identifiers (default).
  --private             Preserve raw identifiers. Do not publish blindly.
  --no-apks             Do not pull APK files.
  --no-re               Do not run apktool/JADX/strings steps.
  --full-dumpsys        Collect a full dumpsys snapshot (large).
  --timeout SECONDS     Maximum duration per collection command.
  --logcat-lines N      Number of recent logcat lines to collect.
  -h, --help            Show this help.

Examples:
  ./device/collect-all.sh
  ./device/collect-all.sh --serial 192.168.1.20:5555
  ./device/collect-all.sh --private --output "$PWD"
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --serial) SERIAL="${2:?Missing serial}"; shift 2 ;;
    --output) OUT_ROOT="${2:?Missing output path}"; shift 2 ;;
    --public) MODE="public"; shift ;;
    --private) MODE="private"; shift ;;
    --no-apks) PULL_APKS=0; shift ;;
    --no-re) RUN_RE=0; shift ;;
    --full-dumpsys) FULL_DUMPSYS=1; shift ;;
    --timeout) COLLECT_TIMEOUT="${2:?Missing timeout}"; shift 2 ;;
    --logcat-lines) LOGCAT_LINES="${2:?Missing line count}"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage; exit 2 ;;
  esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="${OUT_ROOT:-$(cd "$SCRIPT_DIR/.." && pwd)}"
ASSETS="$PROJECT_ROOT/assets"
RUN_ID="$(date -u +%Y%m%dT%H%M%SZ)"
RUN_DIR="$ASSETS/logs/runs/$RUN_ID"
RAW_DIR="$RUN_DIR/raw"
PUB_DIR="$RUN_DIR/public"
REPORT_RUN_DIR="$ASSETS/reports/runs/$RUN_ID"
RE_ROOT="$ASSETS/reverse-engineering"
TMP_DIR="$RUN_DIR/tmp"

mkdir -p "$RAW_DIR" "$PUB_DIR" "$REPORT_RUN_DIR" "$TMP_DIR"
mkdir -p \
  "$ASSETS/logs/adb" "$ASSETS/logs/boot" "$ASSETS/logs/kernel" \
  "$ASSETS/logs/services" "$ASSETS/logs/recovery" "$ASSETS/logs/ota" \
  "$ASSETS/logs/network" "$ASSETS/logs/security" "$ASSETS/logs/graphics" \
  "$ASSETS/reports/hardware" "$ASSETS/reports/software" \
  "$ASSETS/reports/partitions" "$ASSETS/reports/security" \
  "$ASSETS/reports/performance" "$ASSETS/reports/validation" \
  "$RE_ROOT/packages" "$RE_ROOT/apktool" "$RE_ROOT/jadx" \
  "$RE_ROOT/manifests" "$RE_ROOT/libraries" "$RE_ROOT/jni" \
  "$RE_ROOT/strings" "$RE_ROOT/notes"

need() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Required command not found: $1" >&2
    exit 1
  }
}
need adb
need awk
need sed
need grep
need find
need sort

ADB=(adb)
[[ -n "$SERIAL" ]] && ADB+=( -s "$SERIAL" )

copy_latest_logs() {
  echo "[9.5/9] Updating categorized latest logs..."

  # Parallel arrays (bash 3.2 compatible — no associative arrays)
  destinations=(adb boot kernel services recovery ota network security graphics media power usb partitions hardware)
  sources=(android boot kernel services recovery ota network security graphics media power usb partitions hardware)

  count=${#destinations[@]}
  i=0
  while [[ $i -lt $count ]]; do
    destination_name="${destinations[$i]}"
    source_name="${sources[$i]}"
    source_dir="$PUB_DIR/$source_name"
    destination_dir="$ASSETS/logs/$destination_name"

    rm -rf "$destination_dir"
    mkdir -p "$destination_dir"

    if [[ -d "$source_dir" ]]; then
      cp -R "$source_dir/." "$destination_dir/" 2>/dev/null || true
    fi

    i=$((i + 1))
  done
}

echo "[1/9] Checking ADB connection..."
"${ADB[@]}" get-state >/dev/null
DEVICE_SERIAL="$("${ADB[@]}" get-serialno 2>/dev/null || true)"
echo "$DEVICE_SERIAL" > "$RAW_DIR/adb-serial.txt"

safe_name() {
  printf '%s' "$1" | tr '/: ' '___' | tr -cd '[:alnum:]_.-'
}

capture() {
  local rel="$1"
  shift

  local dst="$RAW_DIR/$rel"
  local command_pid watchdog_pid

  mkdir -p "$(dirname "$dst")"

  {
    echo "# Command: $*"
    echo "# Collected UTC: $(date -u +%FT%TZ)"
    echo "# Timeout: ${COLLECT_TIMEOUT}s"
    echo
  } > "$dst"

  "$@" >> "$dst" 2>&1 &
  command_pid=$!

  (
    sleep "$COLLECT_TIMEOUT"
    if kill -0 "$command_pid" 2>/dev/null; then
      {
        echo
        echo "[COLLECTOR TIMEOUT after ${COLLECT_TIMEOUT} seconds]"
      } >> "$dst"
      kill -TERM "$command_pid" 2>/dev/null || true
      sleep 2
      kill -KILL "$command_pid" 2>/dev/null || true
    fi
  ) &
  watchdog_pid=$!

  wait "$command_pid" 2>/dev/null || true
  kill "$watchdog_pid" 2>/dev/null || true
  wait "$watchdog_pid" 2>/dev/null || true
}

shell_capture() {
  local rel="$1"; shift
  capture "$rel" "${ADB[@]}" shell "$@"
}

echo "[2/9] Collecting system, hardware, and build information..."
shell_capture hardware/uname.txt uname -a
shell_capture hardware/cpuinfo.txt cat /proc/cpuinfo
shell_capture hardware/meminfo.txt cat /proc/meminfo
shell_capture hardware/version.txt cat /proc/version
shell_capture hardware/cmdline.txt cat /proc/cmdline
shell_capture hardware/interrupts.txt cat /proc/interrupts
shell_capture hardware/devices.txt cat /proc/devices
shell_capture hardware/iomem.txt cat /proc/iomem
shell_capture hardware/modules.txt cat /proc/modules
shell_capture hardware/sys-block.txt sh -c 'for d in /sys/block/*; do echo "## $d"; cat "$d/size" 2>/dev/null; cat "$d/queue/logical_block_size" 2>/dev/null; done'
shell_capture android/getprop.txt getprop
shell_capture android/build-props.txt sh -c 'for f in /system/build.prop /vendor/build.prop /product/build.prop /odm/build.prop /system_ext/build.prop; do [ -r "$f" ] && { echo "===== $f ====="; cat "$f"; }; done'
shell_capture android/features.txt pm list features
shell_capture android/libraries.txt pm list libraries
shell_capture android/permissions.txt pm list permissions -g -f
shell_capture android/packages-all.txt pm list packages -f
shell_capture android/packages-system.txt pm list packages -s -f
shell_capture android/packages-third-party.txt pm list packages -3 -f
shell_capture android/package-installer.txt cmd package resolve-activity --brief android.intent.action.VIEW -d file:///sdcard/example.apk -t application/vnd.android.package-archive
shell_capture android/home-activity.txt cmd package resolve-activity --brief -a android.intent.action.MAIN -c android.intent.category.HOME

echo "[3/9] Collecting partitions, mounts, and filesystems..."
shell_capture partitions/by-name.txt ls -l /dev/block/by-name
shell_capture partitions/proc-partitions.txt cat /proc/partitions
shell_capture partitions/mount.txt mount
shell_capture partitions/proc-mounts.txt cat /proc/mounts
shell_capture partitions/df.txt df -h
shell_capture partitions/fstab-files.txt sh -c 'find /vendor/etc /odm/etc /system/etc /first_stage_ramdisk -maxdepth 3 -type f -iname "*fstab*" -print -exec sh -c '\''echo "===== $1 ====="; cat "$1" 2>/dev/null'\'' sh {} \; 2>/dev/null'
shell_capture partitions/dmsetup.txt sh -c 'command -v dmsetup >/dev/null && dmsetup table || true'
shell_capture partitions/lsblk.txt sh -c 'command -v lsblk >/dev/null && lsblk -f || true'

echo "[4/9] Collecting services, processes, boot, and runtime state..."
shell_capture services/processes.txt ps -A -o USER,PID,PPID,VSZ,RSS,STAT,NAME
shell_capture services/processes-selinux.txt ps -AZ
shell_capture services/service-list.txt service list
shell_capture services/activity-services.txt dumpsys activity services
shell_capture services/jobscheduler.txt dumpsys jobscheduler
shell_capture services/alarm.txt dumpsys alarm
shell_capture services/package.txt dumpsys package
shell_capture boot/boot-properties.txt sh -c 'getprop | grep -E "^\[(ro\.boot|ro\.build|ro\.product|sys\.boot)"'
shell_capture boot/init-files.txt sh -c 'find /system/etc/init /vendor/etc/init /odm/etc/init /product/etc/init /system_ext/etc/init -type f -name "*.rc" -maxdepth 3 -print 2>/dev/null'
shell_capture boot/init-daemon12138.txt sh -c 'grep -Rni "daemon12138" /system/etc/init /vendor/etc/init /odm/etc/init /product/etc/init /system_ext/etc/init 2>/dev/null || true'
capture boot/logcat.txt "${ADB[@]}" logcat -b all -d -t "$LOGCAT_LINES" -v threadtime
shell_capture kernel/dmesg.txt dmesg
shell_capture kernel/last-kmsg.txt sh -c 'cat /proc/last_kmsg 2>/dev/null || cat /sys/fs/pstore/console-ramoops* 2>/dev/null || true'

echo "[5/9] Collecting graphics, media, input, power, and sensors..."
shell_capture graphics/surfaceflinger.txt dumpsys SurfaceFlinger
shell_capture graphics/display.txt dumpsys display
shell_capture graphics/window.txt dumpsys window
shell_capture graphics/gfxinfo.txt dumpsys gfxinfo
shell_capture graphics/hardware-properties.txt sh -c 'getprop | grep -Ei "gfx|display|hdmi|keystone|focus|project"'
shell_capture media/audio.txt dumpsys audio
shell_capture media/audio-flinger.txt dumpsys media.audio_flinger
shell_capture media/media-codec.txt dumpsys media.codec
shell_capture media/media-drm.txt dumpsys media.drm
shell_capture input/input.txt dumpsys input
shell_capture input/sensors.txt dumpsys sensorservice
shell_capture power/power.txt dumpsys power
shell_capture power/battery.txt dumpsys battery
shell_capture power/thermal.txt dumpsys thermalservice
shell_capture usb/usb.txt dumpsys usb

echo "[6/9] Collecting networking and security state..."
shell_capture network/ip-address.txt ip addr
shell_capture network/ip-route.txt ip route
shell_capture network/ip-link.txt ip link
shell_capture network/sockets.txt sh -c 'ss -tunap 2>/dev/null || netstat -tunap 2>/dev/null || true'
shell_capture network/wifi.txt dumpsys wifi
shell_capture network/connectivity.txt dumpsys connectivity
shell_capture network/dns-properties.txt sh -c 'getprop | grep -i dns'
shell_capture security/selinux-mode.txt getenforce
shell_capture security/selinux-status.txt sestatus
shell_capture security/avb-properties.txt sh -c 'getprop | grep -Ei "verifiedboot|vbmeta|avb|verity"'
shell_capture security/device-policy.txt dumpsys device_policy
shell_capture security/users.txt pm list users
shell_capture security/keystore.txt dumpsys keystore2
shell_capture recovery/recovery-properties.txt sh -c 'getprop | grep -Ei "recovery|bootloader|fastboot"'
shell_capture ota/update-engine.txt dumpsys update_engine
shell_capture ota/recovery-files.txt sh -c 'find /cache/recovery /data/misc/update_engine /metadata -maxdepth 3 -type f -print 2>/dev/null | head -500'

if [[ "$FULL_DUMPSYS" -eq 1 ]]; then
  shell_capture services/dumpsys-full.txt dumpsys
fi

echo "[7/9] Pulling APKs and reverse-engineering inputs..."
if [[ "$PULL_APKS" -eq 1 ]]; then
  PACKAGE_MAP="$TMP_DIR/package-map.txt"
  "${ADB[@]}" shell pm list packages -f 2>/dev/null | sed 's/^package://' > "$PACKAGE_MAP" || true

  while IFS='=' read -r apk_path package_name; do
    [[ -z "${apk_path:-}" || -z "${package_name:-}" ]] && continue
    pkg_safe="$(safe_name "$package_name")"
    pkg_dir="$RE_ROOT/packages/$pkg_safe"
    mkdir -p "$pkg_dir/original" "$pkg_dir/metadata" "$pkg_dir/native"
    echo "$package_name" > "$pkg_dir/metadata/package-name.txt"
    echo "$apk_path" > "$pkg_dir/metadata/device-path.txt"

    "${ADB[@]}" pull "$apk_path" "$pkg_dir/original/" >/dev/null 2>&1 || true
    "${ADB[@]}" shell dumpsys package "$package_name" > "$pkg_dir/metadata/dumpsys-package.txt" 2>&1 || true

    if command -v sha256sum >/dev/null 2>&1; then
      find "$pkg_dir/original" -type f -maxdepth 1 -exec sha256sum {} \; > "$pkg_dir/metadata/SHA256SUMS.txt" 2>/dev/null || true
    elif command -v shasum >/dev/null 2>&1; then
      find "$pkg_dir/original" -type f -maxdepth 1 -exec shasum -a 256 {} \; > "$pkg_dir/metadata/SHA256SUMS.txt" 2>/dev/null || true
    fi

    apk_file="$(find "$pkg_dir/original" -maxdepth 1 -type f -name '*.apk' | head -1 || true)"
    if [[ "$RUN_RE" -eq 1 && -n "$apk_file" ]]; then
      if command -v apktool >/dev/null 2>&1; then
        apktool d -f "$apk_file" -o "$RE_ROOT/apktool/$pkg_safe" >/dev/null 2>&1 || true
        [[ -f "$RE_ROOT/apktool/$pkg_safe/AndroidManifest.xml" ]] &&
          cp "$RE_ROOT/apktool/$pkg_safe/AndroidManifest.xml" "$RE_ROOT/manifests/$pkg_safe.xml"
      fi
      if command -v jadx >/dev/null 2>&1; then
        jadx -d "$RE_ROOT/jadx/$pkg_safe" "$apk_file" >/dev/null 2>&1 || true
      fi
      if command -v unzip >/dev/null 2>&1; then
        unzip -jo "$apk_file" 'lib/*/*.so' -d "$pkg_dir/native" >/dev/null 2>&1 || true
      fi
      if command -v strings >/dev/null 2>&1; then
        strings "$apk_file" > "$RE_ROOT/strings/$pkg_safe-apk.txt" 2>/dev/null || true
        for so in "$pkg_dir"/native/*.so; do
          [[ -f "$so" ]] || continue
          strings "$so" > "$RE_ROOT/strings/$(safe_name "$(basename "$so")")-$pkg_safe.txt" 2>/dev/null || true
        done
      fi
    fi
  done < "$PACKAGE_MAP"
fi

# Pull selected native binaries/libraries relevant to the documented research.
for remote in \
  /system/bin/daemon12138 \
  /vendor/bin/daemon12138 \
  /system/lib/libprojectutils.so \
  /system/lib64/libprojectutils.so \
  /vendor/lib/librkgfx.so \
  /vendor/lib64/librkgfx.so
do
  local_name="$(safe_name "$remote")"
  "${ADB[@]}" pull "$remote" "$RE_ROOT/libraries/$local_name" >/dev/null 2>&1 || true
done

echo "[8/9] Creating public/redacted copies and Markdown reports..."
python3 "$SCRIPT_DIR/scripts/redact.py" \
  --mode "$MODE" \
  --input "$RAW_DIR" \
  --output "$PUB_DIR"

python3 "$SCRIPT_DIR/scripts/build_reports.py" \
  --run-id "$RUN_ID" \
  --logs "$PUB_DIR" \
  --reports "$REPORT_RUN_DIR" \
  --assets "$ASSETS"

# Current pointers
printf '%s\n' "$RUN_ID" > "$ASSETS/logs/LATEST"
printf '%s\n' "$RUN_ID" > "$ASSETS/reports/LATEST"

echo "[9/9] Generating checksums and manifest..."
python3 "$SCRIPT_DIR/scripts/manifest.py" \
  --root "$PROJECT_ROOT" \
  --output "$RUN_DIR/MANIFEST.sha256"

cat > "$RUN_DIR/COLLECTION-INFO.txt" <<EOF
Run ID: $RUN_ID
Mode: $MODE
ADB serial: $([[ "$MODE" == "public" ]] && echo "[REDACTED]" || echo "$DEVICE_SERIAL")
Project root: $PROJECT_ROOT
APK pulling: $PULL_APKS
Reverse engineering helpers: $RUN_RE
Full dumpsys: $FULL_DUMPSYS
Per-command timeout: ${COLLECT_TIMEOUT}s
Logcat lines: $LOGCAT_LINES
EOF

copy_latest_logs

echo
echo "Collection complete."
echo "Raw logs:       $RAW_DIR"
echo "Public logs:    $PUB_DIR"
echo "Reports:        $REPORT_RUN_DIR"
echo "RE workspace:   $RE_ROOT"
echo "Manifest:       $RUN_DIR/MANIFEST.sha256"
echo
if [[ "$MODE" == "public" ]]; then
  echo "Public mode was used. Review redacted outputs manually before publication."
else
  echo "PRIVATE mode was used. Do not publish outputs without a manual privacy review."
fi
