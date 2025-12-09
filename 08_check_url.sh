#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

usage() { echo "Usage: $0 url [timeout_seconds]" >&2; exit 1; }
[[ $# -ge 1 ]] || usage

url=$1
timeout=${2:-5}

if curl -fsS --max-time "$timeout" -o /dev/null "$url"; then
  echo "OK: $url reachable"
else
  echo "FAIL: $url unreachable" >&2
  exit 1
fi
