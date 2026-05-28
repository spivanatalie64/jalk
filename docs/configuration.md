# JALK Kernel Configuration

## Using jalk_defconfig

The quickest way to get a performance-tuned config:

```bash
make jalk_defconfig
```

## Manual Config

```bash
make menuconfig     # ncurses menu
make nconfig        # ncurse smarter menu
make xconfig        # Qt-based
make gconfig        # GTK-based
```

## Key Config Options

### JALK Features

| Option | Default | Description |
|--------|---------|-------------|
| `CONFIG_JALK` | y | Master switch for JALK features |
| `CONFIG_PREEMPT` | y | Full preemption for desktop |
| `CONFIG_HZ_1000` | y | 1000Hz timer |
| `CONFIG_DEFAULT_BBR` | y | BBR TCP congestion control |

### Performance

| Option | Default | Description |
|--------|---------|-------------|
| `CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS` | y | Always use huge pages |
| `CONFIG_SCHED_CORE` | y | Core scheduling for SMT |
| `CONFIG_SCHED_CLASS_EXT` | y | Extensible scheduler (BPF) |
| `CONFIG_NUMA_BALANCING` | y | NUMA-aware scheduling |

### Debug (disable for performance)

| Option | jalk_defconfig | Description |
|--------|---------------|-------------|
| `CONFIG_DEBUG_INFO` | n | Debug symbols (huge .ko files) |
| `CONFIG_DEBUG_KERNEL` | n | Kernel debug infrastructure |
| `CONFIG_SCHED_DEBUG` | n | Scheduler debug |
| `CONFIG_LOCKDEP` | n | Lock dependency validator |
| `CONFIG_PROVE_LOCKING` | n | Locking correctness checks |
| `CONFIG_KASAN` | n | Memory error detector |
| `CONFIG_UBSAN` | n | Undefined behavior sanitizer |

### Local Config for Minimal Builds

```bash
# Build only what your hardware needs
make localmodconfig

# Or even smaller: only currently loaded modules
make lsmod | awk '{print $1}' | tail -n+2 > /tmp/modules
make modules_prepare
```

## Config Hierarchy

```
jalk_defconfig
  └── x86_64_defconfig (base)
       └── kconfig fragments
            ├── jalk-kconfig.cfg (optimization hints)
            ├── hardening.config (security)
            └── tiny.config (size optimization)
```
