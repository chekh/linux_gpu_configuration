#!/bin/bash

# Load environment variables from the configuration file
set -a
source ./config.env
set +a

# Install Python if specified in the config
if [ "$PYTHON_INSTALL" == "true" ]; then
  echo "Installing Python $PYTHON_VERSION..."

  # Install Python 3.11
  sudo apt-get update
  sudo apt-get install -y python$PYTHON_VERSION python$PYTHON_VERSION-dev python$PYTHON_VERSION-venv

  # Update alternatives to set Python 3.11 as the default Python
  sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python$PYTHON_VERSION 1
  sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 1
  sudo update-alternatives --config python3 <<< "1"  # Выбор установленной версии как основной
  sudo update-alternatives --config python <<< "1"   # Выбор установленной версии как основной

  # Проверка успешности обновления
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

echo "Python installation completed."
