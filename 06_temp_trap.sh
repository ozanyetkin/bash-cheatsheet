#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

tmpdir=$(mktemp -d)
cleanup() { rm -rf "$tmpdir"; }
trap cleanup EXIT

log() { printf '[%s] %s\n' "$(date +%H:%M:%S)" "$*"; }

log "Working in $tmpdir"

cp ${1:-/etc/hosts} "$tmpdir/input" 2>/dev/null || true
ls -l "$tmpdir"
