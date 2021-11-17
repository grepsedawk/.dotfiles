#!/bin/bash

hsetroot -solid "#22212c"

set -e

. /opt/asdf-vm/asdf.sh

WALLPAPERS="$HOME"/.i3/wallpaper/
TIME=5
while [ true ];
do
    ruby ~/.i3/generate_wallpaper.rb
    feh --bg-fill /tmp/wallpaper.png
    sleep $TIME
done &
