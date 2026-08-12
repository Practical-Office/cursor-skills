#!/usr/bin/env bash
# Install Practical Office Cursor skills into ~/.cursor/skills/ (and optionally .cursor/skills/)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SKILLS_SRC="$REPO_ROOT/skills"
USER_SKILLS_DIR="${HOME}/.cursor/skills"
PROJECT_INSTALL=false

# Expected skill folders (keep in sync with README skill index).
# install_to still discovers skills/*/; this list is what install.sh prints
# and validates so new skills (e.g. pr-review) show up in the install output.
EXPECTED_SKILLS=(
  caveman
  create-pr
  design-an-interface
  diagnose
  grill-me
  grill-with-docs
  handoff
  improve-codebase-architecture
  pr-review
  prototype
  qa
  release-readiness
  request-refactor-plan
  review
  security-secrets-check
  setup-practical-ai-skills
  setup-pre-commit
  task-handoff
  tdd
  tenant-isolation-check
  to-issues
  to-prd
  triage
  ubiquitous-language
  write-a-skill
  zoom-out
)

usage() {
  cat <<EOF
Usage: $(basename "$0") [--project]

Install all skills from this repo into Cursor's skills directory.

Options:
  --project   Also install into .cursor/skills/ in the current working directory

Default target: ~/.cursor/skills/
Skills are symlinked to this git clone when possible (falls back to copy).

Skill catalog (also printed after install):
$(printf '  - %s\n' "${EXPECTED_SKILLS[@]}")

After install, run setup-practical-ai-skills once per application repository.
Invoke /pr-review in Cursor to gate-and-merge GitHub PRs.
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

list_installed_skills() {
  find "$SKILLS_SRC" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sort
}

validate_expected_skills() {
  local missing=0 name
  for name in "${EXPECTED_SKILLS[@]}"; do
    if [[ ! -d "$SKILLS_SRC/$name" ]]; then
      echo "ERROR: expected skill missing from repo: $name" >&2
      missing=1
    fi
  done
  if [[ "$missing" -ne 0 ]]; then
    exit 1
  fi
}

validate_expected_skills

# Prefer symlinks for user install (single source of truth from git clone)
install_to "$USER_SKILLS_DIR" "symlink"

installed_count="$(list_installed_skills | wc -l | tr -d ' ')"
expected_count="${#EXPECTED_SKILLS[@]}"

echo "Installed ${installed_count} skills to $USER_SKILLS_DIR (catalog expects ${expected_count}):"
list_installed_skills | sed 's/^/  - /'

if $PROJECT_INSTALL; then
  install_to "$(pwd)/.cursor/skills" "copy"
  echo ""
  echo "Also installed (copied) to $(pwd)/.cursor/skills/"
fi

echo ""
echo "Next step: open any application repo in Cursor and run setup-practical-ai-skills once."
echo "PR gate: invoke /pr-review to inspect, approve/request-changes, and squash-merge when green."
echo "Update skills later: git pull in $REPO_ROOT && re-run this script."
