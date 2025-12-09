#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Simple key/value join using associative arrays
mapfile -t left < <(printf 'id,name\n1,Ada\n2,Linus\n3,Grace\n')
mapfile -t right < <(printf 'id,role\n1,Engineer\n2,Kernel\n3,Pioneer\n')

declare -A roles
for ((i=1; i<${#right[@]}; i++)); do
  IFS=',' read -r id role <<<"${right[$i]}"
  roles[$id]=$role
done

echo "id,name,role"
for ((i=1; i<${#left[@]}; i++)); do
  IFS=',' read -r id name <<<"${left[$i]}"
  echo "$id,$name,${roles[$id]-unknown}"
done
