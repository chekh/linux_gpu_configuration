#!/bin/bash

# Install Python if specified in the config
if [ "$PYTHON_INSTALL" == "true" ]; then
  echo "Checking Python version..."
  INSTALLED_PYTHON_VERSION=$(python3 --version | awk '{print $2}')
  if [ "$INSTALLED_PYTHON_VERSION" != "$PYTHON_VERSION" ]; then
    echo "Installing Python version $PYTHON_VERSION..."
    sudo apt-get install -y python$PYTHON_VERSION python$PYTHON_VERSION-dev python$PYTHON_VERSION-venv
    sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python$PYTHON_VERSION 1
  else
    echo "Python version $PYTHON_VERSION is already installed."
  fi
  echo "Upgrading pip..."
  python3 -m pip install --upgrade pip
fi
