#!/bin/bash
# JALK DEB Package Builder
# Builds Debian/Ubuntu kernel packages.
set -e

KERNEL_DIR="$(dirname "$0")/.."
VERSION="7.0.10"
REVISION="1"
PACKAGE="linux-image-jalk"

echo ""
echo "  JALK DEB Package Builder"
echo "  ========================"
echo ""

cd "$KERNEL_DIR"

# Build kernel
echo "  1. Building kernel..."
make jalk_defconfig
make -j$(nproc) 2>&1 | tail -3

# Generate DEB packages
echo "  2. Building DEB packages..."
make -j$(nproc) deb-pkg 2>&1 | tail -5 || {
    echo "  Trying bindeb-pkg..."
    make -j$(nproc) bindeb-pkg 2>&1 | tail -5
}

echo ""
echo "  3. Packages created:"
ls -lh ../*.deb 2>/dev/null || echo "  (check parent directory)"

echo ""
echo "  To install:"
echo "    sudo dpkg -i ../linux-image-*-jalk*.deb"
echo "    sudo dpkg -i ../linux-headers-*-jalk*.deb"
