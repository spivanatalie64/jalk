#!/bin/bash
# JALK Firmware Inclusion Script
# Fetches and includes required firmware for kernel drivers.
set -e

KERNEL_DIR="$(dirname "$0")/.."
FW_DIR="${KERNEL_DIR}/firmware"

echo ""
echo "  JALK Firmware Setup"
echo "  ==================="
echo ""

cd "$KERNEL_DIR"

# Create firmware directory
mkdir -p "$FW_DIR"

# Check if linux-firmware is installed
if [ -d /usr/lib/firmware ]; then
    echo "  1. Copying recommended firmware from system..."
    RECOMMENDED_FW=(
        "iwlwifi-*.ucode"
        "rtl_nic/*"
        "rtlwifi/*"
        "e100/*"
        "e1000/*"
        "ixgbe/*"
        "i40e/*"
        "bnx2/*"
        "bnx2x/*"
        "qla2xxx/*"
        "mpt3sas/*"
        "nvme/*"
    )
    
    for pattern in "${RECOMMENDED_FW[@]}"; do
        for f in /usr/lib/firmware/$pattern; do
            if [ -f "$f" ]; then
                mkdir -p "$FW_DIR/$(dirname ${f#/usr/lib/firmware/})"
                cp "$f" "$FW_DIR/${f#/usr/lib/firmware/}"
            fi
        done
    done
    
    echo "  Copied $(find "$FW_DIR" -type f | wc -l) firmware files."
else
    echo "  1. No system firmware found. Installing linux-firmware..."
    if command -v apt-get &>/dev/null; then
        sudo apt-get install -y linux-firmware
    elif command -v dnf &>/dev/null; then
        sudo dnf install -y linux-firmware
    elif command -v pacman &>/dev/null; then
        sudo pacman -S --noconfirm linux-firmware
    fi
    
    if [ -d /usr/lib/firmware ]; then
        cp -r /usr/lib/firmware/* "$FW_DIR/"
        echo "  Copied all firmware."
    fi
fi

# List by driver
echo ""
echo "  2. Firmware by driver:"
for dir in "$FW_DIR"/*/; do
    count=$(find "$dir" -type f 2>/dev/null | wc -l)
    [ "$count" -gt 0 ] && echo "    $(basename "$dir"): $count files"
done

# Generate Kconfig for firmware inclusion
cat > "${FW_DIR}/Kconfig" << KCONFIGEOF
config JALK_EXTRA_FIRMWARE
    bool "Include JALK recommended firmware"
    default y
    help
      Include firmware required by common JALK-supported drivers.
      This adds ~50MB to the kernel source tree but ensures all
      hardware works out of the box.
KCONFIGEOF

echo ""
echo "  Firmware ready at: $FW_DIR"
echo "  Size: $(du -sh "$FW_DIR" | awk '{print $1}')"
