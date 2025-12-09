#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

usage() { echo "Usage: $0 source_dir [dest_dir]" >&2; exit 1; }
[[ $# -ge 1 ]] || usage

src=$1
dest=${2:-/tmp}
[[ -d "$src" ]] || { echo "Missing dir: $src" >&2; exit 1; }
[[ -d "$dest" ]] || { echo "Missing dest dir: $dest" >&2; exit 1; }

stamp=$(date +%Y%m%d_%H%M%S)
out="$dest/$(basename "$src")_${stamp}.tar.gz"

tar -czf "$out" -C "$src" .
echo "Backup created: $out"
