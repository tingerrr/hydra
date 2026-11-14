#!/usr/bin/env bash
# Benchmark the scenarios in `bench/scenarios` and store the results under a
# label, so they can be compared with `bench/compare.sh` later on.
#
# Usage: bench/run.sh <label> [scenarios] [sizes]
#   label      name of the result set, stored in `bench/out/<label>.json`
#   scenarios  comma separated scenario names (default: all)
#   sizes      comma separated values for `n`, the number of sections
#              (default: 32,64,128,256)
#
# Environment:
#   BENCH_RUNS    number of runs per measurement (default: 5)
#   BENCH_WARMUP  number of warmup runs per measurement (default: 1)
set -euo pipefail

if ! command -v hyperfine >/dev/null; then
  exec nix shell nixpkgs#hyperfine -c "$0" "$@"
fi

# fonts are embedded, keep the environment from adding font scanning noise
unset TYPST_FONT_PATHS

root="$(cd "$(dirname "$0")/.." && pwd)"
bench="$root/bench"
out="$bench/out"

label="${1:?usage: bench/run.sh <label> [scenarios] [sizes]}"
scenarios="${2:-$(cd "$bench/scenarios" && ls -- *.typ | sed 's/\.typ$//' | paste -sd,)}"
sizes="${3:-32,64,128,256}"

mkdir -p "$out/pdf"

# record what was measured, so results can be told apart later
{
  echo "label: $label"
  echo "date: $(date --iso-8601=seconds)"
  echo "typst: $(typst --version)"
  echo "hyperfine: $(hyperfine --version)"
  if command -v jj >/dev/null && jj root --ignore-working-copy >/dev/null 2>&1; then
    echo "revision: $(jj log --no-graph -r @ -T 'change_id.short() ++ " " ++ commit_id.short() ++ " " ++ if(empty, "(empty)", "(dirty)") ++ " " ++ description.first_line()')"
  fi
  echo "host: $(uname -srm), $(nproc) cpus"
} > "$out/$label.meta"
cat "$out/$label.meta"

hyperfine \
  --shell=none \
  --runs "${BENCH_RUNS:-5}" \
  --warmup "${BENCH_WARMUP:-1}" \
  --parameter-list scenario "$scenarios" \
  --parameter-list n "$sizes" \
  --command-name '{scenario} n={n}' \
  --export-json "$out/$label.json" \
  "typst compile --root $root --ignore-system-fonts --input n={n} $bench/scenarios/{scenario}.typ $out/pdf/{scenario}-{n}.pdf"

"$bench/compare.sh" "$label"
