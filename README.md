# bash-cheatsheet

Comprehensive Bash scripting quick reference for Linux. All examples target Bash 4+ and assume `set -euo pipefail` where noted.

## Basics

- Shebang: `#!/usr/bin/env bash`
- Run script: `chmod +x script.sh && ./script.sh`
- Debug: `bash -x script.sh` or inline `set -x` / `set +x`
- Strict mode: `set -euo pipefail` and `IFS=$'\n\t'`
- Check bash version: `echo "$BASH_VERSION"`

```bash
#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

echo "Hello $USER from $HOSTNAME"
```

## Variables

- Assign: `name="Ada"` (no spaces around `=`)
- Read: `echo "$name"`
- Read user input: `read -r name` or `read -rp "Name: " name`
- Export: `export PATH="/opt/bin:$PATH"`
- Default values: `${var:-fallback}`; error if empty: `${var:?message}`
- Parameter expansion: `${#str}` length, `${str:2:3}` slice, `${str/old/new}` replace first, `${str//old/new}` replace all

```bash
greeting=${1:-world}
echo "Hi ${greeting^}!"   # capitalize first letter
echo "Name length: ${#greeting}"
```

## Arithmetic

- Use `(( ))` for integers: `((count++))`, `((a = b + 5))`
- Command substitution: `result=$((a * 4))`
- Comparison in arithmetic context: `(( a < b )) && echo "lt"`

```bash
#!/usr/bin/env bash
set -euo pipefail

total=0
for n in {1..5}; do (( total += n )); done
echo "Sum: $total"
```

## Strings and arrays

- Split-safe read: `while IFS= read -r line; do ...; done < file`
- Arrays: `arr=(a b c)`, access `${arr[0]}`, length `${#arr[@]}`, iterate `for x in "${arr[@]}"; do ...; done`
- Append: `arr+=("new")`
- Associative arrays (bash 4+): `declare -A map; map[foo]=bar; echo ${map[foo]}`

```bash
#!/usr/bin/env bash
set -euo pipefail

arr=(alpha beta gamma)
arr+=(delta)

for i in "${!arr[@]}"; do
  printf '%s => %s\n' "$i" "${arr[$i]}"
done

declare -A ports=([web]=80 [db]=5432)
echo "DB runs on ${ports[db]}"
```

## Conditionals

- Test with `[[ ... ]]` (preferred) or `[ ... ]`
- Equality: `[[ $a == $b ]]`; regex: `[[ $a =~ ^re ]]`
- File tests: `-f` file, `-d` dir, `-x` exec, `-s` non-empty, `-r/-w` readable/writable, `-L` symlink, `-nt/-ot` newer/older than

```bash
if [[ -f "$1" && -s "$1" ]]; then
  echo "File exists and not empty"
elif [[ -d "$1" ]]; then
  echo "Is a directory"
else
  echo "Missing: $1" >&2
fi
```

## Loops

- For list: `for x in 1 2 3; do ...; done`
- Brace expansion: `for n in {1..5}; do ...; done`
- C-style: `for ((i=0; i<5; i++)); do ...; done`
- While: `while command; do ...; done`
- Until: `until command; do ...; done`

```bash
#!/usr/bin/env bash
set -euo pipefail

while IFS= read -r line; do
  printf 'line: %s\n' "$line"
done < /etc/hosts
```

## Case statements

```bash
read -rp "Env? " env
case "$env" in
  prod) echo "Deploying to prod" ;;
  dev|staging) echo "Deploying to $env" ;;
  *) echo "Unknown env" ; exit 1 ;;
esac
```

## Functions

- Define: `myfn() { ...; }`
- Local vars: `local x=1`
- Return codes: `return 0` or `return 1`
- Positional args: `$1`, `$2`, `$@` (all), `$#` (count)

```bash
#!/usr/bin/env bash
set -euo pipefail

log() { printf '%s\n' "[$(date +%H:%M:%S)] $*"; }

require() {
  local path=$1
  [[ -f "$path" ]] || { log "missing $path" >&2; return 1; }
}

for f in "$@"; do require "$f"; done
```

## Positional parameters

- `$0` script name, `$1` first arg, `$@` all args (quoted preserves words), `$*` all args as one string
- Shift: `shift` drops `$1`; `while [[ $# -gt 0 ]]; do case "$1" in ...; shift ;; esac; done`

```bash
#!/usr/bin/env bash
set -euo pipefail

usage() { echo "usage: $0 -f file -v" >&2; exit 1; }

verbose=false
file=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    -f|--file) file=$2; shift 2 ;;
    -v|--verbose) verbose=true; shift ;;
    -h|--help) usage ;;
    *) usage ;;
  esac
done

"$verbose" && echo "File: $file"
```

## Exit codes and traps

- `$?` last status; success is 0
- Exit script: `exit 0` or `exit 1`
- Trap cleanup: `trap 'cleanup' EXIT` or `trap 'echo fail' ERR`

```bash
#!/usr/bin/env bash
set -euo pipefail

tmp=$(mktemp)
cleanup() { rm -f "$tmp"; }
trap cleanup EXIT

echo "temp file: $tmp"
```

## Pipelines and redirection

