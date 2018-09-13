#! /usr/bin/env bash
sudo apt install -y neovim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# bootstrap nvim to use vim config locations
mkdir -p ~/.config/nvim/
cat << EOF > $HOME/.config/nvim/init.vim
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc
EOF
