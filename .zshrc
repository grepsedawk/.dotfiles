export ZSH=$HOME/.oh-my-zsh
export EDITOR='vim'

ZSH_THEME="robbyrussell"
HYPHEN_INSENSITIVE="true"
COMPLETION_WAITING_DOTS="true"
ZSH_TMUX_AUTOSTART=true
export HISTSIZE=1000000000
export SAVEHIST=$HISTSIZE
setopt EXTENDED_HISTORY
HIST_STAMPS="yyyy-mm-dd"

# Plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(git github rails bundler tmux tmuxinator asdf docker docker-compose \
         zsh_reload)

source $ZSH/oh-my-zsh.sh

[ -f ~/.zsh_aliases ] && source ~/.zsh_aliases

eval $(thefuck --alias qwer)

# for vim control+s (otherwise C^s locks and C^q unlocks)
stty -ixon

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if type nvim > /dev/null 2>&1; then
  alias vim='nvim'
fi

if [ -f "$HOME/.env" ]; then
    . "$HOME/.env"
fi
