#!/usr/bin/env bats

load ./helpers.bash

@test "extract works with root-folder zip" {
  bash "$ARCHIVE"
  ZIP=$(ls *.zip | head -n1)

  mkdir out
  run bash "$EXTRACT" "$ZIP" --out out
  [ "$status" -eq 0 ]

  ls out/*
}

@test "verify-only works" {
  bash "$ARCHIVE"
  ZIP=$(ls *.zip | head -n1)

  run bash "$EXTRACT" "$ZIP" --verify-only
  [ "$status" -eq 0 ]
}

@test "extract fails gracefully if no bundle exists" {
  zip bad.zip README.md
  run bash "$EXTRACT" bad.zip
  [ "$status" -ne 0 ]
}
