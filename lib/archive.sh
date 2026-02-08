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

  git bundle create "$ARCHIVE_NAME.bundle" --all

  FILES=("$ARCHIVE_NAME.bundle")

  if ! $NO_CHECKSUM; then
    $HASH_CMD "$ARCHIVE_NAME.bundle" > "$ARCHIVE_NAME.bundle.sha256"
    FILES+=("$ARCHIVE_NAME.bundle.sha256")
  fi

  # manifest.json
  COMMIT=$(git rev-parse HEAD)
  BRANCHES=$(git branch | wc -l | tr -d ' ')
  TAGS=$(git tag | wc -l | tr -d ' ')
  cat <<EOF > manifest.json
{
  "repo": "$REPO",
  "archived_at": "$(date -Iseconds)",
  "head": "$COMMIT",
  "branches": $BRANCHES,
  "tags": $TAGS,
  "checksum": $([ "$NO_CHECKSUM" = true ] && echo false || echo true),
  "tool": "git-archive",
  "version": "0.2.1"
}
EOF

  FILES+=("manifest.json")
  zip -q "$ARCHIVE_NAME.zip" "${FILES[@]}"

  if $ENCRYPT; then
    openssl aes-256-cbc -salt -in "$ARCHIVE_NAME.zip" -out "$ARCHIVE_NAME.zip.enc" || die "Encryption failed" 30
    rm "$ARCHIVE_NAME.zip"
    FINAL="$ARCHIVE_NAME.zip.enc"
  else
    FINAL="$ARCHIVE_NAME.zip"
  fi

  if $SIGN; then
    gpg --detach-sign "$FINAL" || die "GPG signing failed" 30
  fi

  mv "$ARCHIVE_NAME."* "$OUT/"
  rm -f manifest.json

  echo "✅ Archive created: $OUT/$FINAL"
}
