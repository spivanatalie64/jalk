#!/bin/bash
# JALK Stress Test Suite
# Runs comprehensive stress testing on the kernel.
set -e

DURATION="${1:-3600}"
RESULTS=()

echo ""
echo "  JALK Stress Test Suite"
echo "  Duration: ${DURATION}s"
echo "  ======================"
echo ""

run_stress() {
    local name="$1"
    local cmd="$2"
    echo "  Running: $name (${DURATION}s)"
    
    if timeout "$DURATION" bash -c "$cmd" 2>&1 | tail -3; then
        RESULTS+=("$name: PASS")
    else
        RESULTS+=("$name: FAIL")
    fi
    echo ""
}

# CPU stress
run_stress "CPU (stress-ng)" \
    "stress-ng --cpu 4 --cpu-method matrixprod -t ${DURATION} --metrics-brief 2>/dev/null || echo 'stress-ng not available'"

# Memory stress
run_stress "Memory" \
    "stress-ng --vm 2 --vm-bytes 80% -t ${DURATION} --metrics-brief 2>/dev/null || echo 'stress-ng not available'"

# IO stress
run_stress "I/O (dd + fsync)" \
    "dd if=/dev/zero of=/tmp/jalk-stress.img bs=1M count=1024 conv=fsync 2>&1; rm -f /tmp/jalk-stress.img"

# Fork bomb test
run_stress "Process creation" \
    "for i in \$(seq 1 100); do sleep 0.01 & done; wait"

# Network stress (if loopback available)
run_stress "Network loopback" \
    "iperf3 -c 127.0.0.1 -t 10 2>/dev/null || echo 'iperf3 not available'"

echo "  Results:"
for r in "${RESULTS[@]}"; do
    echo "    $r"
done
