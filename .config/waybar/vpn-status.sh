#!/bin/bash

nordvpn="/var/lib/snapd/snap/bin/nordvpn"

if /usr/bin/pgrep -x "openconnect" >/dev/null; then
  echo '{"text": " Salle VPN", "class": "connected", "tooltip": "Connected to University VPN"}'
  exit 0
fi

# Both Waybar instances run this module. Reuse one CLI query per update window
# because each snap CLI invocation starts a NordVPN user daemon.
CACHE_DIR="${XDG_RUNTIME_DIR:-/tmp}/waybar-vpn"
CACHE_FILE="$CACHE_DIR/status"
LOCK_FILE="$CACHE_DIR/status.lock"
mkdir -p "$CACHE_DIR"

(
  flock -x 9
  if [ ! -s "$CACHE_FILE" ] || [ "$(find "$CACHE_FILE" -mmin +0.033 2>/dev/null)" ]; then
    "$nordvpn" status 2>/dev/null 9>&- > "$CACHE_FILE.tmp"
    mv "$CACHE_FILE.tmp" "$CACHE_FILE"
  fi
  cat "$CACHE_FILE"
) 9>"$LOCK_FILE" | {
  NORD_STATUS=$(cat)

  if echo "$NORD_STATUS" | grep -qiE '^Status:[[:space:]]*Connected[[:space:]]*$'; then
    # Extract the server name, strip leading spaces, and remove hidden carriage returns
    SERVER=$(echo "$NORD_STATUS" | grep -i "^Server:" | cut -d: -f2 | xargs | tr -d '\r\n')

    echo '{"text": "󰒄 NordVPN", "class": "connected", "tooltip": "Connected to '"$SERVER"'"}'
  else
    echo '{"text": " VPN Down", "class": "disconnected", "tooltip": "Disconnected"}'
  fi
}
