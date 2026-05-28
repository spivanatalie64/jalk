# Building JALK

## Quick Build (x86_64)

```bash
cd jalk-7.0.10
make defconfig
make -j$(nproc)
```

## Using jalk_defconfig

```bash
make jalk_defconfig
make -j$(nproc)
```

## Architecture-Specific Builds

```bash
# x86_64
make ARCH=x86_64 defconfig
make ARCH=x86_64 -j$(nproc)

# ARM64
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- defconfig
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- -j$(nproc)

# RISC-V
make ARCH=riscv CROSS_COMPILE=riscv64-linux-gnu- defconfig
make ARCH=riscv CROSS_COMPILE=riscv64-linux-gnu- -j$(nproc)

# PowerPC
make ARCH=powerpc CROSS_COMPILE=powerpc64-linux-gnu- defconfig
make ARCH=powerpc CROSS_COMPILE=powerpc64-linux-gnu- -j$(nproc)

# MIPS
make ARCH=mips CROSS_COMPILE=mips64-linux-gnu- defconfig
make ARCH=mips CROSS_COMPILE=mips64-linux-gnu- -j$(nproc)

# s390x
make ARCH=s390 CROSS_COMPILE=s390x-linux-gnu- defconfig
make ARCH=s390 CROSS_COMPILE=s390x-linux-gnu- -j$(nproc)
```

## Minimal Resource Build

For environments with limited CPU/memory:

```bash
# Only build what your hardware needs
make localmodconfig
make -j2

# Use LLVM/Clang for faster compilation
make CC=clang LLVM=1 -j$(nproc)

# Use ccache
export CC="ccache gcc"
make -j$(nproc)

# Thin LTO for reduced memory during linking
make CONFIG_LTO_CLANG_THIN=y -j$(nproc)
```

## Docker Build

```bash
docker build -t jalk .
docker run --rm jalk cat /boot/vmlinuz-jalk > bzImage
```

## Build Artifacts

| File | Description |
|------|-------------|
| `arch/x86/boot/bzImage` | Compressed kernel image (x86) |
| `arch/arm64/boot/Image` | Uncompressed kernel image (arm64) |
| `vmlinux` | Uncompressed ELF kernel |
| `System.map` | Kernel symbol table |
| `Module.symvers` | Module symbol versions |
