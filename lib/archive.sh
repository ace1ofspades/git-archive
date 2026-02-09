#!/usr/bin/env bash
set -euo pipefail

run_archive() {
  NAME=""
  PREFIX=""
  SUFFIX=""
  OUT=""
  ENCRYPT=false
  SIGN=false
  NO_CHECKSUM=false
  TARGET="."

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --name) NAME="$2"; shift 2 ;;
      --prefix) PREFIX="$2"; shift 2 ;;
      --suffix) SUFFIX="$2"; shift 2 ;;
      --out) OUT="$2"; shift 2 ;;
      --encrypt) ENCRYPT=true; shift ;;
      --sign) SIGN=true; shift ;;
      --no-checksum) NO_CHECKSUM=true; shift ;;
      *) TARGET="$1"; shift ;;
    esac
  done

  ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || die "Not a git repository" 20
  REPO=$(basename "$ROOT")
  DATE=$(date +%Y-%m-%d)

  BASE="${NAME:-$REPO}"
  ARCHIVE_NAME="${PREFIX}${BASE}${SUFFIX}_${DATE}"
  OUT="${OUT:-$ROOT}"

  cd "$ROOT"

  # ─────────────────────────────────────────────
  # 1️⃣ Geçici dizin
  TMP_DIR=$(mktemp -d)
  ARCHIVE_DIR="$TMP_DIR/$ARCHIVE_NAME"
  mkdir -p "$ARCHIVE_DIR"

  # ─────────────────────────────────────────────
  # 2️⃣ Git bundle
  git bundle create "$ARCHIVE_DIR/$ARCHIVE_NAME.bundle" --all

  # ─────────────────────────────────────────────
  # 3️⃣ Checksum
  if ! $NO_CHECKSUM; then
    $HASH_CMD "$ARCHIVE_DIR/$ARCHIVE_NAME.bundle" \
      > "$ARCHIVE_DIR/$ARCHIVE_NAME.bundle.sha256"
  fi

  # ─────────────────────────────────────────────
  # 4️⃣ Manifest
  COMMIT=$(git rev-parse HEAD)
  BRANCHES=$(git branch | wc -l | tr -d ' ')
  TAGS=$(git tag | wc -l | tr -d ' ')

  cat <<EOF > "$ARCHIVE_DIR/manifest.json"
{
  "repo": "$REPO",
  "archived_at": "$(date -Iseconds)",
  "head": "$COMMIT",
  "branches": $BRANCHES,
  "tags": $TAGS,
  "checksum": $([ "$NO_CHECKSUM" = true ] && echo false || echo true),
  "tool": "git-archive",
  "version": "$(git describe --tags --dirty --always)"
}
EOF

  # ─────────────────────────────────────────────
  # 5️⃣ Zip (root = klasör)
  (
    cd "$TMP_DIR" || exit 1
    zip -qr "$ARCHIVE_NAME.zip" "$ARCHIVE_NAME"
  )

  # ─────────────────────────────────────────────
  # 6️⃣ Encrypt (opsiyonel)
  FINAL="$ARCHIVE_NAME.zip"
  if $ENCRYPT; then
    openssl aes-256-cbc -salt \
      -in "$TMP_DIR/$ARCHIVE_NAME.zip" \
      -out "$TMP_DIR/$ARCHIVE_NAME.zip.enc" || die "Encryption failed" 30
    rm -f "$TMP_DIR/$ARCHIVE_NAME.zip"
    FINAL="$ARCHIVE_NAME.zip.enc"
  fi

  # ─────────────────────────────────────────────
  # 7️⃣ Sign (opsiyonel)
  if $SIGN; then
    gpg --detach-sign "$TMP_DIR/$FINAL" || die "GPG signing failed" 30
  fi

  # ─────────────────────────────────────────────
  # 8️⃣ Çıktıyı taşı
  mkdir -p "$OUT"
  mv "$TMP_DIR/$FINAL"* "$OUT/"

  # ─────────────────────────────────────────────
  # 9️⃣ TEMİZLİK (kritik)
  rm -rf "$TMP_DIR"

  echo "✅ Archive created: $OUT/$FINAL"
}
