#!/bin/bash

# Set up Samba file sharing if specified in the config
if [ "$SAMBA_ENABLE" == "true" ]; then
  echo "Setting up Samba..."
  sudo apt-get install -y samba
  sudo tee -a /etc/samba/smb.conf > /dev/null <<EOL

[$SAMBA_SHARE_NAME]
   path = $SAMBA_DIRECTORY
   writable = $SAMBA_WRITABLE
   guest ok = $SAMBA_GUEST_OK
   force user = $(whoami)

EOL
  sudo systemctl restart smbd
fi
