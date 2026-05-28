#!/bin/bash
# JALK Initramfs Generator
# Creates initramfs/initrd for JALK kernels.
set -e

KERNEL_DIR="$(dirname "$0")/.."
VERSION="7.0.10-jalk"

echo ""
echo "  JALK Initramfs Generator"
echo "  ========================"
echo ""

cd "$KERNEL_DIR"

# Use dracut if available
if command -v dracut &>/dev/null; then
    echo "  1. Using dracut..."
    sudo dracut --force --kver "$VERSION" "/boot/initramfs-${VERSION}.img"
    echo "  Initramfs: /boot/initramfs-${VERSION}.img"

# Fall back to mkinitcpio (Arch)
elif command -v mkinitcpio &>/dev/null; then
    echo "  1. Using mkinitcpio..."
    # Preset filename matches what the kernel install hook expects
    sudo mkinitcpio -k "$VERSION" -g "/boot/initramfs-${VERSION}.img"
    echo "  Initramfs: /boot/initramfs-${VERSION}.img"

# Fall back to manual cpio
else
    echo "  1. No dracut/mkinitcpio found, building minimal initramfs..."
    mkdir -p /tmp/jalk-initramfs/{bin,dev,etc,proc,sys}
    
    # Create a simple init script
    cat > /tmp/jalk-initramfs/init << 'INITEOF'
#!/bin/sh
mount -t proc none /proc
mount -t sysfs none /sys
mount -t devtmpfs none /dev
echo "JALK: Mounted basic filesystems"
exec /bin/sh
INITEOF
    chmod +x /tmp/jalk-initramfs/init
    
    # Package it
    cd /tmp/jalk-initramfs
    find . | cpio -H newc -o | gzip > "/boot/initramfs-${VERSION}.img"
    cd "$KERNEL_DIR"
    rm -rf /tmp/jalk-initramfs
    echo "  Initramfs: /boot/initramfs-${VERSION}.img (minimal)"
fi

echo ""
echo "  Install kernel:"
echo "    sudo cp arch/x86/boot/bzImage /boot/vmlinuz-${VERSION}"
echo "    sudo cp System.map /boot/System.map-${VERSION}"
