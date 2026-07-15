---
title: "Appendix C — Docker Commands"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Reference"
language: "en"
last_updated: "2026-07-14"
---

# Appendix C — Docker Commands

> *"Docker provides a reproducible Linux environment, ensuring that firmware analysis and reconstruction produce consistent results across different host operating systems."*

---

# Purpose

This appendix summarizes the Docker commands and workflows used throughout the HY300 Ultimate project.

Rather than serving as a complete Docker tutorial, this document focuses on the commands required to:

- create a reproducible development environment;
- manipulate Android filesystem images;
- rebuild firmware components;
- isolate dependencies from the host operating system;
- automate repetitive tasks.

---

# Why Docker?

HY300 Ultimate was primarily developed on macOS while relying heavily on Linux tools.

Docker makes it possible to:

- use the same Linux environment on macOS, Linux, and Windows;
- eliminate host-specific dependency issues;
- simplify collaboration;
- reproduce experiments consistently;
- automate firmware reconstruction.

---

# Verify Docker Installation

Display Docker version.

```bash
docker --version
```

Display client and server information.

```bash
docker version
```

Display system information.

```bash
docker info
```

---

# Docker Images

List local images.

```bash
docker images
```

Download an image.

```bash
docker pull ubuntu:24.04
```

Remove an image.

```bash
docker rmi IMAGE_ID
```

Remove unused images.

```bash
docker image prune
```

---

# Containers

List running containers.

```bash
docker ps
```

List every container.

```bash
docker ps -a
```

Stop a container.

```bash
docker stop CONTAINER_ID
```

Start a container.

```bash
docker start CONTAINER_ID
```

Remove a container.

```bash
docker rm CONTAINER_ID
```

Remove stopped containers.

```bash
docker container prune
```

---

# Building Images

Build the project image.

```bash
docker build -t hy300 .
```

Force a clean build.

```bash
docker build --no-cache -t hy300 .
```

Specify an alternative Dockerfile.

```bash
docker build -f Dockerfile.dev -t hy300-dev .
```

---

# Running Containers

Interactive shell.

```bash
docker run -it hy300
```

Mount the current directory.

```bash
docker run \
-it \
-v $(pwd):/workspace \
hy300
```

Start Bash.

```bash
docker run -it hy300 bash
```

Automatically remove the container when it exits.

```bash
docker run --rm -it hy300
```

---

# Volumes

Create a persistent volume.

```bash
docker volume create hy300-data
```

List volumes.

```bash
docker volume ls
```

Inspect a volume.

```bash
docker volume inspect hy300-data
```

Remove a volume.

```bash
docker volume rm hy300-data
```

Volumes preserve data independently of container lifecycle.

---

# Bind Mounts

Share a local project directory.

```bash
-v $(pwd):/workspace
```

Example.

```bash
docker run \
-it \
-v $(pwd):/workspace \
hy300
```

Bind mounts are the preferred solution during firmware development because they provide immediate access to project files.

---

# Copying Files

Copy a file into a container.

```bash
docker cp system.img CONTAINER:/workspace/
```

Copy a file from a container.

```bash
docker cp CONTAINER:/workspace/output.img .
```

---

# Executing Commands

Open a shell inside a running container.

```bash
docker exec -it CONTAINER bash
```

Execute a single command.

```bash
docker exec CONTAINER ls -la
```

---

# Viewing Logs

Display logs.

```bash
docker logs CONTAINER
```

Follow logs in real time.

```bash
docker logs -f CONTAINER
```

Show the last 100 log entries.

```bash
docker logs --tail 100 CONTAINER
```

---

# Docker Compose

Start every service.

```bash
docker compose up
```

Start in background.

```bash
docker compose up -d
```

Rebuild services.

```bash
docker compose up --build
```

Stop every service.

```bash
docker compose down
```

Display service status.

```bash
docker compose ps
```

---

# Cleaning Up

Remove unused resources.

```bash
docker system prune
```

Remove every unused image.

```bash
docker system prune -a
```

Remove unused volumes.

```bash
docker volume prune
```

---

# Apple Silicon Support

Display host architecture.

```bash
uname -m
```

Run an x86 image.

```bash
docker run \
--platform linux/amd64 \
ubuntu
```

Run a native ARM image.

```bash
docker run \
--platform linux/arm64 \
ubuntu
```

---

# Environment Variables

Pass a variable.

```bash
docker run \
-e VARIABLE=value \
hy300
```

Load variables from a file.

```bash
docker run \
--env-file .env \
hy300
```

---

# Minimal Dockerfile

```dockerfile
FROM ubuntu:24.04

RUN apt update && apt install -y \
    adb \
    e2fsprogs \
    git \
    wget \
    unzip \
    python3

WORKDIR /workspace

CMD ["/bin/bash"]
```

---

# Recommended Project Structure

```text
docker/

├── Dockerfile
├── docker-compose.yml
├── entrypoint.sh
├── install-tools.sh
├── scripts/
└── README.md
```

---

# Recommended Workflow

```text
Clone Repository

↓

Build Docker Image

↓

Start Container

↓

Extract Firmware

↓

Analyze Images

↓

Modify Partitions

↓

Rebuild Firmware

↓

Validate Build

↓

Publish Release
```

---

# Command Summary

| Task             | Command               |
| ---------------- | --------------------- |
| Check version    | `docker --version`    |
| List images      | `docker images`       |
| List containers  | `docker ps`           |
| Build image      | `docker build`        |
| Run container    | `docker run`          |
| Execute command  | `docker exec`         |
| Copy files       | `docker cp`           |
| View logs        | `docker logs`         |
| Compose services | `docker compose up`   |
| Clean resources  | `docker system prune` |

---

# Best Practices

- Use versioned Docker images.
- Keep the host operating system as clean as possible.
- Mount the Git repository instead of copying files.
- Pin tool versions whenever practical.
- Store installation scripts inside the repository.
- Remove unused images and containers regularly.
- Document every dependency required for firmware reconstruction.

---

# Docker Usage in HY300 Ultimate

This section is reserved for the Docker commands actually used during the project.

It will gradually include:

- image build commands;
- Docker Compose configuration;
- bind mount layout;
- Apple Silicon compatibility notes;
- automation scripts;
- build logs;
- troubleshooting procedures.

Keeping real project commands separate from generic examples improves reproducibility and simplifies future maintenance.

---

# Troubleshooting

| Problem                     | Possible Cause        | Suggested Solution                                 |
| --------------------------- | --------------------- | -------------------------------------------------- |
| Docker daemon unavailable   | Docker is not running | Start Docker Desktop or the Docker service         |
| Container exits immediately | Invalid entrypoint    | Verify the image configuration                     |
| Empty mounted directory     | Incorrect bind mount  | Check the `-v` path                                |
| Permission denied           | UID/GID mismatch      | Adjust file ownership or container user            |
| Image too large             | Unused layers         | Run `docker system prune`                          |
| Architecture mismatch       | x86 image on ARM      | Use `--platform linux/amd64` or a native ARM image |

---

> [!TIP]
> One of Docker's greatest strengths is reproducibility. If every firmware reconstruction is performed inside the same container image, differences caused by host operating systems, library versions, or missing dependencies are dramatically reduced, making experiments easier to reproduce and debug.