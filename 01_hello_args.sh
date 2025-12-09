#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

usage() { echo "Usage: $0 [-n name] [--] [extra args...]" >&2; exit 1; }

name="world"
while [[ $# -gt 0 ]]; do
  case "$1" in
    -n|--name)
      name=${2-}
      [[ -n "$name" ]] || usage
      shift 2
      ;;
    -h|--help)
      usage
      ;;
    --)
      shift
      break
      ;;
    *)
      break
      ;;
  esac
done

echo "Hello, $name!"

if [[ $# -gt 0 ]]; then
  echo "Extra args:"
  for arg in "$@"; do
    printf ' - %s\n' "$arg"
  done
fi
