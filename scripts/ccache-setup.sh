#!/bin/bash
# JALK ccache Setup
# Configures ccache for faster incremental builds.
set -e

echo ""
echo "  JALK ccache Setup"
echo "  ================="
echo ""

# Check ccache
if ! command -v ccache &>/dev/null; then
    echo "  Installing ccache..."
    if command -v apt-get &>/dev/null; then
        sudo apt-get install -y ccache
    elif command -v pacman &>/dev/null; then
        sudo pacman -S --noconfirm ccache
    elif command -v dnf &>/dev/null; then
        sudo dnf install -y ccache
    else
        echo "  WARN: Please install ccache manually"
        exit 1
    fi
fi

# Configure ccache
ccache --max-size=10G
ccache --show-stats

# Set up ccache for kernel build
echo ""
echo "  To use ccache for kernel builds:"
echo "    export CC=\"ccache gcc\""
echo "    export CC=\"ccache clang\""
echo "    make -j\$(nproc)"
echo ""
echo "  Or add to ~/.bashrc:"
echo "    export CC=\"ccache \${CC:-gcc}\""
echo ""

# Create wrapper if desired
if [ ! -f /usr/local/bin/gcc ]; then
    echo "  Alternatively, symlink ccache as compiler:"
    echo "    sudo ln -sf \$(which ccache) /usr/local/bin/gcc"
    echo "    sudo ln -sf \$(which ccache) /usr/local/bin/g++"
fi

ccache --show-stats
