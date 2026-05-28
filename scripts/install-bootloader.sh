#!/bin/bash
# JALK Bootloader Configuration
# Configures GRUB or systemd-boot for JALK kernel.
set -e

VERSION="7.0.10-jalk"
KERNEL_IMAGE="/boot/vmlinuz-${VERSION}"
INITRAMFS="/boot/initramfs-${VERSION}.img"

echo ""
echo "  JALK Bootloader Configuration"
echo "  ============================="
echo ""

echo "  Kernel: $KERNEL_IMAGE"
echo "  Initramfs: $INITRAMFS"

# GRUB
if command -v grub-mkconfig &>/dev/null; then
    echo "  1. Updating GRUB..."
    sudo grub-mkconfig -o /boot/grub/grub.cfg
    echo "  GRUB updated."

elif command -v grub2-mkconfig &>/dev/null; then
    echo "  1. Updating GRUB2..."
    sudo grub2-mkconfig -o /boot/grub2/grub.cfg
    echo "  GRUB2 updated."

# systemd-boot
elif [ -d /boot/loader/entries ]; then
    echo "  1. Adding systemd-boot entry..."
    cat | sudo tee "/boot/loader/entries/jalk-${VERSION}.conf" << EOF
title   JALK ${VERSION}
linux   ${KERNEL_IMAGE}
initrd  ${INITRAMFS}
options root=UUID=$(findmnt -n -o UUID /) rw quiet
EOF
    echo "  Entry created: /boot/loader/entries/jalk-${VERSION}.conf"
    # Set as default
    sudo mkdir -p /boot/loader
    echo "default jalk-${VERSION}" | sudo tee /boot/loader/loader.conf

# EFISTUB
elif [ -d /sys/firmware/efi ]; then
    echo "  1. Using EFISTUB..."
    ROOT_PART=$(findmnt -n -o UUID /)
    sudo efibootmgr --create --label "JALK ${VERSION}" \
        --loader /vmlinuz-${VERSION} \
        --unicode "root=UUID=${ROOT_PART} rw quiet initrd=\\initramfs-${VERSION}.img"
    echo "  EFI boot entry created."

else
    echo "  WARN: No supported bootloader found."
    echo "  Manually add kernel to your bootloader:"
    echo "    Kernel: $KERNEL_IMAGE"
    echo "    Initrd: $INITRAMFS"
fi
