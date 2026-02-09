#!/usr/bin/env bats

load ./helpers.bash

@test "archive creates zip file" {
  run git-archive archive
  [ "$status" -eq 0 ]
  ls *.zip
}

@test "archive zip contains single root directory" {
  run git-archive archive
  ZIP=$(ls *.zip | head -n1)

  run unzip -l "$ZIP"
  [ "$status" -eq 0 ]

  [[ "$output" =~ ".*/manifest.json" ]]
  [[ "$output" =~ ".*/.*.bundle" ]]
}

@test "archive does not leave files in repo root" {
  run git-archive archive

  ! ls | grep -E '\.bundle$|manifest\.json'
}
