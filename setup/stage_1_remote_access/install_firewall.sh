#!/bin/bash

# Load environment variables from the configuration file
set -a
source ./config.env
set +a

# Setup firewall (ufw)
if [ "$FIREWALL_ENABLE" == "true" ]; then
  echo "Setting up firewall with UFW..."

  # Install UFW if not already installed
  sudo apt-get install -y ufw

  # Allow necessary ports
  sudo ufw allow $SSH_PORT/tcp
  sudo ufw allow $VNC_PORT/tcp
  sudo ufw allow $RDP_PORT/tcp
  sudo ufw allow $JUPYTER_PORT/tcp

  # Allow Samba ports if Samba is enabled
  if [ "$SAMBA_ENABLE" == "true" ]; then
    sudo ufw allow 137,138/udp
    sudo ufw allow 139,445/tcp
  fi

  # Enable UFW
  sudo ufw enable

  echo "Firewall setup completed."
fi
