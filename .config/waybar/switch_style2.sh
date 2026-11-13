#!/bin/bash
"$HOME/.config/waybar/launch_waybar.sh" 2 &
swaymsg gaps outer all set 0 && swaymsg gaps inner all set 5
