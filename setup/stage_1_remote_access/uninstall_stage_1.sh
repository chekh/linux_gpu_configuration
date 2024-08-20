#!/bin/bash

# Function to remove packages
remove_packages() {
    echo "Removing packages: $@"
    sudo apt-get remove --purge -y "$@"
}

# Function to stop and disable a service
remove_service() {
    local service_name=$1
    echo "Stopping and disabling service: $service_name"
    sudo systemctl stop $service_name
    sudo systemctl disable $service_name
    sudo rm -f /etc/systemd/system/$service_name
}

# Load environment variables from the configuration file
set -a
source ./config.env
set +a

# Get the current desktop environment
CURRENT_DESKTOP=$(echo $XDG_SESSION_DESKTOP)

# Remove RDP related packages and configurations
if [ "$RDP_ENABLE" == "true" ]; then
    echo "Uninstalling RDP components..."
    remove_packages xrdp xfce4 xfce4-goodies
    remove_service xrdp.service
    remove_service xrdp-sesman.service
    sudo rm -rf /etc/xrdp
    sudo rm -f ~/.xsession
fi

# Remove VNC related packages and configurations if VNC was enabled
if [ "$VNC_ENABLE" == "true" ]; then
    echo "Uninstalling VNC components..."
    remove_packages tightvncserver expect xfonts-75dpi xfonts-100dpi
    remove_service vncserver@1.service
    sudo rm -rf ~/.vnc
fi

# Remove other window managers if they were installed and CLEAR_PREVIOUS_WM was set to true
if [ "$CLEAR_PREVIOUS_WM" == "true" ]; then
    echo "Clearing previous window manager..."
    case "$WINDOW_MANAGER" in
        xfce)
            if [ "$CURRENT_DESKTOP" != "xfce" ]; then
                remove_packages xfce4 xfce4-goodies
            else
                echo "Skipping removal of XFCE, as it is the current desktop environment."
            fi
            ;;
        gnome)
            if [ "$CURRENT_DESKTOP" != "ubuntu" ] && [ "$CURRENT_DESKTOP" != "gnome" ]; then
                remove_packages ubuntu-desktop
            else
                echo "Skipping removal of GNOME, as it is the current desktop environment."
            fi
            ;;
        kde)
            if [ "$CURRENT_DESKTOP" != "kde" ]; then
                remove_packages kde-plasma-desktop
            else
                echo "Skipping removal of KDE, as it is the current desktop environment."
            fi
            ;;
        cinnamon)
            if [ "$CURRENT_DESKTOP" != "cinnamon" ]; then
                remove_packages cinnamon-desktop-environment
            else
                echo "Skipping removal of Cinnamon, as it is the current desktop environment."
            fi
            ;;
        mate)
            if [ "$CURRENT_DESKTOP" != "mate" ]; then
                remove_packages mate-desktop-environment
            else
                echo "Skipping removal of MATE, as it is the current desktop environment."
            fi
            ;;
        mint)
            if [ "$CURRENT_DESKTOP" != "cinnamon" ]; then
                remove_packages mint-meta-cinnamon
            elif [ "$CURRENT_DESKTOP" != "mate" ]; then
                remove_packages mint-meta-mate
            else
                echo "Skipping removal of Linux Mint desktop environments, as they are the current desktop environment."
            fi
            ;;
    esac
fi

# Clean up autoremove any remaining unused packages
echo "Cleaning up..."
sudo apt-get autoremove -y
sudo apt-get clean

echo "Uninstallation of stage_1 components completed."
