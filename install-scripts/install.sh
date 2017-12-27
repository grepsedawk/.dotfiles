#!/usr/bin/env bash

sudo apt update
sudo apt install -y i3 git tmux shutter rxvt-unicode feh \
	silversearcher-ag build-essential tcl libqt4-dev libqtwebkit-dev \
        scrot redshift xautolock xclip libssl-dev zlib1g-dev xclip \
        acpi scrot nmap libreadline6 libreadline6-dev

if [ ! -d ~/.dotfiles ]; then
  git clone git@github.com:pachonk/.dotfiles.git ~/.dotfiles || git clone https://github.com/pachonk/.dotfiles ~/.dotfiles
fi

$HOME/.dotfiles/install-scripts/vim/install.sh
$HOME/.dotfiles/install-scripts/google-chrome/install.sh
$HOME/.dotfiles/install-scripts/zsh/install.sh
$HOME/.dotfiles/install-scripts/redis/install.sh
$HOME/.dotfiles/install-scripts/thefuck/install.sh
$HOME/.dotfiles/install-scripts/asdf/install.sh
# $HOME/.dotfiles/install-scripts/bc3/install.sh
# $HOME/.dotfiles/install-scripts/jetbrains-toolbox/install.sh
$HOME/.dotfiles/install-scripts/postgresql/install.sh
$HOME/.dotfiles/install-scripts/maria-db/install.sh

# load in asdf for Ruby that was only JUST installed above
. $HOME/.asdf/asdf.sh
$HOME/.dotfiles/install-scripts/link-dotfiles.rb
