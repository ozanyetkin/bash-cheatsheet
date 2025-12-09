#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

usage() { echo "Usage: $0 [-f file] [-v] [--] args" >&2; exit 1; }

verbose=false
file=""

while getopts "f:vh" opt; do
  case $opt in
    f) file=$OPTARG ;;
    v) verbose=true ;;
    h) usage ;;
    *) usage ;;
  esac
done
shift $((OPTIND - 1))

$verbose && echo "Verbose on"
[[ -n "$file" ]] && echo "File: $file"

if [[ $# -gt 0 ]]; then
  echo "Positional args:"
  printf ' - %s\n' "$@"
fi
