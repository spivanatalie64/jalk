#!/bin/bash
# JALK Build Verification Script
# Verifies that jalk_defconfig produces a working kernel.
set -e

KERNEL_DIR="$(dirname "$0")/.."

echo ""
echo "  JALK Build Verification"
echo "  ======================="
echo ""

cd "$KERNEL_DIR"

# Check prerequisites
MISSING=""
for cmd in gcc make flex bison bc openssl; do
    if ! command -v "$cmd" &>/dev/null; then
        MISSING="$MISSING $cmd"
    fi
done
if [ -n "$MISSING" ]; then
    echo "  ERROR: Missing prerequisites:$MISSING"
    echo "  Install: apt-get install gcc make flex bison bc openssl libelf-dev libssl-dev"
    exit 1
fi

# Generate signing key if needed
if [ ! -f certs/signing_key.pem ] && grep -q "CONFIG_MODULE_SIG_ALL=y" .config 2>/dev/null; then
    echo "  0. Generating module signing key..."
    mkdir -p certs
    openssl req -new -newkey rsa:4096 -days 36500 -nodes -x509 \
        -subj "/CN=JALK Kernel Signing Key" \
        -keyout certs/signing_key.pem \
        -out certs/signing_key.pem 2>/dev/null
    echo "  Done."
fi

# Step 1: Configure
echo "  1. Configuring with jalk_defconfig..."
make ARCH=x86_64 jalk_defconfig >/dev/null 2>&1
echo "     Config OK ($(grep -c "^CONFIG_" .config) options)"

# Step 2: Verify critical options
echo "  2. Checking critical features..."
STATUS=0
for opt in CONFIG_JALK=y CONFIG_PREEMPT=y CONFIG_HZ=1000 \
           CONFIG_DEFAULT_TCP_CONG=\"bbr\" \
           CONFIG_SECURITY=y CONFIG_SECURITY_SELINUX=y \
           CONFIG_SECURITY_APPARMOR=y CONFIG_SECURITY_LANDLOCK=y \
           CONFIG_MODULE_SIG=y CONFIG_BTRFS_FS=y \
           CONFIG_INIT_ON_ALLOC_DEFAULT_ON=y \
           CONFIG_FORTIFY_SOURCE=y CONFIG_HARDENED_USERCOPY=y \
           CONFIG_USER_NS=y CONFIG_SCHED_CORE=y \
           CONFIG_IA32_EMULATION=y CONFIG_X86_X32=y; do
    key="${opt%%=*}"
    expected="${opt#*=}"
    actual=$(grep "^${key}=" .config 2>/dev/null | cut -d= -f2- || echo "MISSING")
    if [ "$actual" = "$expected" ]; then
        echo "     [PASS] ${key}=${actual}"
    else
        echo "     [FAIL] ${key}=${actual} (expected ${expected})"
        STATUS=1
    fi
done

# Step 3: Build bzImage
echo "  3. Building bzImage..."
make ARCH=x86_64 -j$(nproc) bzImage 2>&1 | tail -1 | grep "Kernel:" && \
    echo "     [PASS] bzImage ready" || { echo "     [FAIL] build failed"; STATUS=1; }

# Step 4: Verify image
if [ -f arch/x86/boot/bzImage ]; then
    SIZE=$(stat -c%s arch/x86/boot/bzImage)
    if [ "$SIZE" -gt 5000000 ]; then
        echo "     [PASS] bzImage size: $((SIZE/1024/1024))MB"
    else
        echo "     [WARN] bzImage unusually small: $SIZE bytes"
    fi
else
    echo "     [FAIL] bzImage not found"
    STATUS=1
fi

echo ""
if [ "$STATUS" -eq 0 ]; then
    echo "  Build verification: ALL PASSED"
else
    echo "  Build verification: SOME CHECKS FAILED"
fi
exit $STATUS
