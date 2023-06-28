
## Source:
- [Gitleaks](https://github.com/gitleaks/gitleaks)


## Installation notes

`make all` will install `gitleaks`. The install will:

- install `gitleaks`
- add a global `pre-commit` hook to `$HOME/.git-dir/hooks/pre-commit`
- add the configuration with central config patterns to `$HOME/.git-dir/gitleaks.toml`

You now have the gitleaks pre-commit hook enabled globally.

## Deletion notes
`make clean` will remove `gitleaks` and clean `git config`.

## Usage notes
- `make detect` - detect secrets in code
- `make version` - displaying the installed version of gitleaks

## 

[![gitleaks](https://asciinema.org/a/593718.svg)](https://asciinema.org/a/593718)