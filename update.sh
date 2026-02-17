#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "Updating talon-wiki subtree..."
git subtree pull --prefix=subtrees/talon-wiki https://github.com/TalonCommunity/Wiki.git main --squash

echo "Updating skills subtree..."
git subtree pull --prefix=subtrees/skills https://github.com/anthropics/skills.git main --squash

echo "Subtrees updated. Run ./build.sh to rebuild skills."
