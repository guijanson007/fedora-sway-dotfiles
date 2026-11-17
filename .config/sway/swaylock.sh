#!/bin/bash
# Lock with the wallpaper currently shown by swaybg (follows theme changes).
img=$(pgrep -a swaybg | head -n1 | sed -nE 's/.* -i +(.+) +-m .*/\1/p')
[ -f "$img" ] || img="$HOME/Pictures/Wallpapers/wallpaper.png"

exec swaylock \
    -f \
    -i "$img" \
    -s fill \
    --indicator-radius 100 \
    --indicator-thickness 7 \
    --ring-color 3b4252 \
    --key-hl-color 880033 \
    --line-color 00000000 \
    --inside-color 00000088 \
    --separator-color 00000000
