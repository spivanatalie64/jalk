JALK - Just Another Linux Kernel
=================================

Based on Linux Kernel 7.0.10

JALK is a performance-optimized fork of the Linux kernel designed for:
- Modern x86_64
- Legacy x86_64 (i386 compat)
- ARM/ARM64
- RISC-V
- PowerPC
- MIPS
- s390
- All other Linux-supported architectures

## Building

```bash
make defconfig
make -j$(nproc)
```

For specific architectures:
```bash
make ARCH=arm64 defconfig
make ARCH=arm64 -j$(nproc)
```

## Features

- All upstream Linux kernel features
- Architecture-specific optimizations enabled by default
- PREEMPT enabled for desktop workloads
- Additional debugging disabled in release builds
- Optimized for performance across all platforms

## License

GNU General Public License v2.0
