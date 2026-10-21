#!/usr/bin/env bash
# unlock.sh - Removes the .deploy-pause lock file
set -e

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
LOCK_FILE="$REPO_ROOT/.deploy-pause"

if [ -f "$LOCK_FILE" ]; then
  rm -f "$LOCK_FILE"
  echo "🟢 Deployment lock removed: $LOCK_FILE"
  echo "Standard single-prompt edit-and-deploy mode restored."
else
  echo "🟢 No active deployment lock found ($LOCK_FILE). Standard deployment mode active."
fi
