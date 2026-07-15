---
title: "What Not to Do"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Completed"
language: "en"
last_updated: "2026-07-15"
---

# What Not to Do

> *"Good firmware engineering is defined as much by the mistakes it avoids as by the features it adds. Knowing what not to change is often more valuable than knowing what can be changed."*

---

# Introduction

After documenting realistic optimization strategies, it is equally important to discuss their limits.

Firmware engineering often encourages experimentation, but uncontrolled experimentation can easily produce unstable systems, difficult debugging sessions, or unrecoverable firmware images.

Throughout the HY300 Ultimate project, many engineering decisions were guided not only by what could be modified, but also by what should deliberately remain untouched until sufficient evidence justified a change.

This chapter summarizes the engineering practices that should generally be avoided when developing custom Android firmware.

---

# Objectives

This chapter aims to:

- identify common firmware engineering mistakes;
- explain why excessive optimization can be harmful;
- encourage evidence-based decision making;
- promote reproducible engineering practices;
- improve long-term firmware stability.

Rather than listing forbidden actions, the chapter presents engineering principles that reduce unnecessary risk.

---

# Engineering Philosophy

The project consistently followed this principle:

```text
Observe

↓

Understand

↓

Document

↓

Modify

↓

Validate

↓

Repeat
```

Skipping one of these stages often increases engineering uncertainty.

---

# Avoid Blind Modifications

One of the most common mistakes in firmware engineering is modifying components without understanding their purpose.

Examples include:

- deleting unfamiliar applications;
- replacing native libraries without compatibility analysis;
- changing configuration files without documentation;
- modifying partitions directly.

Every modification should be supported by documented observations.

---

# Avoid Multiple Simultaneous Changes

Changing several variables at once makes troubleshooting significantly more difficult.

Instead of:

```text
Ten Changes

↓

One Test
```

Prefer:

```text
One Change

↓

Validation

↓

Next Change
```

Incremental engineering makes regressions easier to identify.

---

# Do Not Ignore Backups

A custom firmware should never become the only copy of a working system.

Recommended workflow:

```text
Original Firmware

↓

Verified Backup

↓

Working Copy

↓

Engineering
```

Original firmware images should remain immutable throughout the project.

---

# Avoid Modifying Production Artifacts

Engineering should always occur on working copies.

```text
Original Image

↓

Copy

↓

Modification

↓

Validation
```

Editing archived firmware directly risks losing the project's reference state.

---

# Do Not Skip Validation

Successful image generation does not necessarily indicate a successful firmware build.

Validation should include:

- filesystem integrity;
- metadata consistency;
- documented checksums;
- runtime observation;
- functional verification.

Every engineering milestone deserves systematic validation.

---

# Avoid Assumptions

Component names rarely describe their full purpose.

Instead of assuming functionality based on:

- package names;
- library names;
- file size;
- startup order;

prefer:

```text
Observation

↓

Documentation

↓

Dependency Analysis

↓

Conclusion
```

Evidence should always guide engineering decisions.

---

# Avoid Chasing Benchmark Scores

Optimization should improve the user experience—not merely synthetic measurements.

Meaningful engineering objectives include:

- stability;
- responsiveness;
- maintainability;
- reproducibility;
- reliability.

A slightly slower but stable firmware is often preferable to an unstable "optimized" build.

---

# Avoid Removing Components Without Dependency Analysis

Many Android components interact indirectly.

Simplified example:

```text
Application

↓

Service

↓

Native Library

↓

Hardware
```

Removing one layer without understanding the others may introduce unexpected regressions.

---

# Avoid Ignoring Documentation

Engineering knowledge quickly becomes difficult to reproduce when documentation is neglected.

Every significant modification should record:

- firmware version;
- rationale;
- affected components;
- validation results;
- engineering notes.

Documentation is part of the firmware—not separate from it.

---

# Avoid Over-Optimization

Every optimization introduces complexity.

Examples include:

- aggressive memory tuning;
- excessive service removal;
- unnecessary filesystem changes;
- undocumented configuration modifications.

Small, measurable improvements generally provide more reliable long-term results.

---

# Maintain Reproducibility

Every firmware revision should remain reproducible.

```text
Source

↓

Modification

↓

Validation

↓

Documentation

↓

Release
```

If a build cannot be reproduced, future maintenance becomes significantly more difficult.

---

# Engineering Trade-Offs

Firmware development frequently requires balancing competing objectives.

| Objective               | Possible Trade-Off           |
| ----------------------- | ---------------------------- |
| Maximum speed           | Reduced flexibility          |
| Minimal software        | Fewer features               |
| Smaller image           | Less available functionality |
| Extensive customization | Increased maintenance        |
| Aggressive optimization | Higher engineering risk      |

Understanding these trade-offs leads to better engineering decisions.

---

# Reverse Engineering Workflow

The project consistently followed the methodology below.

```text
Measure

↓

Analyze

↓

Modify

↓

Validate

↓

Compare

↓

Document

↓

Archive
```

Every stage contributed to long-term project stability.

---

# Engineering Observations

Several practical lessons emerged.

- Incremental changes simplify debugging.
- Documentation reduces future engineering effort.
- Conservative optimization improves maintainability.
- Reproducibility is more valuable than experimentation.
- Stable firmware is more useful than highly customized firmware.

---

# Common Challenges

Typical engineering mistakes include:

| Mistake                       | Possible Consequence    |
| ----------------------------- | ----------------------- |
| No backups                    | Difficult recovery      |
| Multiple simultaneous changes | Hard debugging          |
| Missing validation            | Unreliable firmware     |
| Poor documentation            | Reduced reproducibility |
| Blind optimization            | System instability      |
| Ignoring dependencies         | Unexpected regressions  |

Most of these issues are avoidable through disciplined engineering.

---

# Best Practices

When developing custom firmware:

- Preserve original firmware images.
- Change one variable at a time.
- Validate every modification.
- Document every engineering decision.
- Maintain reproducible workflows.
- Prioritize long-term reliability over short-term experimentation.

---

# Summary

The most successful firmware engineering projects are defined not only by the features they introduce, but also by the risks they deliberately avoid.

Throughout the HY300 Ultimate project, conservative engineering practices, systematic validation, careful documentation, and incremental development proved more valuable than aggressive experimentation.

These principles significantly improved reproducibility, maintainability, and long-term firmware quality.

---

# Next Chapter

With the engineering methodology now fully established, the next chapter explores the broader responsibilities associated with publishing firmware research.

Topics include:

- responsible disclosure;
- documentation standards;
- reproducible research;
- ethical publication;
- community collaboration;
- long-term maintenance.

---

> [!IMPORTANT]
> The most reliable firmware engineers are not those who modify the greatest number of components—they are those who understand which components should remain unchanged until sufficient evidence justifies a carefully planned modification. Discipline, documentation, and validation are the strongest optimization tools available.