#!/bin/sh
# Install without replacing any existing skill.
set -eu
if [ "$#" -gt 1 ]; then
  echo "Usage: $0 [skills-directory]" >&2
  exit 2
fi
source_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
skills_dir=${1:-"$HOME/.agents/skills"}
destination="$skills_dir/project-critic"
if [ -e "$destination" ] || [ -L "$destination" ]; then
  echo "Refusing to overwrite existing skill: $destination" >&2
  exit 1
fi
mkdir -p "$skills_dir"
# mkdir is also the exclusive claim if two installers run concurrently.
mkdir "$destination"
trap 'rm -rf -- "$destination"' 0
trap 'exit 1' HUP INT TERM
cp -R "$source_dir/skills/project-critic/." "$destination/"
trap - 0 HUP INT TERM
printf 'Installed project-critic to %s\n' "$destination"
