if [ -d "$HOME/.bin" ] ; then
    PATH="$HOME/.bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "/snap/bin" ] ; then
    PATH="/snap/bin:$PATH"
fi

if [ -d /opt/homebrew/bin ]; then
  export PATH="/opt/homebrew/bin/:$PATH"
fi

if [ -f "$HOME/.env" ]; then
    . "$HOME/.env"
fi

export FZF_CTRL_T_COMMAND="ag -g ''"
export FZF_DEFAULT_COMMAND="ag -g ''"

export GTK_THEME=Adwaita:dark

if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
    exec startx;
fi
