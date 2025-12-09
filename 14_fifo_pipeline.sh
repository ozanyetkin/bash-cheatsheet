#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

fifo=$(mktemp -u)
mkfifo "$fifo"
cleanup() { rm -f "$fifo"; }
trap cleanup EXIT

echo "FIFO at $fifo"

# Producer
{
  for i in {1..5}; do
    echo "item-$i"
    sleep 0.1
  done
} > "$fifo" &

# Consumer
while read -r line < "$fifo"; do
  printf 'got: %s\n' "$line"
done
