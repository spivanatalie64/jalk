# JALK Optimizations

## Overview

JALK applies the following optimizations on top of upstream Linux.
All changes are gated behind `CONFIG_JALK` where applicable.

## Kernel Configuration Defaults

| Setting | Upstream Default | JALK Default | Impact |
|---------|-----------------|--------------|--------|
| Preemption Model | PREEMPT_NONE (Server) | PREEMPT (Low-Latency) | Lower scheduling latency at ~1-3% throughput cost |
| Timer Frequency | HZ_250 | HZ_1000 | Finer timekeeping, better interactivity |
| TCP Congestion | CUBIC | BBR | Better throughput on lossy/high-BW networks |
| Transparent HugePages | MADVISE | ALWAYS | Reduced TLB misses, better memory performance |
| Default I/O Scheduler | none (mqueue) | mq-deadline | Better latency under IO load |

## Scheduler Tuning

- `sched_base_slice`: 700us → **500us** — tasks are preempted faster
- `sched_migration_cost`: 500us → **250us** — load balancer reacts faster

## Build Optimizations

- Thinner LTO (AutoFDO if available)
- `CONFIG_DEBUG_INFO=n` in release builds
- `CONFIG_KASAN=n`, `CONFIG_UBSAN=n`, `CONFIG_LOCKDEP=n`
- Module selection via `make localmodconfig`

## Architecture-Specific

x86_64:
- `CONFIG_GENERIC_CPU=y` — broadest compatibility
- `CONFIG_IA32_EMULATION=y` — legacy 32-bit support
- `CONFIG_X86_X32=y` — x32 ABI support

## Debug Removed

All of the following are disabled in jalk_defconfig:
- DEBUG_INFO, DEBUG_KERNEL, SCHED_DEBUG
- LOCKDEP, PROVE_LOCKING, KASAN, UBSAN
- STACKTRACE (kept for profiling)
