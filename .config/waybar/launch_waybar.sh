#!/bin/bash

for pid in $(pgrep -x waybar 2>/dev/null); do
  kill "$pid"
done

SDIR="$HOME/.config/waybar"
STYLE="${1:-2}"
CONFIG="$SDIR/config${STYLE}"
BASE_STYLE="$SDIR/style${STYLE}.css"
for i in /sys/class/hwmon/hwmon*/temp*_input; do 
    if [ "$(<$(dirname $i)/name): $(cat ${i%_*}_label 2>/dev/null || echo $(basename ${i%_*}))" = "coretemp: Core 0" ]; then
        export HWMON_PATH="$i"
    fi
done
sed -i "/hwmon-path/c\ \ \ \ \"hwmon-path\": \"$HWMON_PATH\"," $SDIR/config1 && sed -i "/hwmon-path/c\ \ \ \ \"hwmon-path\": \"$HWMON_PATH\"," $SDIR/config2

while IFS=$'\t' read -r output width; do
  [ -n "$output" ] || continue

  if [ "$width" -lt 1700 ]; then
    style="$SDIR/style${STYLE}-compact.css"
  else
    style="$BASE_STYLE"
  fi

  safe_output="${output//[^[:alnum:]_.-]/_}"
  output_config="${XDG_RUNTIME_DIR:-/tmp}/waybar-${STYLE}-${safe_output}.jsonc"
  sed "2i\\  \"output\": [\"$output\"]," "$CONFIG" > "$output_config"
  waybar -c "$output_config" -s "$style" &
done < <(
  swaymsg -t get_outputs -r 2>/dev/null |
    jq -r '.[] | select(.active and (.non_desktop | not)) | [.name, .rect.width] | @tsv'
)
