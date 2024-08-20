#!/bin/bash

# Load environment variables from the configuration file
set -a
source ./config.env
set +a

# Ensure necessary packages are installed
sudo apt-get update
sudo apt-get install -y xrdp

# Clear previous window manager if the flag is set
./clear_windows_manager.sh

# Install and configure the chosen window manager
if [ "$RDP_ENABLE" == "true" ]; then
  echo "Setting up RDP with $WINDOW_MANAGER..."

  # Install the chosen window manager if not already installed
  case "$WINDOW_MANAGER" in
    xfce)
      sudo apt-get install -y xfce4 xfce4-goodies
      ;;
    gnome)
      sudo apt-get install -y ubuntu-desktop
      ;;
    kde)
      sudo apt-get install -y kde-plasma-desktop
      ;;
    cinnamon)
      sudo apt-get install -y cinnamon-desktop-environment
      ;;
    mate)
      sudo apt-get install -y mate-desktop-environment
      ;;
    mint)
      sudo apt-get install -y mint-meta-cinnamon  # Or mint-meta-mate if you prefer MATE
      ;;
    *)
      echo "Unsupported window manager: $WINDOW_MANAGER"
      exit 1
      ;;
  esac

  # Enable and start the xrdp service
  sudo systemctl enable xrdp
  sudo systemctl start xrdp

  # Configure xrdp to use the chosen window manager
  case "$WINDOW_MANAGER" in
    xfce)
      echo "xfce4-session" | sudo tee /etc/skel/.xsession > /dev/null
      ;;
    gnome)
      echo "gnome-session" | sudo tee /etc/skel/.xsession > /dev/null
      ;;
    kde)
      echo "startplasma-x11" | sudo tee /etc/skel/.xsession > /dev/null
      ;;
    cinnamon | mint)
      echo "cinnamon-session" | sudo tee /etc/skel/.xsession > /dev/null
      ;;
    mate)
      echo "mate-session" | sudo tee /etc/skel/.xsession > /dev/null
      ;;
  esac

  echo "RDP setup with $WINDOW_MANAGER completed."
else
  echo "RDP is not enabled in the configuration."
fi
