#!/bin/bash
# JALK Syzkaller Fuzz Test Runner
# Setup and run syzkaller against JALK kernel.
set -e

KERNEL_DIR="$(dirname "$0")/../.."

echo ""
echo "  JALK Syzkaller Fuzz Testing"
echo "  ==========================="
echo ""

# Check for syzkaller
if [ ! -d "$HOME/go/src/github.com/google/syzkaller" ]; then
    echo "  INFO: syzkaller not found at ~/go/src/github.com/google/syzkaller"
    echo "  To install:"
    echo "    go install github.com/google/syzkaller/prog@latest"
    echo "    git clone https://github.com/google/syzkaller ~/go/src/github.com/google/syzkaller"
    echo ""
    echo "  Skipping syzkaller run..."
    exit 0
fi

cd "$KERNEL_DIR"

# Build kernel with syzkaller config
echo "  1. Building kernel with coverage instrumentation..."
make ARCH=x86_64 jalk-syzkaller-defconfig 2>/dev/null || {
    echo "  Creating syzkaller config..."
    make ARCH=x86_64 jalk_defconfig >/dev/null 2>&1
    ./scripts/config --enable KCOV
    ./scripts/config --enable KCOV_ENABLE_COMPARISONS
    ./scripts/config --enable KCOV_INSTRUMENT_ALL
    ./scripts/config --enable DEBUG_INFO
    ./scripts/config --enable DEBUG_INFO_DWARF4
    ./scripts/config --enable GCOV_KERNEL
    ./scripts/config --enable PROVE_LOCKING
    ./scripts/config --enable FAULT_INJECTION
    ./scripts/config --enable FAULT_INJECTION_DEBUG_FS
    ./scripts/config --enable DEBUG_FS
    ./scripts/config --enable STACKTRACE
    ./scripts/config --enable SLUB_DEBUG
    make ARCH=x86_64 olddefconfig >/dev/null 2>&1
}
make ARCH=x86_64 -j$(nproc) 2>&1 | tail -3

echo "  2. Generating syzkaller config..."
cat > /tmp/syz-manager.cfg << SYZEOF
{
    "target": "linux/amd64",
    "http": "127.0.0.1:56741",
    "workdir": "/tmp/syz-workdir",
    "kernel_obj": "$(pwd)",
    "image": "/tmp/syz-image.img",
    "sshkey": "/tmp/syz-key",
    "syzkaller": "$HOME/go/src/github.com/google/syzkaller",
    "procs": 4,
    "type": "qemu",
    "vm": {
        "count": 2,
        "kernel": "arch/x86/boot/bzImage",
        "cpu": 2,
        "mem": 2048
    }
}
SYZEOF

echo "  3. Starting fuzzing (24h default, Ctrl-C to stop)..."
mkdir -p /tmp/syz-workdir
"$HOME/go/src/github.com/google/syzkaller/bin/syz-manager" \
    -config /tmp/syz-manager.cfg 2>&1 | tee /tmp/syz-output.log

echo ""
echo "  Fuzzing complete. Check /tmp/syz-workdir for results."
