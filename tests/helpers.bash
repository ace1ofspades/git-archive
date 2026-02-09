#!/usr/bin/env bash

export PATH="$PWD/bin:$PATH"

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

archive_zip() {
  git-archive archive
  ls *.zip | head -n1
}
