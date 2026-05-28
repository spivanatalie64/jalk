# Contributing to JALK

## How to Contribute

### Reporting Bugs

1. Check if the bug exists in upstream Linux first
2. If upstream-only, report at https://bugzilla.kernel.org
3. If JALK-specific, file a GitHub issue with:
   - JALK version (`uname -a`)
   - Kernel config (attach `.config`)
   - dmesg output
   - Steps to reproduce

### Submitting Patches

1. Fork the repository
2. Create a branch: `git checkout -b fix/description`
3. Make your changes
4. Run verification: `./verify.sh`
5. Submit a Pull Request

### Patch Guidelines

- Follow Linux kernel coding style (see `Documentation/process/coding-style.rst`)
- All patches must be signed-off: `git commit -s`
- Keep patches focused on one change
- Reference upstream commits where applicable

### JALK-Specific Changes

- All JALK-specific features should be gated behind `CONFIG_JALK`
- Add documentation in `docs/` for new features
- Add tests in `tests/` for new features
- JALK patches go in `patches/` with a description

## Code Review

All submissions require review. Review criteria:
- Does it build?
- Does it pass KUnit tests?
- Does it boot under QEMU?
- Is it gated behind CONFIG_JALK if JALK-specific?

## License

GNU General Public License v2.0
