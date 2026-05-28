# Supported Architectures

JALK supports all 21 upstream Linux architectures.

## Tier 1 (Primary)

| Arch | defconfig | QEMU Test | CI Build |
|------|-----------|-----------|----------|
| x86_64 | `jalk_defconfig` | ✅ | ✅ |
| i386 (32-bit) | `i386_defconfig` | ✅ | ❌ |
| arm64 | `defconfig` | ✅ | ✅ |
| riscv | `defconfig` | ✅ | ✅ |

## Tier 2 (Secondary)

| Arch | defconfig | QEMU Test | CI Build |
|------|-----------|-----------|----------|
| arm (32-bit) | `defconfig` | ✅ | ❌ |
| powerpc | `ppc64le_defconfig` | ✅ | ❌ |
| s390 | `defconfig` | ✅ | ❌ |
| loongarch | `defconfig` | ✅ | ❌ |

## Tier 3 (Community)

alpha, arc, csky, hexagon, m68k, microblaze, mips,
nios2, openrisc, parisc, sh, sparc, um, xtensa

These architectures build with `allnoconfig` or their native defconfig.
QEMU boot testing depends on simulator availability.

## Config Generation

```bash
./config-all-arch.sh  # Generates configs for all 21 architectures
```
