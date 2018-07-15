#! /usr/bin/env bash
if [ ! -d ~/.asdf ]; then
  git clone git@github.com:asdf-vm/asdf.git ~/.asdf --branch v0.3.0 || git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.3.0
fi

. $HOME/.asdf/asdf.sh

asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby.git
asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git

asdf install ruby 2.5.1

asdf global ruby 2.5.1
