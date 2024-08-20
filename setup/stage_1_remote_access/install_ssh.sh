#!/bin/bash

# Set up SSH and SFTP if specified in the config
if [ "$SSH_ENABLE" == "true" ]; then
  echo "Setting up SSH..."
  sudo apt-get install -y openssh-server
  sudo sed -i "s/#Port 22/Port $SSH_PORT/g" /etc/ssh/sshd_config
  sudo systemctl enable ssh
  sudo systemctl start ssh

  # Configure SFTP if enabled in the config
  if [ "$SFTP_ENABLE" == "true" ]; then
    echo "Configuring SFTP..."
    # Additional SFTP setup can be done here if needed
  fi
fi
