[![Build Status](https://travis-ci.org/pachonk/.dotfiles.svg?branch=master)](https://travis-ci.org/pachonk/.dotfiles)

# pachonk/.dotfiles

This is a configuration/dotfile repository for me to fast track rebuilding my development environment.

## Usage

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/pachonk/.dotfiles/master/install-scripts/install.sh)"
```

After it is done installing, you will want to change the git config from my config to your config like so:

```bash
git config --global user.name "Bobby Joe"
git config --global user.email bobby.joe@example.com
```
