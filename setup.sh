#!/bin/bash
# Setup script for syncing Claude Code config to a new device.
# Usage: git clone <repo-url> ~/claude-config && ~/claude-config/setup.sh

set -e

CONFIG_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

mkdir -p "$CLAUDE_DIR"

ITEMS=("skills" "agents" "commands" "settings.json")

for item in "${ITEMS[@]}"; do
    target="$CLAUDE_DIR/$item"
    source="$CONFIG_DIR/$item"

    if [ -L "$target" ]; then
        echo "Symlink already exists: $target -> $(readlink "$target")"
    elif [ -e "$target" ]; then
        echo "WARNING: $target already exists (not a symlink). Backing up to ${target}.bak"
        mv "$target" "${target}.bak"
        ln -s "$source" "$target"
        echo "Linked: $target -> $source"
    else
        ln -s "$source" "$target"
        echo "Linked: $target -> $source"
    fi
done

echo ""
echo "Done! Claude Code config is now synced from $CONFIG_DIR"
