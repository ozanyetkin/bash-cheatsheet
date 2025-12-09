#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Simple textual progress bar
steps=${1:-20}
[[ $steps =~ ^[0-9]+$ ]] || { echo "steps must be integer" >&2; exit 1; }

for ((i=1; i<=steps; i++)); do
  filled=$(printf '%0.s#' $(seq 1 $i))
  empty=$(printf '%0.s.' $(seq 1 $((steps - i))))
  printf "\r[%s%s] %d/%d" "$filled" "$empty" "$i" "$steps"
  sleep 0.1
done
echo
