---
title: "Userspace Fastboot (Fastbootd) Analysis"
volume: 6
chapter: 61
status: complete
last_updated: 2026-07-15
authors:
  - HY300 Ultimate Project
---

# Chapter 61 — Userspace Fastboot (Fastbootd) Analysis

## Abstract

One of the most important discoveries made during the USB investigation was that the HY300 Ultimate does **not** expose the traditional bootloader Fastboot implementation.

Instead, the device operates in **Userspace Fastboot**, commonly known as **Fastbootd**.

This distinction is critical because Fastbootd behaves differently from the classic bootloader Fastboot found on many Android smartphones. It explains the availability of certain commands, the absence of others, and the overall interaction model observed during this research.

---

# 61.1 Background

Historically, Android devices implemented Fastboot entirely inside the bootloader.

```
Host Computer

        │

     USB Fastboot

        │

Bootloader

        │

Flash Memory
```

In this architecture, Fastboot executes before Android starts.

It is responsible for operations such as:

- flashing partitions
- booting kernels
- unlocking the bootloader
- reading partition metadata

---

Beginning with Android Dynamic Partitions, Google introduced **Fastbootd**.

Rather than running inside the bootloader, Fastbootd executes from Android Recovery.

```
Bootloader

      │

Recovery

      │

Fastbootd

      │

USB Protocol

      │

Host Computer
```

This approach enables Android itself to manage logical partitions contained inside `super.img`.

---

# 61.2 Evidence Collected

The following command was executed:

```bash
fastboot getvar all
```

Among the returned variables:

```text
is-userspace:yes
```

This single property conclusively identifies the running implementation as **Fastbootd**.

Unlike assumptions based solely on observed behavior, this value is explicitly reported by the device itself.

---

# 61.3 Relationship with Dynamic Partitions

Additional Fastboot variables include:

```text
dynamic-partition:true

treble-enabled:true

super-partition-name:super
```

These properties are entirely consistent with a Fastbootd implementation.

Android uses Fastbootd to manipulate logical partitions contained within the `super` partition.

The observed architecture therefore follows Google's modern Android partition model.

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

# 61.4 Security Model

Fastboot also reports:

```text
secure:yes

unlocked:no
```

This indicates:

- Android Verified Boot remains active.
- The bootloader is currently locked.
- Device integrity protections remain enabled.

No evidence was observed suggesting that Fastbootd bypasses these security mechanisms.

---

# 61.5 Missing Fastboot Commands

Several standard Fastboot commands were tested.

Example:

```bash
fastboot flashing get_unlock_ability
```

Response:

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

These failures are consistent with a limited Fastbootd implementation.

They should **not** be interpreted as communication failures.

Instead, they indicate that the firmware does not expose these optional Fastboot interfaces.

---

# 61.6 Fastboot HAL

Several failed commands referenced:

```text
Fastboot HAL
```

Android defines a Hardware Abstraction Layer (HAL) for Fastboot.

This HAL exposes optional features such as:

- OEM commands
- flashing capability queries
- bootloader information
- vendor-specific operations

The observed firmware either:

- does not implement the complete HAL,
- disables parts of it,
- or intentionally limits the available functionality.

Without access to the proprietary source code, the exact reason cannot be determined.

---

# 61.7 Behaviour Observed

The following operations succeeded.

| Command                    | Result  |
| -------------------------- | ------- |
| `fastboot devices`         | Success |
| `fastboot getvar all`      | Success |
| `fastboot reboot fastboot` | Success |
| `fastboot reboot recovery` | Success |

The following operations were rejected.

| Command                                | Result                   |
| -------------------------------------- | ------------------------ |
| `fastboot flashing get_unlock_ability` | Unsupported              |
| `fastboot oem device-info`             | Fastboot HAL unavailable |

This behaviour is internally consistent.

---

# 61.8 Transition Between Modes

The observed workflow became:

```
Android

↓

ADB

↓

fastboot reboot recovery

↓

Recovery

↓

Fastbootd

↓

fastboot getvar all
```

Recovery subsequently exposed ADB again:

```text
adb devices -l

c3d9b8674f4b94f6 recovery
```

This confirms that Fastbootd and Recovery are closely integrated.

---

# 61.9 Engineering Implications

For firmware development, Fastbootd provides several advantages.

## Independent Validation

Partition metadata can be queried without relying on Android runtime services.

---

## Logical Partition Awareness

Fastbootd understands Android Dynamic Partitions.

This makes it the preferred environment for validating:

- `super.img`
- logical partition layout
- partition sizes

---

## Stable USB Interface

USB communication proved significantly more reliable than Wi-Fi during repeated testing.

---

## Safe Investigation

The commands used throughout this investigation were read-only.

No flashing, formatting or partition modification was performed.

The collected information therefore reflects the original device state.

---

# 61.10 Limitations

Fastbootd should not be confused with unrestricted bootloader Fastboot.

Observed limitations include:

- locked bootloader
- unavailable OEM commands
- unavailable unlock capability queries
- missing Fastboot HAL functionality

These limitations restrict certain development workflows but do not prevent comprehensive device documentation.

---

# 61.11 Lessons Learned

The transition from ADB-only analysis to Fastbootd significantly improved confidence in the project's findings.

Instead of relying exclusively on Android runtime observations, critical information could now be validated through an independent subsystem.

This provided additional confirmation of:

- partition architecture
- security configuration
- logical partition layout
- Android version
- Treble implementation

without modifying the device.

---

# 61.12 Conclusion

The HY300 Ultimate implements **Userspace Fastboot (Fastbootd)** rather than the traditional bootloader Fastboot.

This implementation is fully consistent with the device's Android 12 architecture, Dynamic Partitions, and `super.img` layout.

Although some optional Fastboot features are unavailable, Fastbootd provides sufficient functionality to validate the partition map, security configuration, and firmware architecture, making it an essential component of the reverse engineering workflow and the ongoing custom ROM development process.