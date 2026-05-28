## Description

Brief description of the merge request.

## Type of Change

- [ ] Bug fix
- [ ] New feature
- [ ] Performance optimization
- [ ] Documentation
- [ ] Infrastructure

## Verification Checklist

- [ ] `make jalk_defconfig` succeeds
- [ ] `make -j$(nproc)` builds successfully
- [ ] `./verify.sh` passes all checks
- [ ] `./scripts/verify-build.sh` passes
- [ ] `./tests/qemu/boot-test.sh x86_64` boots

## Related Issues

Closes #(issue)
