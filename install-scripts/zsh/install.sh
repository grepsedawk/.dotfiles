#! /usr/bin/env bash
sudo apt install -y zsh
if [ ! -d ~/.oh-my-zsh ]; then
  git clone git@github.com:robbyrussell/oh-my-zsh.git ~/.oh-my-zsh || git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
fi
sudo chsh -s /bin/zsh

