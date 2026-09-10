#!/bin/sh
set -eu
repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
work_dir=$(mktemp -d)
trap 'rm -rf -- "$work_dir"' 0
trap 'exit 1' HUP INT TERM

sh "$repo_dir/install.sh" "$work_dir/custom skills"
diff -r "$repo_dir/skills/project-critic" "$work_dir/custom skills/project-critic"
printf 'keep me\n' > "$work_dir/custom skills/project-critic/local.txt"
if sh "$repo_dir/install.sh" "$work_dir/custom skills"; then
  echo 'FAIL: overwrite was allowed' >&2
  exit 1
fi
test "$(cat "$work_dir/custom skills/project-critic/local.txt")" = 'keep me'

mkdir -p "$work_dir/home"
HOME="$work_dir/home" sh "$repo_dir/install.sh"
diff -r "$repo_dir/skills/project-critic" "$work_dir/home/.agents/skills/project-critic"

mkdir -p "$work_dir/link skills"
ln -s "$work_dir/missing" "$work_dir/link skills/project-critic"
if sh "$repo_dir/install.sh" "$work_dir/link skills"; then
  echo 'FAIL: dangling symlink was overwritten' >&2
  exit 1
fi
test -L "$work_dir/link skills/project-critic"

if sh "$repo_dir/install.sh" one two; then
  echo 'FAIL: extra arguments were accepted' >&2
  exit 1
fi
printf 'All installer tests passed (custom path, exact copy, overwrite refusal, default path, symlink refusal, argument validation).\n'
