---
title: "Fastboot Partition Layout Validation"
volume: 6
chapter: 62
status: complete
last_updated: 2026-07-15
authors:
  - HY300 Ultimate Project
---

# Chapter 62 — Fastboot Partition Layout Validation

## Abstract

One of the primary objectives of the USB Fastboot investigation was to independently validate the partition layout previously reconstructed from firmware extraction and Android analysis.

Using `fastboot getvar all`, the device exposed the complete partition inventory together with their declared sizes and logical partition status. These values closely matched the reconstructed firmware images, providing independent confirmation that the partition map documented throughout this project accurately represents the physical storage layout of the HY300 Ultimate.

---

# 62.1 Background

Earlier chapters reconstructed the firmware layout by combining:

- firmware extraction
- `lpunpack`
- Android mount points
- `/dev/block/by-name`
- Dynamic Partition metadata

Although internally consistent, those results originated from Android userspace.

The availability of Fastboot introduced an independent source of truth directly exposed by the firmware.

---

# 62.2 Validation Method

The following command was executed:

```bash
fastboot getvar all
```

Unlike Android userspace, Fastboot reports partition information directly through the firmware interface.

This avoids relying on Android services or mounted filesystems.

---

# 62.3 Physical Partition Inventory

The device reported the following physical partitions.

| Partition     |   Size (Hex) | Approximate Size |
| ------------- | -----------: | ---------------: |
| metadata      | `0x01000000` |            16 MB |
| super         | `0x96000000` |          2.35 GB |
| cache         | `0x18000000` |           384 MB |
| trust         | `0x00400000` |             4 MB |
| cust          | `0x04000000` |            64 MB |
| recovery      | `0x06C00000` |           108 MB |
| backup        | `0x17400000` |           372 MB |
| security      | `0x00400000` |             4 MB |
| dtbo          | `0x00400000` |             4 MB |
| baseparameter | `0x00100000` |             1 MB |
| boot          | `0x02800000` |            40 MB |
| uboot         | `0x00400000` |             4 MB |
| misc          | `0x00400000` |             4 MB |
| logo          | `0x04000000` |            64 MB |
| vbmeta        | `0x00100000` |             1 MB |
| userdata      | `0xFDDF8000` |         ~4.0 GB* |

\*Approximate size shown for readability.

---

# 62.4 Dynamic Partitions

Fastboot confirms that several partitions are logical rather than physical.

Reported values include:

```text
is-logical:system:yes

is-logical:vendor:yes

is-logical:product:yes

is-logical:odm:yes

is-logical:system_ext:yes

is-logical:vendor_dlkm:yes

is-logical:odm_dlkm:yes
```

This is fully consistent with Android Dynamic Partitions.

Instead of existing as standalone block devices, these partitions reside inside the `super` partition.

```
super
│
├── system
├── vendor
├── product
├── odm
├── system_ext
├── vendor_dlkm
└── odm_dlkm
```

---

# 62.5 Logical Partition Sizes

Fastboot also reports the size allocated to each logical partition.

| Logical Partition |   Size (Hex) | Approximate Size |
| ----------------- | -----------: | ---------------: |
| system            | `0x2F47F000` |          ~756 MB |
| system_ext        | `0x04729000` |           ~71 MB |
| vendor            | `0x1109D000` |          ~273 MB |
| vendor_dlkm       | `0x01584000` |           ~22 MB |
| odm               | `0x332DE000` |          ~819 MB |
| odm_dlkm          | `0x00040000` |           256 KB |
| product           | `0x0C7BD000` |          ~200 MB |

These values correspond closely to the images extracted during the firmware reconstruction phase.

---

# 62.6 Absence of A/B Slots

Fastboot reports:

```text
slot-count:0
```

Likewise:

```text
has-slot:system:no

has-slot:boot:no

has-slot:vendor:no
```

The HY300 Ultimate therefore does **not** implement Android's seamless update mechanism.

Instead, it relies on a traditional single-slot partition layout.

```
boot

↓

system

↓

vendor

↓

userdata
```

No alternate slot is maintained for OTA updates.

---

# 62.7 Validation of Previous Research

The Fastboot data independently confirms several conclusions previously reached through Android analysis.

| Observation          | Previous Analysis | Fastboot  |
| -------------------- | ----------------- | --------- |
| Dynamic Partitions   | Yes               | Confirmed |
| super.img            | Yes               | Confirmed |
| Treble               | Yes               | Confirmed |
| Logical partitions   | Yes               | Confirmed |
| Single-slot firmware | Suspected         | Confirmed |
| Android 12 layout    | Yes               | Confirmed |

The agreement between independent data sources significantly increases confidence in the documented architecture.

---

# 62.8 Engineering Implications

Understanding the partition layout is essential for custom ROM development.

The following observations are particularly important.

## super.img

The firmware is distributed around a single Dynamic Partition container.

Any modification to:

- system
- vendor
- product
- odm

requires rebuilding the `super` image.

---

## vbmeta

The presence of a dedicated `vbmeta` partition indicates that Android Verified Boot is active.

Any future modification of verified partitions must take this into account.

---

## Recovery

Recovery exists as an independent partition.

It provides an alternative execution environment for diagnostics and maintenance.

---

## Trust

The dedicated `trust` partition suggests the presence of Rockchip Trusted Firmware components.

No modifications were performed during this investigation.

---

# 62.9 Comparison with Android

Android userspace previously reported the partition map through:

- `/proc/partitions`
- `/dev/block/by-name`
- mount points

Fastboot independently reported:

- partition sizes
- logical partition status
- partition capabilities

Both sources describe the same storage architecture.

This mutual confirmation strengthens confidence in the reverse engineering process.

---

# 62.10 Lessons Learned

The USB Fastboot interface proved invaluable for validating storage architecture.

Rather than relying solely on firmware extraction or Android runtime observations, partition metadata could be queried directly from the firmware itself.

This substantially reduced uncertainty surrounding the custom ROM build process.

---

# 62.11 Conclusion

The Fastboot partition inventory fully validates the storage architecture reconstructed during earlier phases of the project.

The HY300 Ultimate implements a modern Android 12 storage design based on:

- Dynamic Partitions
- `super.img`
- Treble
- logical system partitions
- Verified Boot
- a single-slot update model

These findings provide a reliable foundation for rebuilding, validating, and eventually deploying a custom firmware while preserving compatibility with the original partition layout.