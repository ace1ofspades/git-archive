die() { echo "❌ $1" >&2; exit "${2:-1}"; }

require() { command -v "$1" >/dev/null 2>&1 || die "Missing dependency: $1" 127; }

require git
require zip
require unzip

if command -v sha256sum >/dev/null 2>&1; then
  HASH_CMD="sha256sum"
else
  HASH_CMD="shasum -a 256"
fi

usage() {
cat <<EOF
git-archive 0.2.1

Usage:
  git-archive archive [path|repo-url] [options]
  git-archive extract ARCHIVE.zip [options]

Archive options:
  --out DIR
  --name NAME
  --prefix TEXT
  --suffix TEXT
  --encrypt
  --sign
  --no-checksum     Do not generate checksum

Extract options:
  --out DIR
  --no-verify       Skip checksum verification
  --verify-only     Verify archive only (no restore)

Other:
  --version

Exit codes:
  0  Success
  10 Verification failed
  20 Invalid input
  30 Crypto/sign error
  64 Usage error
EOF
}
