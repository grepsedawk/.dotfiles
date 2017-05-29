#! /usr/bin/env bash

sudo apt update
sudo apt install -y vim i3 git tmux shutter rxvt-unicode feh \
	silversearcher-ag build-essential tcl libqt4-dev libqtwebkit-dev

if [ ! -d ~/.dotfiles ]; then
  git clone https://github.com/pachonk/.dotfiles ~/.dotfiles
fi

$HOME/.dotfiles/google-chrome/install.sh
$HOME/.dotfiles/zsh/install.sh
$HOME/.dotfiles/redis/install-redis.sh
$HOME/.dotfiles/thefuck/install.sh
$HOME/.dotfiles/asdf/install.sh
$HOME/.dotfiles/bc3/install.sh

# TODO install .dotfiles automatically

# TODO: Install maria/libmysqlclient-dev


