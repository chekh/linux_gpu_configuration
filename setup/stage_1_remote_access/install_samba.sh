#!/bin/bash

# Load environment variables from the configuration file
set -a
source ./config.env
set +a

# Setup Samba if specified in the config
if [ "$SAMBA_ENABLE" == "true" ]; then
  echo "Setting up Samba..."

  # Install Samba
  sudo apt-get install -y samba

  # Configure Samba
  sudo tee -a /etc/samba/smb.conf > /dev/null <<EOL

[$SAMBA_SHARE_NAME]
   path = $SAMBA_DIRECTORY
   writable = $SAMBA_WRITABLE
   guest ok = $SAMBA_GUEST_OK
   force user = $(whoami)

EOL

  # Restart Samba service
  sudo systemctl restart smbd

  echo "Samba setup completed."
fi
