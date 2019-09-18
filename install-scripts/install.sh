#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive
set -e

sudo apt update
sudo -E apt install -y i3 wget curl git tmux rxvt-unicode feh \
	silversearcher-ag build-essential tcl libqt4-dev libqtwebkit-dev \
        scrot redshift xautolock xclip libssl-dev zlib1g-dev xclip \
        acpi scrot nmap libreadline-dev tzdata rofi

if [ ! -d ~/.dotfiles ]; then
  git clone git@github.com:grepsedawk/.dotfiles.git ~/.dotfiles || git clone https://github.com/grepsedawk/.dotfiles ~/.dotfiles
fi

$HOME/.dotfiles/install-scripts/vim/install.sh
$HOME/.dotfiles/install-scripts/google-chrome/install.sh
$HOME/.dotfiles/install-scripts/zsh/install.sh
$HOME/.dotfiles/install-scripts/docker/install
$HOME/.dotfiles/install-scripts/redis/install.sh
$HOME/.dotfiles/install-scripts/thefuck/install.sh
$HOME/.dotfiles/install-scripts/asdf/install.sh
# $HOME/.dotfiles/install-scripts/bc3/install.sh
$HOME/.dotfiles/install-scripts/postgresql/install.sh
$HOME/.dotfiles/install-scripts/maria-db/install.sh

# load in asdf for Ruby that was only JUST installed above
. $HOME/.asdf/asdf.sh
$HOME/.dotfiles/install-scripts/link-dotfiles.rb
