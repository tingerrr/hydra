#!/usr/bin/env bash
# Print the results of one benchmark run, or compare two of them.
#
# Usage: bench/compare.sh <label>
#        bench/compare.sh <base-label> <new-label>
#
# Reported per measurement (mean over all runs):
#   time   wall clock time in seconds
#   instr  retired instructions in billions, much less noisy than time
#   rss    peak resident memory in MiB
set -euo pipefail

out="$(cd "$(dirname "$0")" && pwd)/out"

defs='
def summary: .results
  | map({
      key: (.command | capture("--input n=(?<n>\\d+) .*/scenarios/(?<s>[^/]+)\\.typ") | "\(.s) n=\(.n)"),
      value: {
        time: .summary.time_wall_clock.mean,
        sd: .summary.time_wall_clock.stddev,
        instr: (.summary.instructions.mean / 1e9),
        rss: (.summary.memory_peak_resident.mean / 1048576),
      },
    })
  | from_entries;
def r: . * 100 | round / 100;
def r3: . * 1000 | round / 1000;
def pct(x; y): if x == 0 then "-" else ((y / x - 1) * 100 | round | tostring) + "%" end;
'

if [ $# -eq 1 ]; then
  jq -r "$defs"'
    summary | to_entries | (
      ["measurement", "time [s]", "± [s]", "instr [G]", "rss [MiB]"],
      (.[] | [.key, (.value | (.time, .sd | r3), (.instr, .rss | r))])
    ) | @tsv
  ' "$out/$1.json" | column -t -s $'\t'
elif [ $# -eq 2 ]; then
  echo "base: $(grep '^revision:' "$out/$1.meta" 2>/dev/null || echo "$1")"
  echo "new:  $(grep '^revision:' "$out/$2.meta" 2>/dev/null || echo "$2")"
  echo
  jq -rn --slurpfile a "$out/$1.json" --slurpfile b "$out/$2.json" "$defs"'
    ($a[0] | summary) as $a | ($b[0] | summary) as $b | (
      ["measurement", "time [s]", "→", "Δ", "instr [G]", "→", "Δ", "rss [MiB]", "→", "Δ"],
      ($a | keys_unsorted[] as $k | select($b[$k]) | [
        $k,
        ($a[$k].time | r3), ($b[$k].time | r3), pct($a[$k].time; $b[$k].time),
        ($a[$k].instr | r), ($b[$k].instr | r), pct($a[$k].instr; $b[$k].instr),
        ($a[$k].rss | round), ($b[$k].rss | round), pct($a[$k].rss; $b[$k].rss)
      ])
    ) | @tsv
  ' | column -t -s $'\t'
else
  echo "usage: bench/compare.sh <label> [<new-label>]" >&2
  exit 1
fi
