#! /usr/bin/env bash
if [ ! -d ~/.asdf ]; then
  git clone git@github.com:asdf-vm/asdf.git ~/.asdf --branch v0.3.0 || git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.3.0
fi

. $HOME/.asdf/asdf.sh

asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby.git
asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git

asdf install ruby 2.4.1
asdf install ruby 2.3.4

asdf install nodejs 6.11.0

