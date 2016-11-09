#!/bin/sh -e
revert() {
  xset dpms 0 0 0
}
trap revert SIGHUP SIGINT SIGTERM
xset +dpms dpms 15 15 15

# Take a screenshot
scrot /tmp/screen_locked.png

# blur
convert /tmp/screen_locked.png -blur 0x5 /tmp/screen_locked.png
# Lock screen displaying this image.
i3lock -n -i /tmp/screen_locked.png

revert
