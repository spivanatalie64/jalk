# JALK Documentation

Welcome to JALK - Just Another Linux Kernel.

## Contents

- [Building](building.md) - How to build JALK for all architectures
- [Testing](testing.md) - Test infrastructure and running tests
- [Optimizations](optimizations.md) - All JALK-specific optimizations
- [Architecture Support](architecture.md) - Supported platforms
- [Configuration](configuration.md) - Kernel config guide
- [Release Process](release-process.md) - Auto-build and release workflow
- [Performance Benchmarks](benchmarks.md) - Benchmark results

## Quick Start

```bash
git clone https://github.com/spivanatalie64/jalk.git
cd jalk/jalk-7.0.10
make defconfig
make -j$(nproc)
```

## Project Structure

```
jalk/
├── jalk-7.0.10/          # Kernel source tree
│   ├── docs/             # JALK documentation
│   ├── tests/            # Test infrastructure
│   │   ├── qemu/         # QEMU boot tests
│   │   ├── kunit/        # KUnit test runner
│   │   ├── kselftest/    # Kernel self-tests
│   │   └── stress/       # Stress testing
│   ├── arch/x86/configs/
│   │   └── jalk_defconfig
│   ├── kernel/jalk.c     # JALK sysfs module
│   └── localversion-jalk
├── patches/              # JALK-specific patches
├── build.sh
├── verify.sh
├── config-all-arch.sh
└── Dockerfile
```
