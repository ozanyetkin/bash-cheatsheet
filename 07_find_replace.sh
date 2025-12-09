#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

usage() { echo "Usage: $0 pattern replacement file" >&2; exit 1; }
[[ $# -eq 3 ]] || usage

pattern=$1
replacement=$2
file=$3
[[ -f "$file" ]] || { echo "Missing file: $file" >&2; exit 1; }

# In-place replace using sed portable backup
sed -i.bak "s/${pattern}/${replacement}/g" "$file"
echo "Updated $file (backup at ${file}.bak)"
