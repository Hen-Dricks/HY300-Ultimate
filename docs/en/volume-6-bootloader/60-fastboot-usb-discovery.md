---
title: "Fastboot USB Discovery"
volume: 6
chapter: 60
status: complete
last_updated: 2026-07-15
authors:
  - HY300 Ultimate Project
---

# Chapter 60 — Fastboot USB Discovery

## Abstract

The discovery of USB Fastboot access represented a major turning point in the reverse engineering of the HY300 Ultimate projector.

Until this stage, all firmware analysis had been performed through Android Debug Bridge (ADB) over TCP/IP. The availability of Fastboot over USB enabled direct interaction with the device before Android was fully operational, allowing independent validation of the bootloader, partition layout, and security model.

Unlike the initial assumptions, no proprietary cable or Rockchip-specific flashing utility was required. A standard USB Type-A to USB Type-A cable provided immediate Fastboot connectivity.

---

# 60.1 Initial Assumptions

During the early stages of the project, several hypotheses were considered.

The projector appeared to support only:

- Android Debug Bridge (ADB)
- Wireless debugging
- OTA firmware updates

No public documentation described any USB Fastboot interface.

Consequently, the firmware workflow initially depended entirely on Android successfully booting.

---

# 60.2 USB Investigation

After replacing the previous USB cable with a standard USB Type-A to USB Type-A cable, the device was connected directly to the development workstation.

The following command was executed:

```bash
fastboot devices
```

The result was immediate.

```text
c3d9b8674f4b94f6    fastboot
```

This confirmed that the projector exposes a functional Fastboot interface over USB.

---

# 60.3 Immediate Implications

This single discovery immediately expanded the available engineering capabilities.

Before:

```
Android

↓

ADB TCP/IP

↓

Firmware analysis
```

After:

```
USB

├── Android ADB
├── Recovery ADB
└── Fastboot
```

Firmware development no longer depended exclusively on Android successfully booting.

---

# 60.4 Validation of Fastboot Communication

Communication was validated using:

```bash
fastboot getvar all
```

The command successfully returned bootloader variables describing the platform.

Among the most important values:

```text
treble-enabled:true

dynamic-partition:true

secure:yes

unlocked:no

product:rk3326_sgo

version-os:12
```

This confirmed that Fastboot communication was fully operational.

---

# 60.5 Userspace Fastboot

One unexpected observation was:

```text
is-userspace:yes
```

This indicates that the interface is **Fastbootd (userspace Fastboot)** rather than the classic bootloader Fastboot implementation.

In Android, Fastbootd executes within the recovery environment and communicates with the Fastboot protocol through Android userspace services.

```
Bootloader
      │
      ▼

Recovery

      │
      ▼

Fastbootd

      │
      ▼

USB
```

This architecture explains why some classic Fastboot commands are unavailable.

---

# 60.6 Unsupported Commands

Several commonly documented Fastboot commands failed.

Examples:

```bash
fastboot flashing get_unlock_ability
```

returned:

```text
FAILED (remote: 'Unrecognized command flashing get_unlock_ability')
```

Likewise:

```bash
fastboot oem device-info
```

returned:

```text
FAILED (remote: 'Unable to open fastboot HAL')
```

These failures do **not** indicate a malfunction.

Instead, they reflect limitations of the Fastboot implementation included in this firmware.

---

# 60.7 Bootloader Information

Fastboot nevertheless exposed valuable metadata.

Examples include:

| Variable           | Value      |
| ------------------ | ---------- |
| Product            | rk3326_sgo |
| Android            | 12         |
| Treble             | Enabled    |
| Dynamic Partitions | Enabled    |
| Secure Boot        | Enabled    |
| Bootloader         | Locked     |
| Slot Count         | 0          |
| Fastboot           | Userspace  |

These variables independently confirmed conclusions previously inferred through ADB analysis.

---

# 60.8 Partition Information

Fastboot also reported partition sizes.

Examples:

| Partition | Size       |
| --------- | ---------- |
| super     | 0x96000000 |
| boot      | 0x02800000 |
| recovery  | 0x06C00000 |
| vbmeta    | 0x00100000 |
| metadata  | 0x01000000 |

Logical partitions were also identified.

```
system

vendor

product

odm

system_ext

vendor_dlkm

odm_dlkm
```

This independently validated the reconstructed partition map generated from firmware extraction.

---

# 60.9 Transition to Recovery

Fastboot successfully accepted:

```bash
fastboot reboot recovery
```

After rebooting:

```bash
adb devices -l
```

reported:

```text
c3d9b8674f4b94f6 recovery
```

demonstrating seamless transitions between Fastboot and Recovery.

---

# 60.10 Engineering Advantages

USB Fastboot introduced several major benefits.

## Independent Validation

Partition metadata could now be obtained directly from the device.

---

## Recovery Workflow

Firmware validation no longer depended on Android booting successfully.

---

## Reliable USB Communication

USB proved significantly more stable than Wi-Fi for repeated engineering tasks.

---

## Bootloader Investigation

Fastboot provided access to:

- security configuration
- partition metadata
- logical partition mapping
- bootloader variables

without modifying device state.

---

# 60.11 Limitations

The observed Fastboot implementation remains limited.

Notable restrictions include:

- locked bootloader
- unavailable OEM commands
- unavailable flashing capability checks
- missing Fastboot HAL features

These limitations are consistent with many embedded Android devices based on Rockchip platforms.

---

# 60.12 Lessons Learned

The USB Fastboot interface transformed the project.

Instead of relying solely on Android runtime analysis, firmware engineering could now combine information from:

```
Android

↓

Recovery

↓

Fastboot
```

This produced multiple independent sources of evidence and significantly increased confidence in the documented architecture.

---

# 60.13 Conclusion

The discovery of USB Fastboot support represents one of the most important milestones of the HY300 Ultimate engineering project.

Using nothing more than a standard USB Type-A to USB Type-A cable, the projector exposed a functional Fastboot interface capable of reporting bootloader configuration, partition metadata, and security information.

This capability substantially improved firmware validation, reverse engineering accuracy, and future custom ROM development while remaining entirely non-destructive.