#!/bin/bash

# Define the menu options
OPTIONS="  Connect University VPN\n󰒄  Connect NordVPN\n  Disconnect University VPN\n  Disconnect NordVPN"

# Launch rofi and capture the selected option
CHOICE=$(echo -e "$OPTIONS" | rofi -dmenu -i -p "VPN Action:" -theme-str 'window {width: 400px;}')

# Execute the corresponding command using wildcard matching to ignore icon spacing
case "$CHOICE" in
*"Connect University VPN")
  kitty -e ~/.local/bin/vpn-connect.sh
  ;;
*"Connect NordVPN")
  # Ensure you have logged into the official NordVPN CLI tool
  kitty -e nordvpn connect
  ;;
*"Disconnect University VPN")
  kitty -e sudo killall -SIGINT openconnect
  ;;
*"Disconnect NordVPN")
  kitty -e nordvpn disconnect
  ;;
esac
