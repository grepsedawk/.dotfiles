#!/bin/bash

hsetroot -solid "#22212c"

set -e

. /opt/asdf-vm/asdf.sh

WALLPAPERS="$HOME"/.i3/wallpaper/
TIME=1m
while [ true ];
do
    ruby ~/.i3/generate_wallpaper.rb
    feh --bg-fill /tmp/wallpaper.png
    convert /tmp/wallpaper.png -blur 0x8 /tmp/wallpaper-blurred.png
    sleep $TIME
done &
