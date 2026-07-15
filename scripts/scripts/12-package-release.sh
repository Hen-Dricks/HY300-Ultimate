#!/usr/bin/env bash
set -Eeuo pipefail
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
source "$SCRIPT_DIR/lib/common.sh"
require_cmd sha256sum
require_cmd tar

VERSION=${1:-}
SUPER=${2:-}
OUT_ROOT=${3:-"releases"}
[[ -n "$VERSION" && -f "$SUPER" ]] || die "Usage: $0 VERSION SUPER_IMAGE [RELEASE_ROOT]"
[[ "$VERSION" =~ ^[A-Za-z0-9._-]+$ ]] || die "Unsafe version string"

RELEASE_DIR="$OUT_ROOT/$VERSION"
[[ ! -e "$RELEASE_DIR" ]] || die "Release already exists: $RELEASE_DIR"
ensure_dir "$RELEASE_DIR/firmware"
cp -p "$SUPER" "$RELEASE_DIR/firmware/super-$VERSION.img"
sha256sum "$RELEASE_DIR/firmware/super-$VERSION.img" > "$RELEASE_DIR/SHA256SUMS"
cat > "$RELEASE_DIR/RELEASE.md" <<EOT
# HY300 Ultimate $VERSION

- Build date: $(date -u +%Y-%m-%dT%H:%M:%SZ)
- Artifact: \`firmware/super-$VERSION.img\`
- Integrity: see \`SHA256SUMS\`

Add validated changes, test results, known limitations, and base firmware information before publication.
EOT

tar -C "$OUT_ROOT" -czf "$OUT_ROOT/hy300-ultimate-$VERSION.tar.gz" "$VERSION"
sha256sum "$OUT_ROOT/hy300-ultimate-$VERSION.tar.gz" > "$OUT_ROOT/hy300-ultimate-$VERSION.tar.gz.sha256"
log "Created release archive: $OUT_ROOT/hy300-ultimate-$VERSION.tar.gz"
