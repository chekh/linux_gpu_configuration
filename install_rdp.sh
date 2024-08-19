#!/bin/bash

# Set up RDP if specified in the config
if [ "$RDP_ENABLE" == "true" ]; then
  echo "Setting up RDP..."
  sudo apt-get install -y xfce4 xrdp
  sudo systemctl enable xrdp
  sudo systemctl start xrdp

  # Configure xrdp to use XFCE
  echo "Configuring xrdp to use XFCE..."
  sudo bash -c 'echo "xfce4-session" > /etc/skel/.xsession'
  sudo bash -c 'echo "xfce4-session" > ~/.xsession'

  # Open the port for RDP if firewall is enabled
  if [ "$FIREWALL_ENABLE" == "true" ]; then
    sudo ufw allow $RDP_PORT/tcp
  fi
fi
