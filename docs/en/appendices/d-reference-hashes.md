---
title: "Appendix D — Reference Hashes"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Reference"
language: "en"
last_updated: "2026-07-14"
---

# Appendix D — Reference Hashes

> *"A firmware image without a cryptographic hash cannot be reliably verified. A hash alone does not prove authenticity, but it provides strong assurance that the file has not been altered since the hash was generated."*

---

# Purpose

This appendix centralizes the cryptographic hashes of the primary artifacts used and generated throughout the HY300 Ultimate project.

Its objectives are to:

- verify file integrity;
- distinguish between firmware versions;
- ensure experiment reproducibility;
- simplify comparisons between releases;
- provide an auditable record of project artifacts.

Unless otherwise specified, every reference hash in this project uses **SHA-256**.

---

# Why SHA-256?

SHA-256 is a cryptographic hash function widely used to verify file integrity.

Within HY300 Ultimate it serves several purposes:

- detecting accidental corruption;
- identifying incomplete file transfers;
- distinguishing different firmware builds;
- validating archived artifacts.

Even a one-byte modification results in a completely different SHA-256 hash.

---

# Hash Generation

Linux

```bash
sha256sum file.img
```

macOS

```bash
shasum -a 256 file.img
```

Hash multiple files.

```bash
sha256sum *.img
```

Generate a reference file.

```bash
sha256sum *.img > SHA256SUMS
```

Verify every file.

```bash
sha256sum -c SHA256SUMS
```

---

# Artifact Naming Convention

Firmware artifacts follow a consistent naming convention.

```
component-version.img
```

Examples

```
super-original.img

super-hy300-v0.1.img

super-hy300-v0.2.img
```

A predictable naming convention greatly simplifies long-term maintenance.

---

# OEM Firmware

| File               |            Size | SHA-256         | Status    |
| ------------------ | --------------: | --------------- | --------- |
| super-original.img | To be completed | To be completed | Reference |
| boot.img           | To be completed | To be completed | Reference |
| vendor.img         | To be completed | To be completed | Reference |
| product.img        | To be completed | To be completed | Reference |
| odm.img            | To be completed | To be completed | Reference |
| vbmeta.img         | To be completed | To be completed | Reference |

---

# Extracted Partitions

| Partition   |            Size | SHA-256         |
| ----------- | --------------: | --------------- |
| system.img  | To be completed | To be completed |
| vendor.img  | To be completed | To be completed |
| product.img | To be completed | To be completed |
| odm.img     | To be completed | To be completed |

---

# HY300 Ultimate Builds

| Build | SHA-256         | Build Date      | Status       |
| ----- | --------------- | --------------- | ------------ |
| v0.1  | To be completed | To be completed | Prototype    |
| v0.2  | To be completed | To be completed | Experimental |
| v0.3  | To be completed | To be completed | Planned      |
| RC1   | To be completed | To be completed | Planned      |
| v1.0  | To be completed | To be completed | Planned      |

---

# Scripts

Project scripts may also be tracked.

| Script      | SHA-256         |
| ----------- | --------------- |
| build.sh    | To be completed |
| extract.sh  | To be completed |
| rebuild.sh  | To be completed |
| validate.sh | To be completed |

---

# Docker Environment

Docker configuration files can also be versioned.

| File               | SHA-256         |
| ------------------ | --------------- |
| Dockerfile         | To be completed |
| docker-compose.yml | To be completed |
| entrypoint.sh      | To be completed |

---

# Documentation

Major documentation files may receive reference hashes for every release.

| Document     | SHA-256         |
| ------------ | --------------- |
| README.md    | To be completed |
| CHANGELOG.md | To be completed |
| RELEASE.md   | To be completed |
| INSTALL.md   | To be completed |

---

# Integrity Verification Workflow

Every public release follows the same verification process.

```text
Firmware

↓

Generate SHA-256

↓

Compare with Reference

↓

Validate

↓

Publish
```

No artifact is released without integrity verification.

---

# Version History

Reference hashes are **never replaced**.

Whenever a new release is generated:

- new hashes are added;
- previous hashes remain archived;
- historical records are preserved.

This guarantees complete traceability throughout the project's lifetime.

---

# Recommended Release Structure

```text
release/

├── SHA256SUMS
├── SHA256SUMS.txt
├── MANIFEST.json
├── build-report.md
├── RELEASE.md
└── CHANGELOG.md
```

Every public release should include its corresponding `SHA256SUMS` file.

---

# Example SHA256SUMS

```text
9d3d...a8e2  super-original.img
51af...0b9c  super-hy300-v0.1.img
7e29...8fa1  super-hy300-v0.2.img
```

The values above are examples only.

---

# Verifying a Downloaded Release

Run:

```bash
sha256sum -c SHA256SUMS
```

Expected output:

```text
super-hy300-v0.2.img: OK
```

Any mismatch should be investigated before using the firmware.

---

# Manifest Example

A machine-readable manifest may accompany each release.

```json
{
  "project": "HY300 Ultimate",
  "version": "v0.2",
  "build_date": "2026-07-14",
  "base_firmware": "HY300 OEM",
  "artifacts": [
    {
      "name": "super-hy300-v0.2.img",
      "sha256": "...",
      "size": 4294967296
    }
  ]
}
```

Such manifests simplify automated validation and CI/CD pipelines.

---

# Summary

| Category             | Verification Method |
| -------------------- | ------------------- |
| OEM Firmware         | SHA-256             |
| Extracted Partitions | SHA-256             |
| Custom Builds        | SHA-256             |
| Scripts              | SHA-256             |
| Docker Files         | SHA-256             |
| Documentation        | SHA-256             |

---

# Best Practices

- Generate hashes immediately after creating an artifact.
- Verify hashes after every important file transfer.
- Keep `SHA256SUMS` alongside every release.
- Never overwrite historical hashes.
- Use SHA-256 consistently throughout the project.
- Archive both hashes and build metadata together.

---

# Hashes Used in HY300 Ultimate

This section is reserved for the hashes actually generated during the project.

It will progressively include:

- OEM firmware hashes;
- extracted partition hashes;
- custom firmware builds;
- Docker image hashes;
- release manifests;
- published documentation hashes.

Maintaining this separation makes it easy to distinguish between reference examples and real project artifacts.

---

# Revision History

| Version | Date            | Changes                                             |
| ------- | --------------- | --------------------------------------------------- |
| 1.0     | 2026-07-14      | Initial appendix                                    |
| 1.x     | To be completed | Progressive addition of firmware and release hashes |

---

> [!IMPORTANT]
> Cryptographic hashes verify **integrity**, not **authenticity**. For public releases, SHA-256 should ideally be complemented by a digital signature (such as GPG or another signing mechanism) to ensure that downloaded artifacts originate from the expected publisher and have not been tampered with.