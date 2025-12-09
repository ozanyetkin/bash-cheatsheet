#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

file1=${1:-/etc/hosts}
file2=${2:-/etc/services}

# Compare sorted unique first 5 lines of each
if diff <(head -5 "$file1" | sort -u) <(head -5 "$file2" | sort -u); then
  echo "No diff in sampled sections"
else
  echo "Differences above"
fi
