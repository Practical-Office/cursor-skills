#!/usr/bin/env bash
# Re-copy skills from mattpocock/skills upstream (optional maintenance script)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
UPSTREAM_URL="${UPSTREAM_URL:-https://github.com/mattpocock/skills.git}"
UPSTREAM_DIR="${UPSTREAM_DIR:-/tmp/mattpocock-skills-sync}"

echo "Cloning upstream: $UPSTREAM_URL"
rm -rf "$UPSTREAM_DIR"
git clone --depth 1 "$UPSTREAM_URL" "$UPSTREAM_DIR"
UPSTREAM_SHA="$(git -C "$UPSTREAM_DIR" rev-parse HEAD)"
echo "Upstream commit: $UPSTREAM_SHA"

# Skill copy map: dest_name:source_path
pairs=(
  "setup-practical-ai-skills:skills/engineering/setup-matt-pocock-skills"
  "grill-with-docs:skills/engineering/grill-with-docs"
  "grill-me:skills/productivity/grill-me"
  "tdd:skills/engineering/tdd"
  "diagnose:skills/engineering/diagnose"
  "handoff:skills/productivity/handoff"
  "write-a-skill:skills/productivity/write-a-skill"
  "triage:skills/engineering/triage"
  "to-issues:skills/engineering/to-issues"
  "to-prd:skills/engineering/to-prd"
  "zoom-out:skills/engineering/zoom-out"
  "review:skills/in-progress/review"
  "improve-codebase-architecture:skills/engineering/improve-codebase-architecture"
  "prototype:skills/engineering/prototype"
  "ubiquitous-language:skills/deprecated/ubiquitous-language"
  "design-an-interface:skills/deprecated/design-an-interface"
  "request-refactor-plan:skills/deprecated/request-refactor-plan"
  "qa:skills/deprecated/qa"
  "setup-pre-commit:skills/misc/setup-pre-commit"
  "caveman:skills/productivity/caveman"
)

SKILLS_DEST="$REPO_ROOT/skills"
mkdir -p "$SKILLS_DEST"

for pair in "${pairs[@]}"; do
  dest="${pair%%:*}"
  src="${pair#*:}"
  rm -rf "$SKILLS_DEST/$dest"
  cp -R "$UPSTREAM_DIR/$src" "$SKILLS_DEST/$dest"
done

# Practical Office adaptations
find "$SKILLS_DEST" -type f \( -name "*.md" -o -name "*.sh" \) -print0 | while IFS= read -r -d '' f; do
  sed -i '' \
    -e 's/setup-matt-pocock-skills/setup-practical-ai-skills/g' \
    -e "s/Setup Matt Pocock's Skills/Setup Practical AI Skills/g" \
    -e "s/Matt Pocock's Skills/Practical AI Skills/g" \
    -e 's/Label in mattpocock\/skills/Label in Practical AI skills/g' \
    -e 's/name: setup-matt-pocock-skills/name: setup-practical-ai-skills/' \
    "$f"
done

echo ""
echo "Synced 20 upstream skills. Tier C originals (5) were NOT overwritten."
echo "Update ATTRIBUTION.md with: source: mattpocock/skills@${UPSTREAM_SHA}"
echo "Re-run ./scripts/install.sh to refresh ~/.cursor/skills/ symlinks."
