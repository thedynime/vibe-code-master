#!/usr/bin/env bash
# lock.sh - Creates the .deploy-pause lock file in git root or current directory
set -e

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
LOCK_FILE="$REPO_ROOT/.deploy-pause"

touch "$LOCK_FILE"
echo "🛑 Deployment lock activated: $LOCK_FILE"
echo "Live deployments and git push commands are now blocked."
