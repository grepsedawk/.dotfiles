ZSH=$HOME/.oh-my-zsh
if [ -d /usr/share/oh-my-zsh ]; then
  ZSH=/usr/share/oh-my-zsh
fi

export EDITOR='nvim'

export HISTSIZE=1000000000
export SAVEHIST=$HISTSIZE
setopt EXTENDED_HISTORY SHARE_HISTORY

ZSH_THEME="robbyrussell"
HYPHEN_INSENSITIVE="true"
CASE_SENSITIVE="false"
COMPLETION_WAITING_DOTS="true"
ZSH_TMUX_AUTOSTART=false
ZSH_TMUX_UNICODE=true
HIST_STAMPS="yyyy-mm-dd"
DISABLE_UPDATE_PROMPT="true"

# Plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(git github rails bundler terraform tmux tmuxinator docker asdf docker-compose \
         ssh-agent heroku aws gh fzf zsh-autosuggestions brew)

source $ZSH/oh-my-zsh.sh

[ -f ~/.zsh_aliases ] && source ~/.zsh_aliases

export LSCOLORS="Exfxcxdxbxegedabagacad"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Only automatically run brew update every 24 hours
if [[ $(command -v brew) == "" ]]; then
  export HOMEBREW_AUTO_UPDATE_SECS=86400
fi
