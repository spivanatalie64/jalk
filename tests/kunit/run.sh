#!/bin/bash
# JALK KUnit Test Runner
# Runs kernel unit tests across multiple configurations.
set -e

echo ""
echo "  JALK KUnit Test Suite"
echo "  ====================="
echo ""

cd "$(dirname "$0")/../.."

KUNIT="./tools/testing/kunit/kunit.py"

if [ ! -f "$KUNIT" ]; then
    echo "  ERROR: KUnit runner not found at $KUNIT"
    exit 1
fi

RESULTS=()

run_kunit() {
    local arch="$1"
    local name="$2"
    local filter="$3"
    echo "  Running KUnit tests: $name ($arch)"
    if python3 "$KUNIT" run \
        --arch="$arch" \
        --timeout=300 \
        --kconfig_add='CONFIG_JALK=y' \
        "$filter" 2>&1 | tail -5; then
        RESULTS+=("$name: PASS")
    else
        RESULTS+=("$name: FAIL")
    fi
    echo ""
}

# Run critical test suites
run_kunit "x86_64" "scheduler" "sched*"
run_kunit "x86_64" "memory management" "mm*"
run_kunit "x86_64" "file systems" "fs*"
run_kunit "x86_64" "networking" "net*"
run_kunit "x86_64" "kernel core" "kunit*"

echo "  Results:"
for r in "${RESULTS[@]}"; do
    echo "    $r"
done
