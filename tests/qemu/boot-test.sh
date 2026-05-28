#!/bin/bash
# JALK QEMU Boot Test
# Boot-tests the kernel on simulated hardware for a given architecture.
#
# Usage: ./tests/qemu/boot-test.sh <arch> [kernel_image]
set -e

ARCH="${1:-x86_64}"
KERNEL="${2:-arch/x86/boot/bzImage}"
TIMEOUT=30

echo "  JALK TEST: QEMU boot test for $ARCH"

case "$ARCH" in
    x86_64)
        QEMU="qemu-system-x86_64"
        MACHINE="-machine q35,accel=kvm:tcg"
        CPU="-cpu host"
        EXTRA="-serial stdio -display none"
        ;;
    i386)
        QEMU="qemu-system-i386"
        MACHINE="-machine q35,accel=kvm:tcg"
        CPU="-cpu host"
        KERNEL="arch/x86/boot/bzImage"
        EXTRA="-serial stdio -display none"
        ;;
    arm64)
        QEMU="qemu-system-aarch64"
        MACHINE="-machine virt,gic-version=3"
        CPU="-cpu max"
        KERNEL="arch/arm64/boot/Image"
        EXTRA="-serial stdio -display none"
        ;;
    arm)
        QEMU="qemu-system-arm"
        MACHINE="-machine virt"
        CPU="-cpu max"
        EXTRA="-serial stdio -display none"
        ;;
    riscv)
        QEMU="qemu-system-riscv64"
        MACHINE="-machine virt"
        CPU="-cpu rv64"
        KERNEL="arch/riscv/boot/Image"
        EXTRA="-serial stdio -display none"
        ;;
    powerpc)
        QEMU="qemu-system-ppc64"
        MACHINE="-machine pseries"
        CPU="-cpu power10"
        EXTRA="-serial stdio -display none"
        ;;
    s390)
        QEMU="qemu-system-s390x"
        MACHINE="-machine s390-ccw-virtio"
        CPU="-cpu max"
        EXTRA="-serial stdio -display none"
        ;;
    *)
        echo "  ERROR: Unknown architecture: $ARCH"
        echo "  Supported: x86_64, i386, arm64, arm, riscv, powerpc, s390"
        exit 1
        ;;
esac

if [ ! -f "$KERNEL" ]; then
    echo "  ERROR: Kernel image not found: $KERNEL"
    echo "  Build it first: make ARCH=$ARCH -j\$(nproc)"
    exit 1
fi

# Check QEMU availability
if ! command -v "$QEMU" &>/dev/null; then
    echo "  WARN: $QEMU not installed - skipping boot test"
    echo "  Install: apt-get install qemu-system-$ARCH"
    exit 0
fi

echo "  Booting kernel (timeout: ${TIMEOUT}s)..."
timeout "$TIMEOUT" "$QEMU" \
    $MACHINE \
    $CPU \
    -kernel "$KERNEL" \
    -append "console=ttyS0 panic=-1 rdinit=/bin/sh" \
    $EXTRA 2>&1 | grep -q "JALK\|Linux version" && {
    echo "  PASS: Kernel booted successfully on $ARCH"
    exit 0
} || {
    echo "  FAIL: Kernel did not boot within ${TIMEOUT}s on $ARCH"
    exit 1
}
