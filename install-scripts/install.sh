#! /usr/bin/env bash

sudo apt update
sudo apt install -y vim i3 git tmux shutter rxvt-unicode feh \
	silversearcher-ag build-essential tcl libqt4-dev libqtwebkit-dev

if [ ! -d ~/.dotfiles ]; then
  git clone https://github.com/pachonk/.dotfiles ~/.dotfiles
fi

$HOME/.dotfiles/install-scripts/google-chrome/install.sh
$HOME/.dotfiles/install-scripts/zsh/install.sh
$HOME/.dotfiles/install-scripts/redis/install-redis.sh
$HOME/.dotfiles/install-scripts/thefuck/install.sh
$HOME/.dotfiles/install-scripts/asdf/install.sh
$HOME/.dotfiles/install-scripts/bc3/install.sh

# TODO install .dotfiles automatically

# TODO: Install maria/libmysqlclient-dev


