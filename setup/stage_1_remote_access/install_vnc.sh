#!/bin/bash

# Load environment variables from the configuration file
set -a
source ./config.env
set +a

# Clear previous window manager if the flag is set
./clear_windows_manager.sh

# Install VNC if specified in the config
if [ "$VNC_ENABLE" == "true" ]; then
  echo "Setting up VNC with $WINDOW_MANAGER..."

  # Install the chosen window manager if not already installed
  case "$WINDOW_MANAGER" in
    xfce)
      sudo apt-get install -y xfce4 xfce4-goodies tightvncserver
      ;;
    gnome)
      sudo apt-get install -y ubuntu-desktop tightvncserver
      ;;
    kde)
      sudo apt-get install -y kde-plasma-desktop tightvncserver
      ;;
    cinnamon)
      sudo apt-get install -y cinnamon-desktop-environment tightvncserver
      ;;
    mate)
      sudo apt-get install -y mate-desktop-environment tightvncserver
      ;;
    mint)
      sudo apt-get install -y mint-meta-cinnamon tightvncserver  # Or mint-meta-mate if you prefer MATE
      ;;
    *)
      echo "Unsupported window manager: $WINDOW_MANAGER"
      exit 1
      ;;
  esac

  # Start and configure VNC
  vncserver
  vncserver -kill :1

  # Configure VNC to use the chosen window manager
  case "$WINDOW_MANAGER" in
    xfce)
      mv ~/.vnc/xstartup ~/.vnc/xstartup.bak
      echo "#!/bin/bash
xrdb \$HOME/.Xresources
startxfce4 &" > ~/.vnc/xstartup
      ;;
    gnome)
      mv ~/.vnc/xstartup ~/.vnc/xstartup.bak
      echo "#!/bin/bash
xrdb \$HOME/.Xresources
gnome-session &" > ~/.vnc/xstartup
      ;;
    kde)
      mv ~/.vnc/xstartup ~/.vnc/xstartup.bak
      echo "#!/bin/bash
xrdb \$HOME/.Xresources
startplasma-x11 &" > ~/.vnc/xstartup
      ;;
    cinnamon | mint)
      mv ~/.vnc/xstartup ~/.vnc/xstartup.bak
      echo "#!/bin/bash
xrdb \$HOME/.Xresources
cinnamon-session &" > ~/.vnc/xstartup
      ;;
    mate)
      mv ~/.vnc/xstartup ~/.vnc/xstartup.bak
      echo "#!/bin/bash
xrdb \$HOME/.Xresources
mate-session &" > ~/.vnc/xstartup
      ;;
  esac

  chmod +x ~/.vnc/xstartup
  vncserver

  # Set up VNC as a systemd service
  ./setup_vnc_service.sh

  echo "VNC setup with $WINDOW_MANAGER completed."
fi
