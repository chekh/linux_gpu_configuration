#!/bin/bash

# Load environment variables from the configuration file
set -a
source ./config.env
set +a

# Get the current desktop environment
CURRENT_DESKTOP=$(echo $XDG_SESSION_DESKTOP)

# Function to remove packages safely
remove_packages_safely() {
    local packages=$1
    local env_name=$2
    if [ "$CURRENT_DESKTOP" != "$env_name" ]; then
        echo "Removing $env_name packages: $packages"
        sudo apt-get remove --purge -y $packages
    else
        echo "Skipping removal of $env_name, as it is the current desktop environment."
    fi
}

# Clear previous window manager if the flag is set
if [ "$CLEAR_PREVIOUS_WM" == "true" ]; then
    echo "Clearing previous window manager..."
    case "$WINDOW_MANAGER" in
        xfce)
            remove_packages_safely "xfce4 xfce4-goodies" "xfce"
            ;;
        gnome)
            remove_packages_safely "ubuntu-desktop" "gnome"
            ;;
        kde)
            remove_packages_safely "kde-plasma-desktop" "kde"
            ;;
        cinnamon)
            remove_packages_safely "cinnamon-desktop-environment" "cinnamon"
            ;;
        mate)
            remove_packages_safely "mate-desktop-environment" "mate"
            ;;
        mint)
            remove_packages_safely "mint-meta-cinnamon mint-meta-mate" "cinnamon"
            ;;
    esac
fi

# Ensure necessary packages are installed with automatic confirmation
sudo DEBIAN_FRONTEND=noninteractive apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y xrdp xfce4 xfce4-goodies

# Install and configure the chosen window manager for RDP
if [ "$RDP_ENABLE" == "true" ]; then
    echo "Setting up RDP with $WINDOW_MANAGER..."

    case "$WINDOW_MANAGER" in
        xfce)
            # Ensure XFCE is installed
            sudo apt-get install -y xfce4 xfce4-goodies

            # Configure xrdp to use XFCE
            echo "startxfce4" > ~/.xsession
            chmod +x ~/.xsession

            # Update xrdp startwm.sh to use .xsession
            sudo sed -i '1i if [ -r ~/.xsession ]; then exec ~/.xsession; exit 0; fi' /etc/xrdp/startwm.sh

            # Enable and start xrdp service
            sudo systemctl enable xrdp
            sudo systemctl restart xrdp

            echo "RDP setup with XFCE completed."
            ;;
        *)
            echo "Unsupported window manager: $WINDOW_MANAGER"
            exit 1
            ;;
    esac
else
    echo "RDP is not enabled in the configuration."
fi

# Call the service status check script at the end
./check_service_status.sh
