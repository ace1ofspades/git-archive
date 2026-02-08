# git-archive

Minimal, offline ve güvenli Git arşivleme aracı.

## Özellikler
- Local repo arşivleme
- Remote repo (URL) arşivleme
- git bundle + SHA256 checksum
- Tek ZIP çıktı

## Kurulum

```bash
mkdir -p ~/.local/bin
curl -fsSL https://raw.githubusercontent.com/USERNAME/git-archive/main/git-archive.sh \
  -o ~/.local/bin/git-archive
chmod +x ~/.local/bin/git-archive
```

PATH yoksa:
```bash
export PATH="$HOME/.local/bin:$PATH"
```

## Kullanım

### Local repo
```bash
git archive
```

### Remote repo
```bash
git archive https://github.com/org/repo.git
```

## Çıktı
```
repo-name_YYYY-MM-DD.zip
```
