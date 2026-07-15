---
title: "Initial Hypotheses"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Completed"
language: "en"
last_updated: "2026-07-14"
---

# Initial Hypotheses

> *"Every investigation begins with assumptions. Good engineering requires treating them as hypotheses to be tested—not as facts to be defended."*

---

# Introduction

Once the target device had been identified, the next step was to establish a set of initial hypotheses.

These hypotheses did not represent conclusions.

Instead, they defined the questions that would guide the remainder of the investigation.

Reverse engineering is significantly more efficient when experiments are driven by clearly stated hypotheses rather than random exploration.

Throughout this project, every hypothesis was expected to be either:

- confirmed by evidence;
- refined as new information became available; or
- rejected when contradicted by observations.

---

# Why Formulate Hypotheses?

Embedded Android systems contain hundreds of interacting components.

Attempting to understand every subsystem simultaneously is impractical.

Formulating hypotheses provides:

- clear research priorities;
- measurable objectives;
- structured experimentation;
- reproducible reasoning.

This methodology reduces unnecessary modifications while improving the quality of the documentation.

---

# Initial Observations

Before defining hypotheses, several facts had already been established.

- The projector runs Android.
- The hardware platform is based on a Rockchip SoC.
- ADB access is available.
- The firmware uses dynamic partitions.
- Multiple proprietary applications are installed.
- Several background services are active during startup.

These observations formed the baseline from which the investigation continued.

---

# Hypothesis 1 — Proprietary Services Influence System Behavior

The firmware includes several OEM services that are absent from standard Android distributions.

Initial assumption:

> Some proprietary background services are responsible for hardware management, update mechanisms, or projector-specific functionality.

Possible examples include:

- keystone correction;
- autofocus;
- OTA management;
- device activation;
- hardware monitoring.

This hypothesis requires service analysis before considering removal or modification.

---

# Hypothesis 2 — Not Every OEM Application Is Essential

Consumer firmware often contains applications that serve different purposes.

Some are critical.

Others are optional.

Initial assumption:

> A significant number of bundled applications can be removed without affecting the stability of the operating system.

This hypothesis will later be validated through dependency analysis and controlled testing.

---

# Hypothesis 3 — Android Follows a Mostly Standard Architecture

Although customized by the manufacturer, the firmware is expected to preserve the standard Android architecture.

This includes:

- Linux kernel;
- init process;
- Android Framework;
- Binder IPC;
- system services;
- dynamic partitions.

If confirmed, existing Android reverse engineering techniques should remain applicable.

---

# Hypothesis 4 — Dynamic Partitions Can Be Rebuilt

Because the firmware uses logical partitions stored within `super.img`, reconstruction should be technically possible.

Initial assumption:

> Android's standard partition tools are sufficient to extract, modify, and rebuild the firmware without changing the original storage layout.

This hypothesis will later be validated using:

- `lpunpack`;
- `lpdump`;
- `lpmake`;
- ext4 utilities.

---

# Hypothesis 5 — Vendor Libraries Control Hardware Features

Several projector-specific functions appear to depend on proprietary native libraries.

Initial assumption:

- image processing;
- graphics acceleration;
- autofocus;
- keystone correction;
- display management;

are implemented primarily through vendor libraries rather than Android Framework code.

Understanding these libraries will become a major objective of the reverse engineering phase.

---

# Hypothesis 6 — OTA Updates Perform Integrity Checks

The firmware supports Over-The-Air updates.

Initial assumption:

> The update process performs integrity verification before applying a package.

Possible mechanisms include:

- SHA verification;
- AVB metadata;
- version validation;
- cryptographic signatures.

This hypothesis will later be explored during the OTA analysis.

---

# Hypothesis 7 — System Properties Reveal Hidden Behavior

Android exposes hundreds of runtime properties.

Initial assumption:

> Several vendor-specific properties configure features that are not accessible through the user interface.

Examples include:

- debug options;
- hardware capabilities;
- display configuration;
- service behavior.

These properties will later be analyzed using `getprop`.

---

# Hypothesis 8 — A Minimal Firmware Is Achievable

One long-term objective of the project is reducing unnecessary complexity.

Initial assumption:

> A cleaner firmware can be produced without sacrificing stability or essential projector functionality.

This objective requires extensive validation before implementation.

---

# Risk Assessment

Every hypothesis carries potential risks.

| Hypothesis         | Primary Risk                           |
| ------------------ | -------------------------------------- |
| OEM services       | Removing critical functionality        |
| OEM applications   | Breaking system dependencies           |
| Dynamic partitions | Producing an unbootable firmware       |
| Vendor libraries   | Hardware features becoming unavailable |
| OTA mechanisms     | Preventing future updates              |
| System properties  | Unexpected configuration changes       |

These risks justify a conservative and incremental approach.

---

# Validation Strategy

Every hypothesis follows the same validation process.

```text
Observation

↓

Hypothesis

↓

Experiment

↓

Evidence Collection

↓

Analysis

↓

Conclusion

↓

Documentation
```

A hypothesis is never considered valid without reproducible evidence.

---

# Evidence Categories

The investigation relies on multiple independent sources of evidence.

Examples include:

- Android properties;
- system logs;
- filesystem analysis;
- binary inspection;
- process monitoring;
- partition contents;
- runtime behavior;
- controlled experiments.

Combining multiple evidence sources increases confidence in the conclusions.

---

# Engineering Principles

Throughout the project, several rules govern hypothesis validation.

- Never confuse assumptions with facts.
- Modify only one variable at a time.
- Preserve original firmware.
- Keep detailed experiment logs.
- Document unsuccessful experiments.
- Revise hypotheses whenever new evidence emerges.

These principles ensure that conclusions remain objective and reproducible.

---

# Expected Outcomes

By validating these initial hypotheses, the project aims to:

- understand the firmware architecture;
- identify essential and optional components;
- map software dependencies;
- improve firmware maintainability;
- enable safe and reproducible customization.

The hypotheses therefore define the roadmap for the remainder of the investigation.

---

# Summary

At this stage, no firmware modifications had yet been performed.

The investigation remained focused on observation, evidence collection, and hypothesis formulation.

Establishing clear research questions before making changes provides a structured foundation for the reverse engineering work that follows.

---

# Next Chapter

The next step is to explore the device from a network perspective.

Identifying available network services, communication interfaces, and debugging capabilities will provide additional insight into how the firmware interacts with external systems and how future analysis can be performed.

---

> [!IMPORTANT]
> One of the defining characteristics of rigorous reverse engineering is the willingness to abandon an attractive hypothesis when experimental evidence contradicts it. Throughout HY300 Ultimate, observations always take precedence over assumptions.