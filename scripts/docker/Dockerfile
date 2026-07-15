FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    android-sdk-libsparse-utils \
    android-sdk-platform-tools-common \
    adb \
    e2fsprogs \
    file \
    git \
    python3 \
    sudo \
    xz-utils \
    zip \
    unzip \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace
CMD ["/bin/bash"]
