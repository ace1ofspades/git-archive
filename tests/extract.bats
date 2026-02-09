#!/usr/bin/env bats

load ./helpers.bash

@test "extract works with root-folder zip" {
  "$BIN" archive
  ZIP=$(ls *.zip | head -n1)

  mkdir out
  run "$BIN" extract "$ZIP" --out out
  [ "$status" -eq 0 ]

  ls out/*
}

@test "verify-only works" {
  "$BIN" archive
  ZIP=$(ls *.zip | head -n1)

  run "$BIN" extract "$ZIP" --verify-only
  [ "$status" -eq 0 ]
}

@test "extract fails gracefully if no bundle exists" {
  zip bad.zip README.md
  run "$BIN" extract bad.zip
  [ "$status" -ne 0 ]
}
