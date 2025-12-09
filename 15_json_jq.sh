#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

json='{"users":[{"name":"Ada","id":1},{"name":"Linus","id":2}]}'

# Requires jq
names=$(jq -r '.users[].name' <<<"$json")
ids=$(jq -r '.users[].id' <<<"$json")

echo "Names:"; printf ' - %s\n' $names
echo "IDs:"; printf ' - %s\n' $ids
