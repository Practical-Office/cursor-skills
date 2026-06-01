#!/usr/bin/env bash
# Install Practical Office Cursor skills into ~/.cursor/skills/ (and optionally .cursor/skills/)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SKILLS_SRC="$REPO_ROOT/skills"
USER_SKILLS_DIR="${HOME}/.cursor/skills"
PROJECT_INSTALL=false

usage() {
  cat <<EOF
Usage: $(basename "$0") [--project]

Install all skills from this repo into Cursor's skills directory.

Options:
  --project   Also install into .cursor/skills/ in the current working directory

Default target: ~/.cursor/skills/
Skills are symlinked to this git clone when possible (falls back to copy).

After install, run setup-practical-ai-skills once per application repository.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project)
      PROJECT_INSTALL=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

install_to() {
  local target_dir="$1"
  local mode="$2"  # "symlink" or "copy"

  mkdir -p "$target_dir"

  local skill name dest
  for skill in "$SKILLS_SRC"/*/; do
    name="$(basename "$skill")"
    dest="$target_dir/$name"

    if [[ -L "$dest" ]]; then
      rm "$dest"
    elif [[ -d "$dest" ]]; then
      rm -rf "$dest"
    fi

    if [[ "$mode" == "symlink" ]]; then
      ln -s "$skill" "$dest"
    else
      cp -R "$skill" "$dest"
    fi
  done
}

# Prefer symlinks for user install (single source of truth from git clone)
install_to "$USER_SKILLS_DIR" "symlink"

echo "Installed $(find "$SKILLS_SRC" -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ') skills to $USER_SKILLS_DIR:"
find "$SKILLS_SRC" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sort | sed 's/^/  - /'

if $PROJECT_INSTALL; then
  install_to "$(pwd)/.cursor/skills" "copy"
  echo ""
  echo "Also installed (copied) to $(pwd)/.cursor/skills/"
fi

echo ""
echo "Next step: open any application repo in Cursor and run setup-practical-ai-skills once."
echo "Update skills later: git pull in $REPO_ROOT && re-run this script."
