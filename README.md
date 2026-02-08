# git-archive

**git-archive** is a minimal, offline-first Git archiving tool designed to safely store inactive or legacy repositories as single archive files, without relying on hosted Git services.

It supports:
- Git bundle–based archiving
- ZIP packaging
- Optional checksum & verification
- Archive extraction (restore)
- CI-friendly exit codes
- Local and Homebrew-compatible runtime

---

## ✨ Features

- 📦 Create a single archive from a Git repository  
- 🔐 Optional checksum generation & verification  
- ♻️ Restore repositories from archives  
- 📴 Fully offline-friendly  
- 🧰 Works both as a cloned repo and a Homebrew-installed tool  
- 🤖 CI-friendly (predictable exit codes)  
- 🍺 Homebrew support  

---

## 📦 Installation

### Homebrew (recommended)

```bash
brew tap ace1ofspades/git-archive
brew install git-archive
```

Verify installation:

```bash
git-archive --version
```

---

### Manual / Local usage

Clone the repository:

```bash
git clone https://github.com/ace1ofspades/git-archive.git
cd git-archive
```

Run directly:

```bash
./bin/git-archive --version
```

No build step required.

---

## 🚀 Usage

### Archive a repository

From inside a git repository:

```bash
git-archive
```

With a custom name:

```bash
git-archive --name my-project-backup
```

This creates a single ZIP archive containing:
- a Git bundle
- metadata (manifest)
- optional checksum

---

### Extract / restore an archive

```bash
git-archive extract my-project-backup.zip
```

Optionally specify a target directory:

```bash
git-archive extract my-project-backup.zip --path ./restored
```

---

## 🔍 Runtime path resolution (important)

`git-archive` is designed to work **both** when run from a cloned repository and when installed via Homebrew.

At runtime, the tool resolves its library directory in the following order:

1. `$GIT_ARCHIVE_LIB` (if explicitly set)
2. `../lib` relative to the script (local clone usage)
3. `../libexec` (Homebrew Cellar layout)
4. `/opt/homebrew/opt/git-archive/libexec` (Homebrew stable prefix)

This approach avoids relying on Homebrew environment wrappers and ensures compatibility across:
- Homebrew installs
- manual installs
- CI environments

---

## 🤖 Exit codes

The tool uses standard, CI-friendly exit codes:

- `0` – success  
- `64` – invalid usage / arguments  
- `1` – runtime or archive error  

---

## 🛠 Development notes

- Avoid force-updating release tags (Homebrew caches aggressively).
- Always release a new version (`vX.Y.Z`) when runtime behavior changes.
- The `opt` prefix is used intentionally for Homebrew stability.

---

## 📄 License

MIT License.
