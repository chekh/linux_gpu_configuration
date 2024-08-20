#!/bin/bash

# Load environment variables from the configuration file
set -a
source ./config.env
set +a

# Function to set VNC password silently
setup_vnc_password() {
    echo "Setting up VNC password..."

    expect <<EOF
spawn vncpasswd
expect "Password:"
send "$VNC_PASSWORD\r"
expect "Verify:"
send "$VNC_PASSWORD\r"
expect "Would you like to enter a view-only password (y/n)?"
send "n\r"
expect eof
EOF

    echo "VNC password setup completed."
}

# Check if VNC is enabled in the configuration and the password is set
if [ "$VNC_ENABLE" == "true" ] && [ -n "$VNC_PASSWORD" ]; then
    setup_vnc_password
else
    echo "VNC is not enabled or VNC_PASSWORD is not set in the configuration. Skipping VNC password setup."
fi
