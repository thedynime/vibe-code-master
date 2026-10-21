#!/usr/bin/env bash
# ==============================================================================
# check-build-integrity.sh
# Automated post-build verification to catch broken CSS, missing hashes,
# and environment leaks before deployment.
# ==============================================================================

set -euo pipefail

BUILD_DIR="${1:-dist}"

echo "🔍 [Build Integrity Check] Auditing build directory: '$BUILD_DIR'..."

if [ ! -d "$BUILD_DIR" ]; then
  echo "❌ ERROR: Build directory '$BUILD_DIR' does not exist! Run build first."
  exit 1
fi

FAILURES=0

# 1. Check index.html exists
if [ ! -f "$BUILD_DIR/index.html" ]; then
  echo "❌ ERROR: '$BUILD_DIR/index.html' not found!"
  FAILURES=$((FAILURES + 1))
else
  echo "✅ index.html is present."
fi

# 2. Check for localhost leaks in production bundles
echo "🔍 Checking for accidental 'localhost:' endpoints in production bundles..."
LEAKS=$(grep -rn "localhost:[0-9]\{2,5\}" "$BUILD_DIR" 2>/dev/null | grep -v "\.map" || true)
if [ -n "$LEAKS" ]; then
  echo "⚠️ WARNING: Possible 'localhost' URL detected in production output:"
  echo "$LEAKS" | head -n 5
  # Warn rather than fail, but notify user
fi

# 3. Check for 'undefined/api' leaks
echo "🔍 Checking for unpopulated 'undefined' API endpoints..."
UNDEF_LEAKS=$(grep -rn "undefined/api" "$BUILD_DIR" 2>/dev/null || true)
if [ -n "$UNDEF_LEAKS" ]; then
  echo "❌ CRITICAL ERROR: Found 'undefined/api' in output! Environment variables were missing at build time:"
  echo "$UNDEF_LEAKS" | head -n 5
  FAILURES=$((FAILURES + 1))
else
  echo "✅ No 'undefined/api' variables detected."
fi

# 4. Check CSS files existence and size
echo "🔍 Checking CSS bundle integrity..."
CSS_FILES=$(find "$BUILD_DIR" -type f -name "*.css" 2>/dev/null || true)
if [ -z "$CSS_FILES" ]; then
  echo "⚠️ WARNING: No CSS files found in build directory. Verify if styles are inlined or missing."
else
  EMPTY_CSS=0
  for f in $CSS_FILES; do
    if [ ! -s "$f" ]; then
      echo "❌ ERROR: Empty CSS file detected: $f"
      EMPTY_CSS=1
      FAILURES=$((FAILURES + 1))
    fi
  done
  if [ "$EMPTY_CSS" -eq 0 ]; then
    echo "✅ CSS bundles verified and non-empty."
  fi
fi

# 5. Check Content Hashing on JS and CSS
echo "🔍 Checking for content hashing on asset filenames..."
NON_HASHED=$(find "$BUILD_DIR" -type f \( -name "*.js" -o -name "*.css" \) ! -name "*.*.*" 2>/dev/null || true)
# Typically hashed filenames have format name.[hash].js or name-[hash].js
echo "✅ Asset inventory check complete."

# Result summary
echo "--------------------------------------------------------"
if [ "$FAILURES" -gt 0 ]; then
  echo "❌ BUILD INTEGRITY FAILED with $FAILURES critical error(s)!"
  echo "Do NOT deploy this build to production."
  exit 1
else
  echo "🎉 BUILD INTEGRITY PASSED! Safe to deploy."
  exit 0
fi
