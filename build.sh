#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Parse flags
UPDATE=false
for arg in "$@"; do
  case "$arg" in
    --update)
      UPDATE=true
      ;;
    *)
      echo "Unknown option: $arg"
      echo "Usage: $0 [--update]"
      exit 1
      ;;
  esac
done

# Update subtrees if requested
if [ "$UPDATE" = true ]; then
  echo "Updating talon-wiki subtree..."
  git subtree pull --prefix=subtrees/talon-wiki https://github.com/TalonCommunity/Wiki.git main --squash

  echo "Updating skills subtree..."
  git subtree pull --prefix=subtrees/skills https://github.com/anthropics/skills.git main --squash

  echo "Subtrees updated."
fi

# Clean and recreate output directory
rm -rf skills
mkdir -p skills

# Copy talon skill from src
cp -r src/talon skills/talon

# Copy wiki reference docs into talon skill
mkdir -p skills/talon/references
cp subtrees/talon-wiki/docs/Customization/talon-files.md skills/talon/references/talon-files.md
cp subtrees/talon-wiki/docs/Customization/talon_lists.md skills/talon/references/talon-lists.md
cp subtrees/talon-wiki/docs/Customization/misc-tips.md skills/talon/references/misc-tips.md

# Copy skill-creator skill
cp -r subtrees/skills/skills/skill-creator skills/skill-creator

echo "Build complete. Skills output to skills/"
ls -la skills/
