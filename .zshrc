# This .zshrc is slimmed down, for full configuration options, visit:
# https://github.com/robbyrussell/oh-my-zsh/blob/master/templates/zshrc.zsh-template

export ZSH=$HOME/.oh-my-zsh
export EDITOR='vim'

ZSH_THEME="robbyrussell"
HYPHEN_INSENSITIVE="true"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="yyyy-mm-dd"
ZSH_TMUX_AUTOSTART=true

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(git rails bundler tmux tmuxinator asdf)

# additional git aliases
alias gfc='git fetch upstream && git checkout upstream/master'
alias gfr='git fetch upstream && git rebase -i upstream/master'

source $ZSH/oh-my-zsh.sh

eval $(thefuck --alias qwer)

# for vim control+s
stty -ixon

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
