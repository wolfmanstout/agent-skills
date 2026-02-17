#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

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
