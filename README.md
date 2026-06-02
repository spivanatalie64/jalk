JALK - Just Another Linux Kernel
=================================

[![Build](https://github.com/spivanatalie64/jalk/actions/workflows/build-and-test.yml/badge.svg)](https://github.com/spivanatalie64/jalk/actions/workflows/build-and-test.yml)
[![CI](https://github.com/spivanatalie64/jalk/actions/workflows/build.yml/badge.svg)](https://github.com/spivanatalie64/jalk/actions/workflows/build.yml)
[![License: GPL v2](https://img.shields.io/badge/License-GPL%20v2-blue.svg)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)
[![Kernel](https://img.shields.io/badge/Kernel-7.0.10-green)](https://kernel.org)

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
---

## 🤖 Pullfrog AI Review

This repository uses **Pullfrog AI** to automatically review pull requests.

Pullfrog is an AI-powered code review agent that analyzes every PR for code quality,
security issues, performance problems, and best practice violations. Reviews appear
as inline PR comments and checks. Trigger manually by commenting `@pullfrog` on any PR.

Powered by OpenRouter.