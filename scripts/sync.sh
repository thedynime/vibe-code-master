#!/usr/bin/env bash
# ==============================================================================
# Vibe Code Master — Full Auto-Sync & Git Push Engine
# Automatically synchronizes skills, plugins, MCP, and rules from your active
# agentic workspace into this repository, commits changes, and pushes to GitHub.
#
# Usage:
#   ./scripts/sync.sh
#   npm run sync
# ==============================================================================

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_DIR"

echo "⚡ [Vibe Code Master] Running synchronization engine..."
node "$REPO_DIR/scripts/sync.js"

echo "📝 [Vibe Code Master] Staging git modifications..."
git add -A

CHANGES=$(git status --porcelain)

if [ -z "$CHANGES" ]; then
  echo "✨ No new skill or plugin updates detected. Everything is up-to-date!"
  exit 0
fi

TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
SKILL_COUNT=$(find "$REPO_DIR/skills" -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')
PLUGIN_COUNT=$(find "$REPO_DIR/plugins" -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')

COMMIT_MSG="chore(sync): update agentic skills ($SKILL_COUNT), plugins ($PLUGIN_COUNT) & rules [$TIMESTAMP]"

echo "📦 [Vibe Code Master] Committing changes: $COMMIT_MSG"
git commit -m "$COMMIT_MSG"

echo "🚀 [Vibe Code Master] Pushing updates to origin main..."
git branch -M main
git push -u origin main

echo "🎉 [Vibe Code Master] Sync & Push successfully completed!"
