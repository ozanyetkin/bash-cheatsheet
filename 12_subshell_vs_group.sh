#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

start_dir=$PWD

echo "Subshell keeps cwd:"
(cd / && echo "inside: $PWD")
echo "after subshell: $PWD"

echo

echo "Grouping changes cwd:"
{ cd / && echo "inside: $PWD"; }
echo "after group: $PWD"

echo "Start dir was: $start_dir"
