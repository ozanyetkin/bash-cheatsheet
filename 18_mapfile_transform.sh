#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Read stdin into array, uppercase, and emit numbered lines
mapfile -t lines

for i in "${!lines[@]}"; do
  printf '%d: %s\n' "$((i+1))" "${lines[$i]^^}"
done
