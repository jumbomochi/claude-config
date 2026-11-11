#!/bin/bash
# Setup script for syncing Claude Code config to a new device.
# Usage: git clone <repo-url> ~/claude-config && ~/claude-config/setup.sh

set -e

CONFIG_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

mkdir -p "$CLAUDE_DIR"

ITEMS=("skills" "agents" "CLAUDE.md")

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

# gstack is gitignored (1GB+ clone); install it at the commit pinned in gstack.lock.
GSTACK_DIR="$CONFIG_DIR/skills/gstack"
GSTACK_REPO=$(sed -n 's/^repo=//p' "$CONFIG_DIR/gstack.lock")
GSTACK_COMMIT=$(sed -n 's/^commit=//p' "$CONFIG_DIR/gstack.lock")
if [ ! -d "$GSTACK_DIR/.git" ]; then
    git clone "$GSTACK_REPO" "$GSTACK_DIR"
fi
git -C "$GSTACK_DIR" fetch --quiet origin
git -C "$GSTACK_DIR" checkout --quiet "$GSTACK_COMMIT"
echo "gstack pinned at $GSTACK_COMMIT. Run its ./setup if this is a fresh clone."

echo ""
echo "Done! Claude Code config is now synced from $CONFIG_DIR"
