#!/bin/bash
WALLPAPERS="$HOME"/.i3/wallpaper/
TIME=1m
while [ true ];
do
    feh --randomize --bg-fill "$WALLPAPERS" && sleep $TIME
done &
