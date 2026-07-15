# HY300 Ultimate — Device Collection Toolkit

This toolkit populates:

```text
assets/
├── logs/
├── reports/
└── reverse-engineering/
```

from a connected Android device through ADB.

## What it collects

### `assets/logs`

Raw and publishable/redacted outputs for:

- Android properties and build information;
- hardware, CPU, RAM, kernel, and block devices;
- packages, permissions, features, processes, and services;
- partition names, mount points, filesystems, and fstab files;
- boot logs, `logcat`, `dmesg`, and init service declarations;
- SurfaceFlinger, display, graphics, media, audio, sensors, power, and USB;
- network configuration and sockets;
- SELinux, AVB/Verified Boot, users, policies, OTA, and recovery state.

### `assets/reports`

Automatically generated Markdown summaries:

- hardware;
- software;
- partitions;
- security;
- performance baseline;
- collection validation.

### `assets/reverse-engineering`

When enabled, the collector:

- pulls installed APKs;
- records package metadata and SHA-256 hashes;
- runs `apktool` when installed;
- runs `jadx` when installed;
- extracts packaged `.so` libraries when `unzip` is available;
- generates printable-string inventories;
- attempts to pull selected documented OEM binaries and libraries.

## Requirements

Required:

- Bash
- Python 3
- Android Platform Tools (`adb`)

Optional:

- `apktool`
- `jadx`
- `unzip`
- `strings`
- `sha256sum` or `shasum`

## Usage

From the repository root:

```bash
chmod +x device/collect-all.sh
./device/collect-all.sh
```

For an ADB-over-network target:

```bash
./device/collect-all.sh --serial DEVICE_IP:PORT
```

Use a different repository root:

```bash
./device/collect-all.sh --output /path/to/repository
```

## Privacy modes

The default is public mode:

```bash
./device/collect-all.sh --public
```

It creates:

```text
assets/logs/runs/<RUN_ID>/raw/
assets/logs/runs/<RUN_ID>/public/
```

The public copy attempts to redact:

- private/local IP addresses;
- MAC addresses;
- serial and device identifiers;
- SSIDs;
- obvious tokens and secrets.

Automatic redaction is not perfect. Manually review every artifact before publication.

Private mode preserves identifiers:

```bash
./device/collect-all.sh --private
```

Do not publish private-mode outputs without a complete review.

## Important boundaries

The collector is read-only with respect to firmware partitions. It does not:

- flash images;
- write to block devices;
- unlock a bootloader;
- modify Android properties;
- disable security mechanisms;
- exploit the device.

APK and binary extraction may require elevated access depending on the firmware. Failed reads are recorded or skipped without stopping the entire collection.

## Recommended repository layout

```text
repository/
├── device/
│   ├── collect-all.sh
│   └── scripts/
└── assets/
    ├── logs/
    ├── reports/
    └── reverse-engineering/
```
