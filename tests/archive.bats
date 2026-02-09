#!/usr/bin/env bats

load ./helpers.bash

@test "archive creates zip file" {
  run archive_zip
  [ "$status" -eq 0 ]
}

@test "archive zip contains single root directory" {
  ZIP=$(archive_zip)

  run unzip -l "$ZIP"
  [ "$status" -eq 0 ]

  [[ "$output" =~ ".*/manifest.json" ]]
  [[ "$output" =~ ".*/.*.bundle" ]]
}

@test "archive does not leave files in repo root" {
  archive_zip
  ! ls | grep -E '\.bundle$|manifest\.json'
}
