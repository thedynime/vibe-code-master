#!/usr/bin/env bash
# ==============================================================================
# Vibe Code Master — Universal Agentic Installer
# Installs all 290+ skills, plugins, MCP servers, and rules into your local
# Antigravity (~/.gemini/config/), Claude Code, Codex, or Cursor environment.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/thedynime/vibe-code-master/main/scripts/install.sh | bash
#   or from cloned repo: ./scripts/install.sh
# ==============================================================================

set -e

DEST_CONFIG="${HOME}/.gemini/config"
DEST_SKILLS="${DEST_CONFIG}/skills"
DEST_PLUGINS="${DEST_CONFIG}/plugins"
DEST_SCRIPTS="${DEST_CONFIG}/scripts"

echo "⚡ [Vibe Code Master] Preparing local environment at ${DEST_CONFIG}..."
mkdir -p "${DEST_SKILLS}" "${DEST_PLUGINS}" "${DEST_SCRIPTS}"

TMP_DIR=""
if [ -d "./skills" ]; then
  SRC_DIR="."
else
  TMP_DIR=$(mktemp -d)
  echo "📥 Cloning latest Vibe Code Master..."
  git clone --depth 1 https://github.com/thedynime/vibe-code-master.git "$TMP_DIR"
  SRC_DIR="$TMP_DIR"
fi

echo "📦 Installing standalone skills..."
cp -R "${SRC_DIR}/skills/"* "${DEST_SKILLS}/"

echo "🔌 Installing plugins..."
cp -R "${SRC_DIR}/plugins/"* "${DEST_PLUGINS}/"

echo "📜 Installing global instruction rules..."
cp "${SRC_DIR}/rules/GEMINI.md" "${DEST_CONFIG}/GEMINI.md"
cp "${SRC_DIR}/rules/AGENTS.md" "${DEST_CONFIG}/AGENTS.md"

echo "🛠️ Installing scripts..."
cp -R "${SRC_DIR}/scripts/"* "${DEST_SCRIPTS}/"

if [ -n "$TMP_DIR" ]; then
  rm -rf "$TMP_DIR"
fi

echo "🎉 [Vibe Code Master] Installation successful!"
echo "All 290+ skills, plugins, and universal rules are ready in your agentic runtime."
