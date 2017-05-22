#! /usr/bin/env bash

sudo apt update

# Install Google Chrome
sudo apt install libxss1 libappindicator1 libindicator7
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
sudo apt install -yf
sudo apt install -y vim i3 git zsh tmux shutter rxvt-unicode feh \
	silversearcher-ag build-essential tcl libqt4-dev libqtwebkit-dev
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

# TODO: only do if not yet exists
git clone https://github.com/pachonk/config ~/.dotfiles
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
\curl -sSL https://get.rvm.io | bash

$HOME/.dotfiles/redis/install-redis.sh

# TODO install .dotfiles automatically

# TODO: Install maria/libmysqlclient-dev

