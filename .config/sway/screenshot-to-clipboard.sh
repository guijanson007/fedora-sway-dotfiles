#!/bin/sh

set -eu

geometry=$(slurp -d) || exit 1
[ -n "$geometry" ] || exit 1

if ! grim -g "$geometry" - | wl-copy --foreground --type image/png; then
    notify-send -u critical -a screenshot "Screenshot failed" "The image could not be copied to the clipboard."
    exit 1
fi
