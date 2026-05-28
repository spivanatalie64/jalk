# Security Policy

## Reporting a Vulnerability

JALK is based on the Linux kernel and inherits all upstream security
processes. If you discover a security vulnerability:

1. **Do NOT file a public GitHub issue**
2. Email the Linux kernel security team: security@kernel.org
3. CC: JALK maintainers at the contact below

For JALK-specific issues (non-upstream code):
- Email: spivanatalie64@users.noreply.github.com

## Response Timeline

- Upstream kernel CVEs: Patched per upstream schedule
- JALK-specific issues: 7-day initial response target

## Scope

The following are in scope:
- JALK kernel source code (this repository)
- JALK-specific patches in `patches/`

The following are out of scope:
- Upstream Linux kernel vulnerabilities (report to security@kernel.org)
- User applications running on JALK

## GPG Key

Fingerprint: 2DD9 6596 310B 520B B945 8357 97A3 9EB4 7A2F C589
