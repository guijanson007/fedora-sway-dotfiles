#!/bin/bash

pkill -x waybar 2>/dev/null
# Wait for old instances to exit so they don't fight over the tray (max ~3s)
for _ in $(seq 30); do
  pgrep -x waybar >/dev/null || break
  sleep 0.1
done
pkill -9 -x waybar 2>/dev/null

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

# Tray only on the main monitor (HDMI-A-2 if active, else the first output)
OUTPUTS=$(swaymsg -t get_outputs -r 2>/dev/null |
  jq -r '.[] | select(.active and (.non_desktop | not)) | [.name, .rect.width] | @tsv')
if printf '%s\n' "$OUTPUTS" | cut -f1 | grep -qx 'HDMI-A-2'; then
  TRAY_OUTPUT="HDMI-A-2"
else
  TRAY_OUTPUT=$(printf '%s\n' "$OUTPUTS" | head -n1 | cut -f1)
fi

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
  if [ "$output" != "$TRAY_OUTPUT" ]; then
    sed -i '/^[[:space:]]*"tray"[[:space:]]*$/d' "$output_config"
  fi
  waybar -c "$output_config" -s "$style" </dev/null &
done <<< "$OUTPUTS"
