#!/usr/bin/env python3
from __future__ import annotations
import argparse
import re
import shutil
from pathlib import Path

parser = argparse.ArgumentParser()
parser.add_argument("--mode", choices=["public", "private"], required=True)
parser.add_argument("--input", type=Path, required=True)
parser.add_argument("--output", type=Path, required=True)
args = parser.parse_args()

if args.output.exists():
    shutil.rmtree(args.output)
args.output.mkdir(parents=True)

patterns = [
    # MAC addresses
    (re.compile(r'(?i)\b(?:[0-9a-f]{2}:){5}[0-9a-f]{2}\b'), '[REDACTED_MAC]'),
    # Private IPv4 addresses
    (re.compile(r'(?<!\d)(?:10|127|169\.254|172\.(?:1[6-9]|2\d|3[01])|192\.168)(?:\.\d{1,3}){2}(?!\d)'), '[REDACTED_IP]'),
    # Serial numbers / IMEI / device IDs
    (re.compile(r'(?i)\b(serial(?:no|number)?|ro\.serialno|android_id|device_id|imei|meid)\s*[:=\]]+\s*[^\s\],]+'), r'\1=[REDACTED_ID]'),
    # SSID (key=value or key: value or key] = value)
    (re.compile(r'(?i)\b(ssid)\s*[:=\]]+\s*"?[^"\n,\]]+'), r'\1=[REDACTED_SSID]'),
    # SSID in quotes (e.g. "MyNetwork" in wifi logs)
    (re.compile(r'"[A-Za-z0-9 _\-\.]{2,}"(?=.*(?:SAE|WPA|wpa|BSSID|bssid|ssid|SSID|scan|connect|network))'), '[REDACTED_SSID]'),
    # SSID names appearing after redacted BSSID or in wifi scan results
    (re.compile(r'"[A-Za-z0-9 _\-\.]{2,}"\s*(?:\[REDACTED_MAC\]|rssi=|f=|sc=)'), '[REDACTED_SSID]'),
    # SSID in WNS candidate lines
    (re.compile(r'WNS candidate-"[A-Za-z0-9 _\-\.]{2,}"'), 'WNS candidate-[REDACTED_SSID]'),
    # SSID in connectToNetwork lines
    (re.compile(r'Connect to "[A-Za-z0-9 _\-\.]{2,}"'), 'Connect to [REDACTED_SSID]'),
    # SSID in setNetworkSelectionStatus lines
    (re.compile(r'configKey="[A-Za-z0-9 _\-\.]{2,}"'), 'configKey=[REDACTED_SSID]'),
    # SSID in current SSID lines
    (re.compile(r'current SSID\(s\):\{[^}]*ssid="[A-Za-z0-9 _\-\.]{2,}"'), 'current SSID(s):{ssid=[REDACTED_SSID]'),
    # SSID in SSID: "name" lines
    (re.compile(r'\bSSID:\s*"[A-Za-z0-9 _\-\.]{2,}"'), 'SSID: [REDACTED_SSID]'),
    # Tokens / passwords / secrets / authorization
    (re.compile(r'(?i)\b(token|password|passwd|secret|api[_-]?key|authorization)\s*[:=]\s*[^\s]+'), r'\1=[REDACTED_SECRET]'),
    # Email addresses
    (re.compile(r'\b[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\b'), '[REDACTED_EMAIL]'),
    # stable_secret (IPv6 interface identifier, may be bracket-wrapped)
    (re.compile(r'(?i)(stable_secret)\s*\]?:\s*\[?[0-9a-f:]+\]?'), r'\1=[REDACTED_SECRET]'),
    # bdaddr (Bluetooth address, may be bracket-wrapped)
    (re.compile(r'(?i)(bdaddr)\s*\]?:\s*\[?(?:[0-9a-f]{2}:){5}[0-9a-f]{2}\]?'), r'\1=[REDACTED_MAC]'),
    # adb.wifi.guid (contains device serial)
    (re.compile(r'(?i)(adb\.wifi\.guid)\s*\]?:\s*\[?[^\s\]]+\]?'), r'\1=[REDACTED_ID]'),
]

for src in args.input.rglob("*"):
    rel = src.relative_to(args.input)
    dst = args.output / rel
    if src.is_dir():
        dst.mkdir(parents=True, exist_ok=True)
        continue
    dst.parent.mkdir(parents=True, exist_ok=True)
    if args.mode == "private":
        shutil.copy2(src, dst)
        continue
    try:
        text = src.read_text(encoding="utf-8", errors="replace")
        for pattern, replacement in patterns:
            text = pattern.sub(replacement, text)
        dst.write_text(text, encoding="utf-8")
    except Exception:
        # Binary files should not normally be present under logs.
        shutil.copy2(src, dst)
