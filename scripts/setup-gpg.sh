#!/bin/bash
# JALK GPG Signing Setup
# Configures git commit signing for the JALK repository.
set -e

KEY_NAME="JALK Kernel Signing Key"
KEY_EMAIL="spivanatalie64@users.noreply.github.com"
KEY_COMMENT="JALK - Just Another Linux Kernel"

echo ""
echo "  JALK GPG Signing Setup"
echo "  ======================"
echo ""

# Check if GPG key already exists
if gpg --list-secret-keys --keyid-format LONG 2>/dev/null | grep -q "$KEY_EMAIL"; then
    echo "  GPG key for $KEY_EMAIL already exists."
else
    echo "  Generating new GPG key..."
    cat > /tmp/gpg-batch << EOF
%echo Generating JALK signing key
Key-Type: RSA
Key-Length: 4096
Key-Usage: sign
Name-Real: $KEY_NAME
Name-Comment: $KEY_COMMENT
Name-Email: $KEY_EMAIL
Expire-Date: 0
%commit
%echo Key generated
EOF
    gpg --batch --generate-key /tmp/gpg-batch
    rm /tmp/gpg-batch
fi

# Get key ID
KEY_ID=$(gpg --list-secret-keys --keyid-format LONG "$KEY_EMAIL" 2>/dev/null \
    | grep "^sec" | awk '{print $2}' | cut -d'/' -f2)

echo "  Key ID: $KEY_ID"

# Configure git to use signing
cd "$(dirname "$0")/.."
git config user.signingkey "$KEY_ID"
git config commit.gpgsign true
git config tag.gpgsign true

echo ""
echo "  Git configured for signed commits."
echo "  Key fingerprint:"
gpg --fingerprint "$KEY_EMAIL"

# Export public key
mkdir -p docs/release
gpg --armor --export "$KEY_EMAIL" > "docs/release/jalk-signing-key.asc"
echo ""
echo "  Public key exported to docs/release/jalk-signing-key.asc"
echo ""
echo "  To sign a release:"
echo "    git tag -s v7.0.10-jalk -m 'JALK v7.0.10-jalk'"
echo "    git push origin v7.0.10-jalk"
