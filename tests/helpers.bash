#!/usr/bin/env bash

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ARCHIVE="$ROOT_DIR/lib/archive.sh"
EXTRACT="$ROOT_DIR/lib/extract.sh"

setup() {
  TEST_DIR="$(mktemp -d)"
  cd "$TEST_DIR"

  git init -q
  echo "hello" > README.md
  git add README.md
  git commit -qm "init"
}

teardown() {
  cd /
  rm -rf "$TEST_DIR"
}
