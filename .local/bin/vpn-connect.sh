#!/bin/bash

set -e

GATEWAY="cadi.salle.url.edu"
GUI_SCRIPT="$HOME/gp-saml-gui/gp_saml_gui.py"

# Capture SAML login output
AUTH_OUTPUT=$(/usr/bin/python3 "$GUI_SCRIPT" --gateway "$GATEWAY" --clientos=Windows)

# Extract COOKIE and USER variables
COOKIE=$(echo "$AUTH_OUTPUT" | grep "^COOKIE=" | cut -d '=' -f 2-)
USERNAME=$(echo "$AUTH_OUTPUT" | grep "^USER=" | cut -d '=' -f 2- | tr -d "'")

if [[ -z "$COOKIE" || -z "$USERNAME" ]]; then
  echo "Error: Failed to capture SAML cookie or username."
  exit 1
fi

# Pipe the extracted cookie into openconnect and fork to background
echo "$COOKIE" | sudo openconnect --background \
  --pid-file=/run/openconnect.pid \
  --protocol=gp \
  '--useragent=PAN GlobalProtect' \
  --user="$USERNAME" \
  --os=win \
  --usergroup=gateway:prelogin-cookie \
  --passwd-on-stdin "$GATEWAY"
