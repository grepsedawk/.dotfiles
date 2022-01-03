ZSH=$HOME/.oh-my-zsh
if [ -d /usr/share/oh-my-zsh ]; then
  ZSH=/usr/share/oh-my-zsh
fi

export EDITOR='vim'

export HISTSIZE=1000000000
export SAVEHIST=$HISTSIZE
setopt EXTENDED_HISTORY

if [ -d /opt/asdf-vm ]; then
  ASDF_DIR=/opt/asdf-vm
fi

ZSH_THEME="robbyrussell"
HYPHEN_INSENSITIVE="true"
CASE_SENSITIVE="false"
COMPLETION_WAITING_DOTS="true"
ZSH_TMUX_AUTOSTART=true
ZSH_TMUX_UNICODE=true
HIST_STAMPS="yyyy-mm-dd"
DISABLE_UPDATE_PROMPT="true"

# Plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(git github rails bundler terraform tmux tmuxinator asdf docker docker-compose \
         ssh-agent heroku aws gh fzf)

source $ZSH/oh-my-zsh.sh

[ -f ~/.zsh_aliases ] && source ~/.zsh_aliases
