# JALK Testing Infrastructure

JALK includes a comprehensive test framework that runs thousands of tests
across simulated hardware environments.

## Test Categories

### 1. KUnit Tests (Unit Tests)

KUnit tests run in kernelspace and test individual subsystems.
Thousands of built-in KUnit tests are included in the kernel source.

```bash
# Run all KUnit tests
./tools/testing/kunit/kunit.py run --timeout=300

# Run specific test suites
./tools/testing/kunit/kunit.py run --arch=x86_64 --kconfig_add 'CONFIG_JALK=y' \
  --timeout=300 "sched*" "mm*"

# Run with QEMU for arm64
./tools/testing/kunit/kunit.py run --arch=arm64 --cross_compile=aarch64-linux-gnu- \
  --timeout=300
```

### 2. kselftests (System Tests)

The kernel self-tests validate system-level behavior.

```bash
# Build and run all selftests
cd tools/testing/selftests
make -j$(nproc)
make run_tests

# Run specific test groups
make -C tools/testing/selftests TARGETS="sched mm net" run_tests
```

### 3. QEMU Boot Tests

Boot-test the kernel on simulated hardware for multiple architectures.

```bash
# x86_64 boot test
./tests/qemu/boot-test.sh x86_64

# arm64 boot test  
./tests/qemu/boot-test.sh arm64

# riscv boot test
./tests/qemu/boot-test.sh riscv

# All architectures
./tests/qemu/run-all.sh
```

### 4. Stress Testing

```bash
# Stress CPU, memory, and IO
./tests/stress/stress-test.sh --duration 3600

# Memory pressure test
./tests/stress/stress-test.sh --memory

# Filesystem stress
./tests/stress/stress-test.sh --io
```

## CI Pipeline

The CI pipeline (GitHub Actions + GitLab CI) runs:

1. **Build** — kernel compiles for x86_64, arm64, riscv
2. **KUnit** — all unit tests pass
3. **Boot** — QEMU boot test for each architecture
4. **kselftest** — critical selftest groups
5. **Stress** — 15-minute stress test on x86_64

## Coverage Goals

| Test Type | Target | Current |
|-----------|--------|---------|
| KUnit tests | 100% pass | — |
| kselftests | 95%+ pass | — |
| QEMU boot (x86_64) | 100% | — |
| QEMU boot (arm64) | 100% | — |
| QEMU boot (riscv) | 100% | — |
| Stress tests | No crash in 1hr | — |
