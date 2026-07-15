---
title: "Recovery ADB Analysis"
volume: 6
chapter: 64
status: complete
last_updated: 2026-07-15
authors:
  - HY300 Ultimate Project
---

# Chapter 64 — Recovery ADB Analysis

## Abstract

Following the discovery of USB Fastboot support, the next objective was to investigate the Android Recovery environment exposed by the HY300 Ultimate.

Unlike normal Android operation, Recovery provides a minimal execution environment designed for maintenance and firmware servicing. Despite its reduced functionality, Recovery exposes valuable diagnostic information through Android Debug Bridge (ADB), including partition mappings, mounted filesystems, runtime properties, and initialization services.

The Recovery investigation provided an independent perspective on the device architecture and confirmed several findings obtained previously through Android and Fastboot.

---

# 64.1 Objectives

The Recovery investigation aimed to answer the following questions.

- Does Recovery expose ADB?
- Which partitions are visible?
- Which services are running?
- Which Android properties remain available?
- Does Recovery expose the same hardware architecture?
- Can Recovery serve as a safe diagnostic environment?

---

# 64.2 Entering Recovery

Recovery was reached through Fastboot using:

```bash
fastboot reboot recovery
```

The command completed successfully.

Once Recovery finished booting:

```bash
adb devices -l
```

reported:

```text
c3d9b8674f4b94f6    recovery
```

At the same time, the previous wireless ADB endpoint appeared as:

```text
192.168.1.23:3268    offline
```

This confirms that Android and Recovery expose independent ADB transports while referring to the same physical device.

---

# 64.3 Recovery Services

Inspection of Android properties confirmed the execution environment.

Among the running services:

```text
init.svc.recovery=running

init.svc.adbd=running
```

Meanwhile:

```text
init.svc.fastbootd=stopped
```

This demonstrates that the device was executing the standard Android Recovery environment rather than Userspace Fastboot.

---

# 64.4 Partition Visibility

Recovery exposes a complete partition inventory through:

```bash
adb shell ls /dev/block/by-name
```

The observed partitions include:

```text
boot

recovery

vbmeta

super

metadata

misc

dtbo

trust

uboot

logo

baseparameter

security

cust

backup

userdata
```

This inventory closely matches the partition layout reported earlier by Fastboot.

---

# 64.5 Mounted Filesystems

Recovery mounts only a limited number of partitions.

Unlike Android, logical partitions such as:

- system
- vendor
- product
- odm

were not mounted automatically.

Instead, Recovery focused on partitions required for maintenance operations.

Typical mounted partitions included:

- metadata
- cust
- temporary filesystems

This behaviour minimizes the risk of accidental modification during recovery operations.

---

# 64.6 Android Properties

Recovery still exposes a substantial subset of Android system properties.

Examples include:

```text
ro.build.version.release

ro.build.version.sdk

ro.build.fingerprint

ro.build.type

ro.product.*

persist.*
```

These properties proved extremely valuable because they can be collected even when the primary Android system is unavailable.

---

# 64.7 Build Information

Recovery reported:

```text
Android 12

Build Type:
userdebug
```

The build fingerprint matched the Android runtime.

An additional observation was the reported firmware build date:

```text
Thu Dec 4 2025
```

while the Android security patch level remained:

```text
2022-07-05
```

This suggests that the vendor rebuilt the firmware while continuing to use an earlier Android platform release.

---

# 64.8 daemon12138

Recovery confirmed the presence of the OEM daemon configuration.

Among the exported properties:

```text
persist.daemon12138_switch=1
```

This independently validates previous observations made from the running Android system.

The property remains visible even inside Recovery.

---

# 64.9 Keystone Configuration

Recovery also exposed Keystone-related properties.

Examples include:

```text
persist.sys.keystone.*
```

Although Recovery itself does not execute Keystone correction, the persisted configuration remains accessible.

This demonstrates that Keystone configuration is stored independently of the Android runtime.

---

# 64.10 ADB TCP Configuration

Recovery exposed an additional property:

```text
service.adb.tcp.port=3268
```

This explains the non-standard wireless ADB port observed throughout the project.

Unlike most Android devices, which typically use TCP port 5555, the HY300 Ultimate explicitly configures ADB to use port 3268.

This observation resolved an open question from the earliest stages of the investigation.

---

# 64.11 Comparison with Android

Recovery and Android expose different execution environments.

| Feature             | Android  | Recovery           |
| ------------------- | -------- | ------------------ |
| Launcher            | Yes      | No                 |
| Applications        | Yes      | No                 |
| ADB                 | Yes      | Yes                |
| Fastbootd           | Optional | No (Recovery mode) |
| Full Framework      | Yes      | Minimal            |
| Partition Inventory | Yes      | Yes                |
| Build Properties    | Yes      | Yes                |

Recovery therefore provides a lightweight diagnostic environment while retaining many useful engineering interfaces.

---

# 64.12 Engineering Advantages

Recovery proved extremely valuable for firmware research.

Advantages include:

- independent execution environment;
- stable USB ADB connection;
- partition inspection;
- property collection;
- diagnostics when Android cannot boot.

Because Recovery is isolated from the normal Android runtime, it serves as an excellent platform for validating firmware state.

---

# 64.13 Relationship with Fastboot

The observed workflow became:

```text
Android

↓

ADB

↓

Fastboot

↓

Recovery

↓

ADB

↓

Diagnostics
```

This sequence provides multiple independent access paths to the device.

Each environment contributes different information while collectively describing the complete firmware architecture.

---

# 64.14 Lessons Learned

Several important conclusions emerged.

- Recovery provides reliable USB ADB access.
- Recovery exposes nearly the complete partition inventory.
- Recovery confirms OEM properties independently of Android.
- Recovery remains usable even when Android is unavailable.
- Recovery complements Fastboot by exposing runtime diagnostics unavailable through Fastboot variables alone.

---

# 64.15 Conclusion

The Recovery investigation substantially strengthened the overall understanding of the HY300 Ultimate platform.

Far from being a simple maintenance environment, Recovery serves as an independent diagnostic subsystem capable of exposing partition metadata, persistent system properties, runtime services, and firmware configuration.

Together with Android and Fastboot, Recovery completes a three-layer investigation methodology that significantly increases confidence in the reverse engineering results and provides a robust foundation for future custom ROM development.