# HY300 Ultimate — Engineering Scripts

Safe, reproducible helper scripts for backup, extraction, validation, rebuilding and release packaging.

## Included scripts

- `00-check-host.sh` — verifies required host tools.
- `01-device-info.sh` — captures non-destructive Android device information.
- `02-dump-partitions.sh` — dumps selected partitions through ADB using `dd`.
- `03-hash-artifacts.sh` — generates SHA-256 manifests.
- `04-inspect-super.sh` — inspects LP metadata with `lpdump`.
- `05-extract-super.sh` — extracts logical partitions using `lpunpack`.
- `06-convert-sparse.sh` — converts Android sparse images to raw images.
- `07-check-ext4.sh` — runs read-only ext4 checks by default.
- `08-mount-image.sh` — mounts an ext4 image read-only by default.
- `09-unmount-image.sh` — safely unmounts an image mount point.
- `10-build-super.sh` — rebuilds `super.img` from a declarative config.
- `11-validate-build.sh` — validates output metadata, filesystems and hashes.
- `12-package-release.sh` — creates a release directory and archive.
- `lib/common.sh` — shared helpers.

## Safety model

- Original images are never modified by default.
- Destructive or write operations require explicit confirmation.
- `e2fsck` runs in no-modification mode unless `--repair` is supplied.
- Image mounts are read-only unless `--rw` is supplied.
- No automatic flashing script is included.

## Quick start

```bash
chmod +x scripts/*.sh
./scripts/00-check-host.sh
./scripts/01-device-info.sh output/device-info
./scripts/02-dump-partitions.sh output/dumps boot vbmeta super
./scripts/04-inspect-super.sh output/dumps/super.img output/super-layout
./scripts/05-extract-super.sh output/dumps/super.img output/extracted
```

## Rebuilding `super.img`

Copy `config/super-layout.example.env` to a project-specific file and fill it using the values reported by `lpdump`.

```bash
cp config/super-layout.example.env config/super-layout.env
$EDITOR config/super-layout.env
./scripts/10-build-super.sh config/super-layout.env output/extracted output/rebuilt/super.img
./scripts/11-validate-build.sh output/rebuilt/super.img output/validation
```

> Always compare the generated LP metadata with the original firmware before testing a build.
