#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

n=${1:-10}
[[ $n =~ ^[0-9]+$ ]] || { echo "n must be integer" >&2; exit 1; }

sum=0
for ((i=1; i<=n; i++)); do
  (( sum += i ))
  printf 'i=%d sum=%d\n' "$i" "$sum"
done

echo "Final sum: $sum"
