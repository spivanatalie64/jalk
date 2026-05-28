#!/bin/bash
# JALK Kernel Live Patching Setup
# Enables kpatch/livepatch support for zero-downtime updates.
set -e

KERNEL_DIR="$(dirname "$0")/.."

echo ""
echo "  JALK Live Patching Setup"
echo "  ========================"
echo ""

cd "$KERNEL_DIR"

# Enable livepatch in kernel config
echo "  1. Enabling livepatch in kernel config..."
./scripts/config --enable LIVEPATCH
./scripts/config --enable LIVEPATCH_KLP_HOOKS 2>/dev/null || true
./scripts/config --enable DYNAMIC_FTRACE
./scripts/config --enable DYNAMIC_FTRACE_WITH_REGS
./scripts/config --enable FTRACE_MCOUNT_RECORD
./scripts/config --enable KALLSYMS_ALL
./scripts/config --enable MODULE_UNLOAD

# Verify the config
make ARCH=x86_64 olddefconfig >/dev/null 2>&1
echo "  LIVEPATCH:"; grep "^CONFIG_LIVEPATCH=" .config
echo "  DYNAMIC_FTRACE:"; grep "^CONFIG_DYNAMIC_FTRACE=" .config

echo ""
echo "  2. kpatch build tools required:"
echo "    sudo apt-get install kpatch-build  # Debian/Ubuntu"
echo "    sudo dnf install kpatch-build      # Fedora"
echo ""
echo "  To create a live patch:"
echo "    kpatch-build -t vmlinux -s .config -j \$(nproc) \\"
echo "      -r /tmp/jalk-patch.patch"
echo ""
echo "  To apply a live patch:"
echo "    kpatch load livepatch-jalk.ko"
