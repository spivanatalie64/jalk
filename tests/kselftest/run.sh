#!/bin/bash
# JALK kselftest Runner
# Builds and runs kernel self-tests.
set -e

echo ""
echo "  JALK kselftest Suite"
echo "  ===================="
echo ""

cd "$(dirname "$0")/../.."

SELFTEST_DIR="tools/testing/selftests"

if [ ! -d "$SELFTEST_DIR" ]; then
    echo "  ERROR: selftests not found at $SELFTEST_DIR"
    exit 1
fi

# Build selftests
echo "  Building selftests..."
make -C "$SELFTEST_DIR" -j$(nproc) 2>&1 | tail -3

RESULTS=()

run_selftest() {
    local target="$1"
    local name="$2"
    echo "  Running: $name"
    if make -C "$SELFTEST_DIR" TARGETS="$target" run_tests 2>&1 | tail -10; then
        RESULTS+=("$name: PASS")
    else
        RESULTS+=("$name: FAIL (check log)")
    fi
    echo ""
}

# Run critical test groups
run_selftest "sched" "Scheduler"
run_selftest "mm" "Memory Management"
run_selftest "net" "Networking"
run_selftest "cpufreq" "CPU Frequency"
run_selftest "ftrace" "Tracing"

echo "  Results:"
for r in "${RESULTS[@]}"; do
    echo "    $r"
done
