#!/bin/bash
# Lock with a blurred copy of the wallpaper currently shown by swaybg (follows theme changes).
img=$(pgrep -a swaybg | head -n1 | sed -nE 's/.* -i +(.+) +-m .*/\1/p')
[ -f "$img" ] || img="$HOME/Pictures/Wallpapers/wallpaper.png"

# Stock swaylock can't blur, so blur with ImageMagick and cache the result.
cache="${XDG_CACHE_HOME:-$HOME/.cache}/swaylock"
mkdir -p "$cache"
key=$(printf '%s' "$img$(stat -c %Y "$img")" | md5sum | cut -d' ' -f1)
blurred="$cache/$key.png"
if [ ! -f "$blurred" ]; then
    magick "$img" -resize 2560x -blur 0x10 "$blurred.tmp.png" && mv "$blurred.tmp.png" "$blurred"
fi
[ -f "$blurred" ] && img="$blurred"

swaylock \
    -f \
    -i "$img" \
    -s fill \
    --indicator-radius 50 \
    --indicator-thickness 5 \
    --ring-color 3b4252 \
    --key-hl-color 880033 \
    --line-color 00000000 \
    --inside-color 00000088 \
    --separator-color 00000000

# Fingerprint unlock, independent of PAM so the password works at any time.
# swaylock is already locked here (-f); watch the sensor in the background and
# unlock (SIGUSR1) on a match. The watcher exits when swaylock does.
(
    while pgrep -x swaylock >/dev/null; do
        if timeout 10 fprintd-verify 2>&1 | grep -q 'verify-match'; then
            pkill -USR1 -x swaylock
            break
        fi
        sleep 1
    done
) >/dev/null 2>&1 &
disown
