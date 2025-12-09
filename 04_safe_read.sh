#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

file=${1:-/etc/hosts}
[[ -f "$file" ]] || { echo "File not found: $file" >&2; exit 1; }

while IFS= read -r line; do
  [[ -z "$line" || "$line" == \#* ]] && continue
  printf '%s\n' "$line"
done < "$file"
