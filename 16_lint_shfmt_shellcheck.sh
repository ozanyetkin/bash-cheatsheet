#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Lint all .sh files in this repo with shellcheck and format with shfmt if available.
root=$(cd "$(dirname "$0")" && pwd)
cd "$root"

shopt -s nullglob
scripts=(*.sh)

if command -v shellcheck >/dev/null 2>&1; then
  echo "Running shellcheck"
  shellcheck "${scripts[@]}"
else
  echo "shellcheck not installed" >&2
fi

if command -v shfmt >/dev/null 2>&1; then
  echo "Running shfmt"
  shfmt -w "${scripts[@]}"
else
  echo "shfmt not installed" >&2
fi
