# git-archive

`git-archive` is a lightweight CLI tool for safely archiving and restoring Git repositories using `git bundle`.

It is designed for:
- offline backups
- repository transfers
- long-term storage
- reproducible archives

---

## Features

- Archive any Git repository into a single zip file
- Uses `git bundle` internally (no history loss)
- Archive contents are wrapped in a single root directory
- Optional SHA256 checksum generation
- Optional encryption and GPG signing
- Reliable extraction and verification
- No temporary files left in the working directory
- Fully compatible with Homebrew

---

## Installation

### Homebrew

```bash
brew install ace1ofspades/tap/git-archive
```

---

## Usage

### Archive a repository

```bash
git-archive archive
```

This creates a zip file like:

```
my-repo_2026-02-09.zip
└── my-repo_2026-02-09/
    ├── my-repo_2026-02-09.bundle
    ├── my-repo_2026-02-09.bundle.sha256
    └── manifest.json
```

> The archive is created using a temporary directory and cleaned up automatically.  
> No files are left behind in the repository.

---

### Archive options

```bash
git-archive archive [path|repo-url] [options]

Options:
  --out DIR          Output directory
  --name NAME        Custom archive name
  --prefix TEXT      Prefix for archive name
  --suffix TEXT      Suffix for archive name
  --encrypt          Encrypt the archive using AES-256
  --sign             GPG-sign the archive
  --no-checksum      Disable checksum generation
```

---

## Extract an archive

```bash
git-archive extract my-repo_2026-02-09.zip
```

This restores the repository to:

```
./my-repo_2026-02-09
```

### Extract options

```bash
git-archive extract ARCHIVE.zip [options]

Options:
  --out DIR          Output directory
  --no-verify        Skip checksum verification
  --verify-only     Verify archive only (no restore)
```

The extractor:
- works with archives containing a root directory
- discovers `.bundle` and `.sha256` files recursively
- is backward compatible with older archive formats

---

## Verification

To verify an archive without extracting:

```bash
git-archive extract my-repo_2026-02-09.zip --verify-only
```

---

## Testing

This project uses **Bats** for integration and regression testing.

Run tests locally:

```bash
brew install bats-core
bats tests/
```

Tests are automatically executed on **Pull Requests** via GitHub Actions.

---

## Compatibility

- macOS (Homebrew)
- Linux (manual install)
- Archives created with older versions are fully supported

---

## Changelog

See [CHANGELOG.md](./CHANGELOG.md) for detailed release notes.

---

## License

MIT
