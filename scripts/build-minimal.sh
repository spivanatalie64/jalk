#!/bin/bash
# JALK Minimal Resource Build
# Builds the kernel with as few resources as possible.
#
# Usage: ./scripts/build-minimal.sh [arch]
set -e

ARCH="${1:-x86_64}"
JOBS="${2:-$(nproc)}"
START=$(date +%s)

echo ""
echo "  JALK Minimal Build"
echo "  Arch: $ARCH  Jobs: $JOBS"
echo "  ==================="
echo ""

cd "$(dirname "$0")/.."

# Step 1: Minimal config
echo "  1. Generating minimal config..."
make ARCH="$ARCH" allnoconfig
echo "CONFIG_JALK=y" >> .config
echo "CONFIG_64BIT=y" >> .config
echo "CONFIG_X86_64=y" >> .config
echo "CONFIG_PRINTK=y" >> .config
echo "CONFIG_BINFMT_ELF=y" >> .config
make ARCH="$ARCH" olddefconfig

# Step 2: Only what's needed
echo "  2. Building minimal kernel..."
if command -v ccache &>/dev/null; then
    export CC="ccache gcc"
    echo "  USING: ccache"
fi

# Use single job to limit memory
make ARCH="$ARCH" -j"$JOBS" bzImage 2>&1 | tail -5

END=$(date +%s)
echo ""
echo "  Build complete: $((END - START))s"
echo "  Image: arch/$ARCH/boot/bzImage"
ls -lh "arch/$ARCH/boot/bzImage" 2>/dev/null || echo "  (check arch dir)"
