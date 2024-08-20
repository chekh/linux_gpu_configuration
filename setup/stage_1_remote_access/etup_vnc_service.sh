#!/bin/bash

# Load environment variables from the configuration file
set -a
source ./config.env
set +a

# Function to create a systemd service for VNC
setup_vnc_service() {
  echo "Setting up VNC as a systemd service..."

  # Create the systemd service file
  sudo bash -c 'cat <<EOF > /etc/systemd/system/vncserver@.service
[Unit]
Description=Start TightVNC server at startup
After=syslog.target network.target

[Service]
Type=forking
User='$USER'
PAMName=login
PIDFile=/home/'$USER'/.vnc/%H:%i.pid
ExecStartPre=/usr/bin/vncserver -kill :%i > /dev/null 2>&1 || :
ExecStart=/usr/bin/vncserver -geometry 1280x800 -depth 24 -dpi 96 :%i
ExecStop=/usr/bin/vncserver -kill :%i

[Install]
WantedBy=multi-user.target
EOF'

  # Reload systemd daemon to recognize the new service
  sudo systemctl daemon-reload

  # Enable the VNC service to start at boot
  sudo systemctl enable vncserver@1.service

  # Start the VNC service immediately
  sudo systemctl start vncserver@1.service

  echo "VNC service setup completed and started."
}

# Check if VNC is enabled in the configuration
if [ "$VNC_ENABLE" == "true" ]; then
  setup_vnc_service
else
  echo "VNC is not enabled in the configuration. Skipping VNC service setup."
fi
