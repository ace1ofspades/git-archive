#!/usr/bin/env bats

load ./helpers.bash

@test "archive creates zip file" {
  run bash "$ARCHIVE"
  [ "$status" -eq 0 ]
  ls *.zip
}

@test "archive zip contains single root directory" {
  bash "$ARCHIVE"
  ZIP=$(ls *.zip | head -n1)

  run unzip -l "$ZIP"
  [ "$status" -eq 0 ]

  [[ "$output" =~ ".*/manifest.json" ]]
  [[ "$output" =~ ".*/.*.bundle" ]]
}

@test "archive does not leave files in repo root" {
  bash "$ARCHIVE"
  ! ls | grep -E '\.bundle$|manifest\.json'
}
