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
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y tightvncserver expect xfce4 xfce4-goodies

# Create .Xresources if it doesn't exist
if [ ! -f "$HOME/.Xresources" ]; then
    touch "$HOME/.Xresources"
fi

# Start and configure VNC
vncserver
vncserver -kill :1

# Configure VNC to use the chosen window manager
echo "Setting up VNC with $WINDOW_MANAGER..."
case "$WINDOW_MANAGER" in
    xfce)
        mv ~/.vnc/xstartup ~/.vnc/xstartup.bak
        echo "#!/bin/bash
xrdb \$HOME/.Xresources
if ! pgrep -x 'xfce4-session' > /dev/null; then
  startxfce4 &
fi" > ~/.vnc/xstartup
        ;;
    gnome)
        mv ~/.vnc/xstartup ~/.vnc/xstartup.bak
        echo "#!/bin/bash
xrdb \$HOME/.Xresources
if ! pgrep -x 'gnome-session' > /dev/null; then
  gnome-session &
fi" > ~/.vnc/xstartup
        ;;
    kde)
        mv ~/.vnc/xstartup ~/.vnc/xstartup.bak
        echo "#!/bin/bash
xrdb \$HOME/.Xresources
if ! pgrep -x 'startplasma-x11' > /dev/null; then
  startplasma-x11 &
fi" > ~/.vnc/xstartup
        ;;
    cinnamon | mint)
        mv ~/.vnc/xstartup ~/.vnc/xstartup.bak
        echo "#!/bin/bash
xrdb \$HOME/.Xresources
if ! pgrep -x 'cinnamon-session' > /dev/null; then
  cinnamon-session &
fi" > ~/.vnc/xstartup
        ;;
    mate)
        mv ~/.vnc/xstartup ~/.vnc/xstartup.bak
        echo "#!/bin/bash
xrdb \$HOME/.Xresources
if ! pgrep -x 'mate-session' > /dev/null; then
  mate-session &
fi" > ~/.vnc/xstartup
        ;;
esac

chmod +x ~/.vnc/xstartup

# Set VNC password silently
./setup_vnc_password.sh

# Start the VNC service for testing
vncserver

# Set up VNC as a systemd service
./setup_vnc_service.sh

echo "VNC setup with $WINDOW_MANAGER completed."

# Call the service status check script at the end
./check_service_status.sh
