#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Simple file statistics for a directory (default current directory)
dir=${1:-.}
[[ -d "$dir" ]] || { echo "Not a directory: $dir" >&2; exit 1; }

echo "Top 5 largest files in $dir"
find "$dir" -type f -printf '%s\t%p\n' | sort -nr | head -5 | awk '{printf "%s\t%s\n", $1, $2}'

echo
echo "File counts by extension"
find "$dir" -type f -printf '%f\n' | sed -n 's/.*\.//p' | sort | uniq -c | sort -nr | head -10
