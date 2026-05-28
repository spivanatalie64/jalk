# JALK Release Process

## Auto-Build on Upstream Releases

JALK includes a GitHub Action that monitors kernel.org for new
major Linux kernel releases and automatically creates a new fork branch.

### Workflow: `.github/workflows/sync-upstream.yml`

1. **Daily check** — Polls kernel.org releases.json
2. **New major release detected** (e.g., 7.1.0, 8.0.0):
   - Downloads the new tarball
   - Applies JALK patches on top
   - Creates a new branch `jalk-<version>`
   - Opens a PR to merge into `main`
   - Triggers full CI: build + test + benchmark

### Patch Application

JALK patches are stored in `patches/` and are applied in order:

```bash
cd jalk-<version>
for p in ../patches/*.patch; do
    patch -p1 < "$p"
done
```

### Version Scheme

| Component | Example |
|-----------|---------|
| Upstream | 7.0.10 |
| JALK suffix | -jalk |
| Full | 7.0.10-jalk |

## Branch Strategy

```
main              # Current stable JALK release
jalk-7.0.10       # Tagged release based on 7.0.10
jalk-7.0.11       # Future release based on 7.0.11
jalk-7.1.0        # Future release based on 7.1.0
```

## Release Checklist

- [ ] New upstream kernel released
- [ ] Patches apply cleanly
- [ ] All architectures build
- [ ] KUnit tests pass
- [ ] QEMU boot tests pass
- [ ] kselftests pass
- [ ] Stress test (1hr) passes
- [ ] Release tagged and signed
- [ ] Documentation updated
- [ ] Pushed to GitHub and GitLab

## Signing

All releases should be signed:

```bash
git tag -s v7.0.10-jalk -m "JALK v7.0.10-jalk"
git push origin v7.0.10-jalk
```
