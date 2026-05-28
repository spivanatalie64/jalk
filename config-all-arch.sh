#!/bin/bash
# JALK Multi-Architecture Config Generator
# Generates default configs for all supported architectures

set -e

KERNEL_DIR="$(dirname "$0")/jalk-7.0.10"
CONFIG_DIR="$(dirname "$0")/configs"

mkdir -p "$CONFIG_DIR"

ARCHITECTURES=(
    "alpha"
    "arc"
    "arm"
    "arm64"
    "csky"
    "hexagon"
    "loongarch"
    "m68k"
    "microblaze"
    "mips"
    "nios2"
    "openrisc"
    "parisc"
    "powerpc"
    "riscv"
    "s390"
    "sh"
    "sparc"
    "um"
    "x86"
    "xtensa"
)

cd "$KERNEL_DIR"

for arch in "${ARCHITECTURES[@]}"; do
    echo "Generating config for $arch..."
    make ARCH="$arch" defconfig > /dev/null 2>&1 || {
        echo "  WARNING: defconfig failed for $arch, trying allnoconfig..."
        make ARCH="$arch" allnoconfig > /dev/null 2>&1 || echo "  SKIPPED: $arch"
    }
    cp .config "$CONFIG_DIR/config-$arch"
done

echo ""
echo "Configs generated in $CONFIG_DIR"
ls -la "$CONFIG_DIR"/
