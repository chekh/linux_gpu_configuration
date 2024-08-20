#!/bin/bash

# Load environment variables from the configuration file
set -a
source ./config.env
set +a

# Install Python 3.11 if specified in the config
if [ "$PYTHON_INSTALL" == "true" ]; then
  echo "Installing Python $PYTHON_VERSION..."

  # Add deadsnakes PPA to get Python 3.11
  sudo add-apt-repository ppa:deadsnakes/ppa -y
  sudo apt-get update

  # Install Python 3.11
  sudo apt-get install -y python$PYTHON_VERSION python$PYTHON_VERSION-dev python$PYTHON_VERSION-venv

  # Update alternatives to set Python 3.11 as the default Python
  sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python$PYTHON_VERSION 2
  sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 2

  # Manually set Python 3.11 as the default
  sudo update-alternatives --set python3 /usr/bin/python$PYTHON_VERSION
  sudo update-alternatives --set python /usr/bin/python3

  # Verify the change
  PYTHON_CURRENT_VERSION=$(python3 --version | awk '{print $2}')
  echo "Current default Python version is $PYTHON_CURRENT_VERSION"

  # Update .bashrc to ensure the correct paths are used
  if ! grep -q "alias python=python3" ~/.bashrc; then
    echo "alias python=python3" >> ~/.bashrc
  fi
  if ! grep -q "alias pip=pip3" ~/.bashrc; then
    echo "alias pip=pip3" >> ~/.bashrc
  fi

  echo "Reloading .bashrc..."
  source ~/.bashrc
fi
