# set PATH so it includes user's private bins if they exist
if [ -d "$HOME/.bin" ] ; then
    PATH="$HOME/.bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# add snap to path if snap bins exist
if [ -d "/snap/bin" ] ; then
    PATH="/snap/bin:$PATH"
fi

# Environment Variables
if [ -f "$HOME/.env" ]; then
    . "$HOME/.env"
fi

# use ag to get the file list for fzf
# this will be a little faster (by over 10x) and it will stop things
# that I don't care about from getting into my fzf results
export FZF_CTRL_T_COMMAND="ag -g ''"
export FZF_DEFAULT_COMMAND="ag -g ''"

if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
    exec startx;
fi
