#!/usr/bin/env bash
set -e

print_usage() {
  echo "Usage:"
  echo "  git archive                 # archive current repo"
  echo "  git archive <repo-url>      # archive remote repo"
  echo ""
  echo "Examples:"
  echo "  git archive"
  echo "  git archive https://github.com/org/repo.git"
}

require() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "❌ Required command not found: $1"
    exit 1
  }
}

require git
require zip
require sha256sum

TMP_DIR=""
cleanup() {
  [[ -n "$TMP_DIR" ]] && rm -rf "$TMP_DIR"
}
trap cleanup EXIT

DATE=$(date +%Y-%m-%d)

if [[ $# -eq 0 ]]; then
  ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || {
    echo "❌ Not inside a git repository"
    exit 1
  }
  cd "$ROOT"
  REPO_NAME=$(basename "$ROOT")
else
  REPO_URL="$1"
  REPO_NAME=$(basename "$REPO_URL" .git)
  TMP_DIR=$(mktemp -d)
  echo "📥 Cloning remote repo (bare): $REPO_URL"
  git clone --bare "$REPO_URL" "$TMP_DIR/$REPO_NAME.git"
  cd "$TMP_DIR/$REPO_NAME.git"
fi

ARCHIVE_NAME="${REPO_NAME}_${DATE}"

echo "📦 Creating git bundle"
git bundle create "${ARCHIVE_NAME}.bundle" --all

echo "🔐 Creating sha256 digest"
sha256sum "${ARCHIVE_NAME}.bundle" > "${ARCHIVE_NAME}.bundle.sha256"

echo "🗜️ Creating zip archive"
zip -q "${ARCHIVE_NAME}.zip"   "${ARCHIVE_NAME}.bundle"   "${ARCHIVE_NAME}.bundle.sha256"

echo "✅ Archive created:"
echo "   ${ARCHIVE_NAME}.zip"
