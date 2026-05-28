#!/bin/bash
# JALK Build Script
# Usage: ./build.sh [arch]

set -e

ARCH="${1:-x86_64}"
JOBS=$(nproc)
KERNEL_DIR="$(dirname "$0")/jalk-7.0.10"

echo "============================================"
echo "  JALK - Just Another Linux Kernel"
echo "  Building for architecture: $ARCH"
echo "  Jobs: $JOBS"
echo "============================================"

cd "$KERNEL_DIR"

# Ensure we have a config
if [ ! -f .config ]; then
    echo "  No config found, generating default..."
    make ARCH="$ARCH" defconfig
fi

# Build the kernel
echo "  Building kernel..."
make ARCH="$ARCH" -j"$JOBS"

echo "============================================"
echo "  JALK build complete for $ARCH"
echo "============================================"
