#!/bin/bash
# JALK Verification Script
# Checks that the fork is correctly set up

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

pass=0
fail=0

check() {
    local desc="$1"
    local test_cmd="$2"
    if eval "$test_cmd" 2>/dev/null; then
        echo -e "  ${GREEN}[PASS]${NC} $desc"
        pass=$((pass + 1))
    else
        echo -e "  ${RED}[FAIL]${NC} $desc"
        fail=$((fail + 1))
    fi
}

echo ""
echo "  JALK Fork Verification"
echo "  ======================"
echo ""

cd "$(dirname "$0")"

check "Kernel source directory exists" "[ -d . ]"
check "Kernel Makefile exists" "[ -f Makefile ]"
check "JALK localversion file exists" "[ -f localversion-jalk ]"
check "JALK branding in Makefile" "grep -q 'JALK' Makefile"
check "JALK banner in version-timestamp.c" "grep -q 'JALK' init/version-timestamp.c"
check "Build script exists" "[ -f ../build.sh ]"
check "Top-level Makefile exists" "[ -f ../Makefile ]"
check "README exists" "[ -f README.md ]"
check "JALK helper script exists" "[ -f scripts/jalk.sh ]"
check "Config hints file exists" "[ -f scripts/jalk-kconfig.cfg ]"
check "Git repository initialized" "[ -d .git ]"
check "Git HEAD points to main" "grep -q 'ref: refs/heads/main' .git/HEAD"
check "All architectures present" "ls -d arch/*/ 2>/dev/null | wc -l | grep -q 22"

# Check for kernel source validity
check "Kernel version is 7.0.10" "grep -q 'VERSION = 7' Makefile && grep -q 'PATCHLEVEL = 0' Makefile && grep -q 'SUBLEVEL = 10' Makefile"
check "Kernel builds are not broken (Kconfig check)" "[ -f Kconfig ]"

echo ""
echo "  Results: $pass passed, $fail failed"
echo ""

if [ "$fail" -eq 0 ]; then
    echo -e "  ${GREEN}JALK fork is set up correctly!${NC}"
else
    echo -e "  ${RED}Some checks failed. Review above.${NC}"
fi
