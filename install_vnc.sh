#!/bin/bash

# Set up VNC if specified in the config
if [ "$VNC_ENABLE" == "true" ]; then
  echo "Setting up VNC..."
  sudo apt-get install -y xfce4 xfce4-goodies tightvncserver
  vncserver
  # Stop the server to modify the configuration
  vncserver -kill :1
  mv ~/.vnc/xstartup ~/.vnc/xstartup.bak
  echo "#!/bin/bash
xrdb \$HOME/.Xresources
startxfce4 &" > ~/.vnc/xstartup
  chmod +x ~/.vnc/xstartup
  vncserver
  # Open the port for VNC if firewall is enabled
  if [ "$FIREWALL_ENABLE" == "true" ]; then
    sudo ufw allow $VNC_PORT/tcp
  fi
fi
