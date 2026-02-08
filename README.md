# git-archive

Offline-first Git archiving tool.

## New in v0.2.1
- --no-checksum (skip checksum generation)
- --verify-only (verify archive without restore)

## Usage

### Archive
```bash
git-archive
git-archive --no-checksum
git-archive --name legacy --encrypt
```

### Verify only
```bash
git-archive extract repo.zip --verify-only
```

### Extract
```bash
git-archive extract repo.zip --out ~/restore
```

## Exit codes
- 0 success
- 10 verification failed
- 20 invalid input
- 30 crypto error
- 64 usage error
