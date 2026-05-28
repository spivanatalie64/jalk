#!/bin/bash
# JALK RPM Package Builder
# Builds Fedora/RHEL kernel packages.
set -e

KERNEL_DIR="$(dirname "$0")/.."
VERSION="7.0.10"
RELEASE="1.jalk"

echo ""
echo "  JALK RPM Package Builder"
echo "  ========================"
echo ""

cd "$KERNEL_DIR"

# Build kernel
echo "  1. Building kernel..."
make jalk_defconfig
make -j$(nproc) 2>&1 | tail -3

# Generate RPM packages
echo "  2. Building RPM packages..."
make -j$(nproc) rpm-pkg 2>&1 | tail -5 || {
    echo "  Trying binrpm-pkg..."
    make -j$(nproc) binrpm-pkg 2>&1 | tail -5
}

echo ""
echo "  3. Packages created:"
ls -lh ~/rpmbuild/RPMS/*/kernel-*-jalk*.rpm 2>/dev/null || \
    ls -lh ../*.rpm 2>/dev/null || \
    echo "  (check ~/rpmbuild/RPMS/)"

echo ""
echo "  To install:"
echo "    sudo rpm -ivh ~/rpmbuild/RPMS/x86_64/kernel-*-jalk*.rpm"
