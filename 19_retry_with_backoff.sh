#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

usage() { echo "Usage: $0 command..." >&2; exit 1; }
[[ $# -gt 0 ]] || usage

max=5
base=1

for ((i=1; i<=max; i++)); do
  if "$@"; then
    echo "Success on attempt $i"
    exit 0
  fi
  sleep_for=$((base * 2 ** (i-1)))
  echo "Attempt $i failed; retrying in ${sleep_for}s" >&2
  sleep "$sleep_for"
done

echo "All retries failed" >&2
exit 1
