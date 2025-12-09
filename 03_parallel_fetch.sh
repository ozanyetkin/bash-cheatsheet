#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

usage() { echo "Usage: $0 url1 [url2 ...]" >&2; exit 1; }
[[ $# -gt 0 ]] || usage

out_dir=${OUT_DIR:-/tmp/bash-cheatsheet-downloads}
mkdir -p "$out_dir"

echo "Saving into $out_dir"

pids=()
for url in "$@"; do
  {
    target_name=$(basename "${url%%\?*}")
    target_path="$out_dir/$target_name"
    curl -fsS "$url" -o "$target_path"
    echo "Saved $url -> $target_path"
  } &
  pids+=($!)
done

status=0
for pid in "${pids[@]}"; do
  if ! wait "$pid"; then
    status=1
  fi
done

exit "$status"
