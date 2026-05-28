# JALK Performance Benchmarks

## Benchmark Suite

JALK uses the following benchmark tools for performance regression testing:

| Benchmark | What it tests | Target |
|-----------|--------------|--------|
| `hackbench` | Scheduler throughput | No regression |
| `schbench` | Scheduler latency | No regression |
| `perf bench sched` | Scheduler messaging | No regression |
| `perf bench mem` | Memory bandwidth | No regression |
| `perf bench futex` | Futex performance | No regression |
| `stress-ng` | General system stress | No regression |
| `sysbench` | CPU/memory/threading | No regression |
| `iperf3` | Network throughput | No regression |
| `fio` | Filesystem IOPS | No regression |

## Running Benchmarks

```bash
# Scheduler benchmarks
./tools/perf/perf bench sched all

# Memory benchmarks
./tools/perf/perf bench mem all

# Full benchmark suite
./tests/benchmarks/phoronix-suite.sh
```

## Baseline Comparison

All JALK benchmarks are compared against upstream Linux with identical config
(with CONFIG_JALK=n for upstream). Results are tracked in:

- `docs/benchmarks/x86_64/` — x86_64 results
- `docs/benchmarks/arm64/` — ARM64 results

## Performance Targets

| Metric | vs Upstream | Status |
|--------|-------------|--------|
| Scheduler latency | ≤ 95% of upstream | TBD |
| Scheduler throughput | ≥ 98% of upstream | TBD |
| Memory bandwidth | ≥ 99% of upstream | TBD |
| TCP throughput | ≥ 100% (BBR benefit) | TBD |
| Boot time | ≤ 100% of upstream | TBD |
| Build time | ≤ 90% (no debug) | TBD |
