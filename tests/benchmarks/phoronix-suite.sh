#!/bin/bash
# JALK Phoronix Benchmark Suite
# Runs industry-standard benchmarks on JALK kernel.
set -e

DURATION="${1:-600}"  # Default 10 min per test
KERNEL_DIR="$(dirname "$0")/../.."

echo ""
echo "  JALK Phoronix Benchmark Suite"
echo "  Duration per test: ${DURATION}s"
echo "  ==============================="
echo ""

cd "$KERNEL_DIR"

# Check for Phoronix
if ! command -v phoronix-test-suite &>/dev/null; then
    echo "  Installing Phoronix Test Suite..."
    wget -q "https://phoronix-test-suite.com/releases/phoronix-test-suite-10.8.4.tar.gz" -O /tmp/phoronix.tar.gz
    tar -xzf /tmp/phoronix.tar.gz -C /tmp/
    cd /tmp/phoronix-test-suite/
    sudo ./install-sh
    cd "$KERNEL_DIR"
fi

# Ensure kernel built
if [ ! -f arch/x86/boot/bzImage ]; then
    echo "  Building JALK kernel..."
    make jalk_defconfig
    make -j$(nproc) bzImage
fi

# Configure batch mode
phoronix-test-suite batch-setup

TESTS=(
    "pts/scheduler-test-1.0.0"      # Scheduler throughput
    "pts/context-switching-1.0.0"   # Context switch latency
    "pts/fs-mark-1.0.0"            # Filesystem benchmark
    "pts/apache-1.0.0"             # Web server throughput
    "pts/phpbench-1.0.0"           # PHP benchmark
    "pts/pybench-1.0.0"            # Python benchmark
    "pts/stream-1.0.0"             # Memory bandwidth
    "pts/cachebench-1.0.0"         # Cache benchmark
    "pts/hackbench-1.0.0"          # Scheduler benchmark
    "pts/openssl-1.0.0"            # Crypto performance
)

RESULTS_DIR="docs/benchmarks/$(date +%Y%m%d-%H%M)"

for test in "${TESTS[@]}"; do
    echo ""
    echo "  Running: $test"
    echo "  ==================="
    phoronix-test-suite batch-benchmark "$test" || {
        echo "  WARN: $test failed to run"
    }
done

# Save results
mkdir -p "$RESULTS_DIR"
cp -r ~/.phoronix-test-suite/test-results/* "$RESULTS_DIR/" 2>/dev/null || true

echo ""
echo "  Benchmarking complete."
echo "  Results saved to: $RESULTS_DIR"
echo ""
echo "  To compare with upstream:"
echo "    phoronix-test-suite result-file-to-csv <result-id>"
