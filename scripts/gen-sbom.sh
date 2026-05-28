#!/bin/bash
# JALK Software Bill of Materials Generator
# Creates SPDX-compatible SBOM for the kernel build.
set -e

KERNEL_DIR="$(dirname "$0")/.."
VERSION="7.0.10-jalk"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
OUTPUT="${KERNEL_DIR}/docs/release/sbom-${VERSION}.spdx"

echo ""
echo "  JALK SBOM Generator"
echo "  ==================="
echo ""

cd "$KERNEL_DIR"

# Collect information
CC_VERSION=$(gcc --version 2>/dev/null | head -1 || echo "gcc unknown")
LD_VERSION=$(ld --version 2>/dev/null | head -1 || echo "ld unknown")
GIT_COMMIT=$(git log --oneline -1 2>/dev/null | awk '{print $1}' || echo "unknown")
GIT_REMOTE=$(git remote get-url origin 2>/dev/null || echo "unknown")
KCONFIG_HASH=$(sha256sum .config 2>/dev/null | awk '{print $1}' || echo "none")

# Generate SPDX document
cat > "$OUTPUT" << SPDXEOF
SPDXVersion: SPDX-2.3
DataLicense: CC0-1.0
SPDXID: SPDXRef-DOCUMENT
DocumentName: JALK Kernel ${VERSION}
DocumentNamespace: https://github.com/spivanatalie64/jalk/sbom/${VERSION}
LicenseListVersion: 3.21
Creator: Tool: JALK-SBOM-Generator
Creator: Person: Natalie (spivanatalie64)
Created: ${TIMESTAMP}

## Package: JALK Kernel

PackageName: jalk-kernel
SPDXID: SPDXRef-Package-JALK
PackageVersion: ${VERSION}
PackageFileName: vmlinuz-${VERSION}
PackageSupplier: Person: Natalie (spivanatalie64)
PackageOriginator: https://github.com/spivanatalie64/jalk
PackageDownloadLocation: ${GIT_REMOTE}
PackageVerificationCode: ${KCONFIG_HASH}
PackageChecksum: SHA256: $(sha256sum arch/x86/boot/bzImage 2>/dev/null | awk '{print $1}' || echo "pending")
PackageLicenseConcluded: GPL-2.0-only
PackageLicenseDeclared: GPL-2.0-only
PackageCopyrightText: Copyright (C) 2026 Natalie

PackageSummary: JALK - Just Another Linux Kernel
PackageDescription: Performance-optimized fork of Linux kernel 7.0.10

## Relationships

Relationship: SPDXRef-DOCUMENT DESCRIBES SPDXRef-Package-JALK
Relationship: SPDXRef-Package-JALK DERIVED_FROM SPDXRef-Package-Linux-7.0.10

## Upstream

PackageName: Linux Kernel 7.0.10
SPDXID: SPDXRef-Package-Linux-7.0.10
PackageVersion: 7.0.10
PackageDownloadLocation: https://cdn.kernel.org/pub/linux/kernel/v7.x/linux-7.0.10.tar.xz
PackageChecksum: SHA256: $(sha256sum /dev/null 2>/dev/null || echo "verify at kernel.org")
PackageLicenseConcluded: GPL-2.0-only

## Files

$(find arch/x86/boot/ -type f -name "bzImage" 2>/dev/null | while read f; do
    echo "FileName: ${f}"
    echo "SPDXID: SPDXRef-File-$(echo ${f} | sha256sum | awk '{print $1}' | cut -c1-12)"
    echo "FileChecksum: SHA256: $(sha256sum "$f" | awk '{print $1}')"
    echo "LicenseConcluded: GPL-2.0-only"
    echo ""
done)

## Build Dependencies

ExternalRef: SECURITY cpe23Type cpe:2.3:a:gnu:gcc:$(gcc -dumpversion 2>/dev/null || echo "0"):*:*:*:*:*:*:
ExternalRef: SECURITY cpe23Type cpe:2.3:a:gnu:make:$(make --version 2>/dev/null | head -1 | grep -oP '\d+\.\d+' | head -1):*:*:*:*:*:*:
SPDXEOF

echo "  SBOM generated: $OUTPUT"
echo "  Size: $(wc -l < "$OUTPUT") lines"
