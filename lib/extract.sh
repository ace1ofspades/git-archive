#!/usr/bin/env bash
set -euo pipefail

run_extract() {
  ZIP="$1"; shift
  OUT=""
  VERIFY=true
  VERIFY_ONLY=false

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --out) OUT="$2"; shift 2 ;;
      --no-verify) VERIFY=false; shift ;;
      --verify-only) VERIFY_ONLY=true; shift ;;
      *) shift ;;
    esac
  done

  [[ -f "$ZIP" ]] || die "Archive not found" 20

  OUT="${OUT:-$(pwd)}"
  mkdir -p "$OUT"

  TMP=$(mktemp -d)

  unzip -q "$ZIP" -d "$TMP"

  # ─────────────────────────────────────────────
  # 🔍 Checksum (recursive)
  SHA=$(find "$TMP" -type f -name "*.sha256" | head -n1)

  if $VERIFY_ONLY; then
    [[ -n "$SHA" ]] || die "No checksum found for verify-only" 20
    (
      cd "$(dirname "$SHA")" || exit 1
      $HASH_CMD "$(basename "$SHA")"
    ) || die "Verification failed" 10

    echo "✅ Verification OK"
    rm -rf "$TMP"
    exit 0
  fi

  if $VERIFY && [[ -n "$SHA" ]]; then
    (
      cd "$(dirname "$SHA")" || exit 1
      $HASH_CMD "$(basename "$SHA")"
    ) || die "Verification failed" 10
  fi

  # ─────────────────────────────────────────────
  # 📦 Bundle (recursive)
  BUNDLE=$(find "$TMP" -type f -name "*.bundle" | head -n1)
  [[ -n "$BUNDLE" ]] || die "No .bundle file found in archive" 20

  NAME=$(basename "$BUNDLE" .bundle)

  git clone "$BUNDLE" "$OUT/$NAME"

  echo "✅ Repository extracted to $OUT/$NAME"

  rm -rf "$TMP"
}
