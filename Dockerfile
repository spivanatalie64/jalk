FROM archlinux:latest AS builder

RUN pacman -Sy --noconfirm && pacman -S --noconfirm \
    base-devel gcc make flex bison bc cpio \
    libelf openssl kmod initramfs

COPY jalk-7.0.10 /kernel

RUN cd /kernel && \
    make defconfig && \
    make -j$(nproc) && \
    make modules -j$(nproc)

FROM scratch AS kernel
COPY --from=builder /kernel/arch/x86/boot/bzImage /boot/vmlinuz-jalk
COPY --from=builder /kernel/System.map /boot/System.map-jalk
