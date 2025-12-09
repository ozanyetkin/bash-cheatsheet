#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Run commands in parallel and report the first to finish.
cmds=("sleep 1" "sleep 2" "echo fast")

pids=()
for c in "${cmds[@]}"; do
  bash -c "$c" &
  pids+=($!)
done

if wait -n; then
  echo "First job finished successfully"
else
  echo "First job failed" >&2
fi

wait  # wait remaining
