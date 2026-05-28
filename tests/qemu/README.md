# JALK QEMU Boot Tests

Boot-tests the JALK kernel on simulated hardware for multiple architectures.

## Requirements

- qemu-system-x86_64
- qemu-system-aarch64
- qemu-system-riscv64
- qemu-system-ppc64
- qemu-system-s390x

## Usage

```bash
# Single architecture
./tests/qemu/boot-test.sh x86_64

# All architectures
./tests/qemu/run-all.sh
```

## How It Works

Each test:
1. Verifies the kernel image exists
2. Boots it under QEMU with a serial console
3. Checks for kernel startup messages
4. Passes if kernel boots within timeout (30s)