- Pipe: `cmd1 | cmd2`
- Redirect stdout: `> file`, append `>> file`
- Redirect stderr: `2> err.log`, merge: `cmd >out 2>&1`
- Here-doc: `cat <<'EOF'
text
EOF`
- Here-string: `cat <<< "$var"`

```bash
grep -i error /var/log/syslog | tee errors.log

cat <<'EOF' > script.env
KEY=VALUE
EOF
```

## Subshells vs grouping

- Subshell `( command1; command2 )` runs in child; env changes do not persist
- Group `{ command1; command2; }` runs in current shell; note space after `{` and semicolon before `}`

```bash
(cd /tmp && ls)   # original cwd unchanged
{ cd /tmp; ls; }  # cwd changes for rest of script
```

## Process substitution (bash)

```bash
diff <(sort file1) <(sort file2)
paste <(seq 3) <(yes hi | head -3)
```

## Background jobs & parallelism

- Background: `cmd &`
- Wait: `wait` for all or `wait <pid>`
- Named pipes: `mkfifo pipe; producer > pipe & consumer < pipe`

```bash
#!/usr/bin/env bash
set -euo pipefail

urls=(https://example.com https://example.org)
pids=()
for u in "${urls[@]}"; do
  (curl -sS "$u" -o "/tmp/$(basename "$u")") &
  pids+=($!)
done

for p in "${pids[@]}"; do wait "$p"; done
echo "downloads complete"
```

## Useful file tests

- `[[ -e path ]]` exists
- `[[ -d path ]]` directory
- `[[ -f path ]]` regular file
- `[[ -x path ]]` executable
- `[[ -s path ]]` size > 0
- `[[ file1 -nt file2 ]]` newer than
- `[[ file1 -ot file2 ]]` older than

## Regex and globbing

- Regex match: `[[ $str =~ ^[0-9]+$ ]]`
- Use capture: `[[ $str =~ ^([0-9]{4})-([0-9]{2})-([0-9]{2})$ ]] && year=${BASH_REMATCH[1]}`
- Globs: `*.sh`, `**/*.sh` with `shopt -s globstar`

```bash
shopt -s nullglob dotglob
for f in **/*.sh; do echo "$f"; done
```

## Command substitution

- Backticks `` `cmd` `` (legacy) vs `$(cmd)` (preferred)
- Nesting: `result=$(cmd "$(other)")`

## Here-doc patterns

```bash
cat <<'EOF' > hello.sh
#!/usr/bin/env bash
echo "Hi"
EOF

cat <<EOF | sed 's/foo/bar/'
foo
EOF
```

## Reading files safely

```bash
while IFS= read -r line; do
  printf '%s\n' "$line"
done < input.txt
```

## Logging helpers

```bash
log() { printf '[%s] %s\n' "$(date +%F:%T)" "$*"; }
err() { printf '[ERROR] %s\n' "$*" >&2; }
```

## Date/time

```bash
date +%s            # epoch
date -d 'yesterday' '+%F'
printf '%(%F %T)T\n' -1
```

## Filesystem operations

```bash
mkdir -p dir/sub
cp -r src/ dest/
mv old new
rm -rf path
ln -s target link
find . -type f -name '*.log' -mtime +7 -delete
```

## Networking quickies

```bash
curl -fsS https://example.com
nc -zv host 443
ss -tlnp
```

## `find` + `xargs` / `-exec`

```bash
find . -type f -name '*.sh' -print0 | xargs -0 shellcheck
find . -type f -mtime +30 -exec rm -f {} +
```

## JSON parsing (jq)

```bash
curl -s https://api.github.com | jq '.current_user_url'
```

## `getopts` for flags

```bash
#!/usr/bin/env bash
set -euo pipefail

while getopts "f:vh" opt; do
  case $opt in
    f) file=$OPTARG ;;
    v) verbose=true ;;
    h) echo "usage: $0 [-v] [-f file]"; exit 0 ;;
    *) exit 1 ;;
  esac
done
shift $((OPTIND -1))
```

## Color output

```bash
red='\033[31m'; green='\033[32m'; reset='\033[0m'
echo -e "${green}OK${reset}"
```

## Random, UUIDs, hashing

```bash
head -c16 /dev/urandom | base64
uuidgen
printf '%s' "data" | sha256sum
```

## Signals and traps

```bash
cleanup() { echo "cleanup"; }
trap cleanup EXIT
trap 'echo interrupted; exit 130' INT
```

## Common one-liners

- Count lines: `wc -l file`
- Sort unique counts: `sort file | uniq -c | sort -nr`
- Grep recursive: `rg pattern` or `grep -R pattern .`
- Disk usage summary: `du -sh ./* | sort -h`

## Template: robust script skeleton

```bash
#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

usage() { echo "Usage: $0 [-n name]" >&2; exit 1; }

name="world"
while getopts "n:h" opt; do
  case $opt in
    n) name=$OPTARG ;;
    h) usage ;;
    *) usage ;;
  esac
done
shift $((OPTIND - 1))

main() {
  echo "Hello, $name"
}

main "$@"
```

## Linting and formatting

- ShellCheck: `shellcheck script.sh`
- shfmt: `shfmt -w script.sh`

## Resources

- Bash manual: `help` builtin, `help test`, `help [[`
- `man bash`, `man find`, `man xargs`
