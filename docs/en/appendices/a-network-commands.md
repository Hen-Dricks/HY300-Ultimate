---
title: "Appendix A — Network Commands"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Reference"
language: "en"
last_updated: "2026-07-14"
---

# Appendix A — Network Commands

> *"Understanding network activity is essential for analyzing the real behavior of an Android firmware."*

---

# Purpose

This appendix gathers the primary networking commands used throughout the HY300 Ultimate project.

Rather than serving as a complete networking manual, this document focuses on the commands that proved useful during firmware analysis, debugging, reverse engineering, and validation.

Commands are organized by objective to simplify troubleshooting and experimentation.

---

# Verifying the ADB Connection

List connected devices.

```bash
adb devices
```

Connect over TCP/IP.

```bash
adb connect <IP_ADDRESS>:5555
```

Disconnect.

```bash
adb disconnect
```

Restart the ADB server.

```bash
adb kill-server
adb start-server
```

Verify that the device is authorized before starting any experiment.

---

# Display Network Information

Show IP addresses.

```bash
adb shell ip addr
```

List interfaces.

```bash
adb shell ip link
```

Display routing table.

```bash
adb shell ip route
```

Retrieve the device hostname.

```bash
adb shell getprop net.hostname
```

Display configured DNS servers.

```bash
adb shell getprop | grep dns
```

---

# Wi-Fi Diagnostics

Display Wi-Fi service information.

```bash
adb shell dumpsys wifi
```

List configured Wi-Fi networks.

```bash
adb shell cmd wifi list-networks
```

Display the currently connected SSID.

```bash
adb shell dumpsys wifi | grep SSID
```

---

# Connectivity Testing

Test basic connectivity.

```bash
adb shell ping 8.8.8.8
```

Test DNS resolution.

```bash
adb shell ping google.com
```

Traceroute (when available).

```bash
adb shell traceroute 8.8.8.8
```

---

# Active Connections

Display TCP sockets.

```bash
adb shell ss -t
```

Display UDP sockets.

```bash
adb shell ss -u
```

Display every active socket.

```bash
adb shell ss -tunap
```

Alternative command.

```bash
adb shell netstat
```

---

# DNS Resolution

Display DNS properties.

```bash
adb shell getprop | grep dns
```

Resolve a hostname (if supported).

```bash
adb shell nslookup google.com
```

---

# Android Network Properties

Display every Android system property.

```bash
adb shell getprop
```

Display only network-related properties.

```bash
adb shell getprop | grep net
```

Display Wi-Fi properties.

```bash
adb shell getprop | grep wifi
```

---

# Capturing System Logs

Display the complete system log.

```bash
adb logcat
```

Filter Wi-Fi events.

```bash
adb logcat | grep Wifi
```

Filter DHCP events.

```bash
adb logcat | grep DHCP
```

Filter Bluetooth events.

```bash
adb logcat | grep Bluetooth
```

---

# Android Network Services

List registered Android services.

```bash
adb shell service list
```

Inspect the Wi-Fi service.

```bash
adb shell dumpsys wifi
```

Inspect Android connectivity.

```bash
adb shell dumpsys connectivity
```

---

# Running Processes

List every running process.

```bash
adb shell ps -A
```

Display network-related processes.

```bash
adb shell ps -A | grep net
```

---

# Packet Capture

If `tcpdump` is available:

```bash
adb shell tcpdump
```

Capture traffic from every interface.

```bash
adb shell tcpdump -i any
```

Packet captures are particularly useful when investigating OTA updates, telemetry, or proprietary communication protocols.

---

# Testing Network Ports

Using Netcat.

```bash
adb shell nc
```

Or Telnet (if available).

```bash
adb shell telnet
```

---

# File Transfers

Copy a file to the device.

```bash
adb push file /sdcard/
```

Retrieve a file from the device.

```bash
adb pull /sdcard/file
```

---

# Useful Reboot Commands

Reboot into Recovery.

```bash
adb reboot recovery
```

Reboot into Bootloader.

```bash
adb reboot bootloader
```

Normal reboot.

```bash
adb reboot
```

---

# Linux Networking Tools

Display IP addresses.

```bash
ip addr
```

Display routing table.

```bash
ip route
```

List interfaces.

```bash
ip link
```

Display sockets.

```bash
ss -tunap
```

DNS lookup.

```bash
dig
```

Traceroute.

```bash
traceroute
```

Packet capture.

```bash
tcpdump
```

---

# Quick Reference

| Objective                    | Primary Command         |
| ---------------------------- | ----------------------- |
| Verify ADB                   | `adb devices`           |
| Display IP address           | `ip addr`               |
| Display routes               | `ip route`              |
| Inspect Wi-Fi                | `dumpsys wifi`          |
| Inspect Android connectivity | `dumpsys connectivity`  |
| List services                | `service list`          |
| Display logs                 | `logcat`                |
| Show active connections      | `ss -tunap`             |
| List running processes       | `ps -A`                 |
| Transfer files               | `adb push` / `adb pull` |
| Reboot device                | `adb reboot`            |

---

# Best Practices

- Verify that the device appears in `adb devices` before performing any operation.
- Use `dumpsys wifi` as the primary diagnostic tool for wireless connectivity issues.
- Prefer `ss` over `netstat` when available, as it provides more complete socket information.
- Capture `logcat` output during network experiments to preserve diagnostic information.
- Record the exact commands used during experiments to ensure reproducibility.

---

# Commands Used in HY300 Ultimate

This section is reserved for the commands that were actually executed during the HY300 Ultimate project.

It will be progressively updated with:

- ADB commands used during firmware analysis;
- Wi-Fi diagnostics;
- OTA traffic observations;
- network troubleshooting sessions;
- packet capture examples;
- validation procedures.

Keeping these commands separate from the general reference helps distinguish theoretical examples from the project's actual workflow.

---

> [!TIP]
> Network analysis is most effective when multiple sources of information are correlated. Combining `logcat`, `dumpsys`, packet captures, and system properties often provides a much clearer understanding of firmware behavior than relying on a single command alone.