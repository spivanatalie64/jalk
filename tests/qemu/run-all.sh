#!/bin/bash
# JALK Multi-Architecture QEMU Boot Test Runner
set -e

DIR="$(dirname "$0")"
RESULTS=()
ARCHITECTURES=("x86_64" "i386" "arm64" "arm" "riscv" "powerpc" "s390")

echo ""
echo "  JALK Multi-Architecture Boot Test Suite"
echo "  ======================================="
echo ""

for arch in "${ARCHITECTURES[@]}"; do
    echo "  Testing $arch..."
    if bash "$DIR/boot-test.sh" "$arch"; then
        RESULTS+=("$arch: PASS")
    else
        RESULTS+=("$arch: FAIL")
    fi
    echo ""
done

echo "  Results:"
for r in "${RESULTS[@]}"; do
    echo "    $r"
done
