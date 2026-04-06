#!/bin/bash
set -euo pipefail
DEST="${HOME}/.local/bin"
mkdir -p "$DEST"
cp cast-parallel.sh "$DEST/cast-parallel"
chmod +x "$DEST/cast-parallel"
echo "Installed cast-parallel to $DEST/cast-parallel"
