#!/usr/bin/env bash

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BIN="$ROOT_DIR/bin/git-archive"

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
