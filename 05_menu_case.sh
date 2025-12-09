#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

PS3="Choose an action: "
select choice in list pwd whoami quit; do
  case "$choice" in
    list) ls -lah ;;
    pwd) pwd ;;
    whoami) whoami ;;
    quit) exit 0 ;;
    *) echo "Invalid" ;;
  esac
  echo "---"
done
