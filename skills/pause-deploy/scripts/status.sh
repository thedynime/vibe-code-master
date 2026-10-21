#!/usr/bin/env bash
# status.sh - Checks whether deployment is currently paused
set -e

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
LOCK_FILE="$REPO_ROOT/.deploy-pause"

if [ -f "$LOCK_FILE" ]; then
  echo "STATUS: PAUSED (🛑 Live deployment is frozen. Local testing only.)"
  exit 0
else
  echo "STATUS: OPEN (🟢 Standard deployment mode is active.)"
  exit 1
fi
