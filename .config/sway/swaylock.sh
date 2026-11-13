#!/bin/bash
if swaylock --help 2>&1 | grep -q -- '--screenshots'; then
    swaylock  \
           --screenshots \
           --clock \
           --indicator \
           --indicator-radius 100 \
           --indicator-thickness 7 \
           --effect-blur 7x5 \
           --effect-vignette 0.5:0.5 \
           --ring-color 3b4252 \
           --key-hl-color 880033 \
           --line-color 00000000 \
           --inside-color 00000088 \
           --separator-color 00000000 \
           --grace 2 \
           --fade-in 0.3
else
    swaylock \
           -f \
           -i "$HOME/Pictures/Wallpapers/wallpaper.png" \
           -s fill \
           --indicator-radius 100 \
           --indicator-thickness 7 \
           --ring-color 3b4252 \
           --key-hl-color 880033 \
           --line-color 00000000 \
           --inside-color 00000088 \
           --separator-color 00000000
fi

