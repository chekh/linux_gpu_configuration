#!/bin/bash

# Check and install or update Git if specified in the config
if [ "$GIT_INSTALL" == "true" ]; then
  echo "Checking Git installation..."
  INSTALLED_GIT_VERSION=$(git --version | awk '{print $3}')
  if [ "$GIT_VERSION" == "latest" ]; then
    echo "Installing or upgrading Git to the latest version..."
    sudo apt-get install -y git
  elif [ "$INSTALLED_GIT_VERSION" != "$GIT_VERSION" ]; then
    echo "Installing Git version $GIT_VERSION..."
    sudo add-apt-repository ppa:git-core/ppa -y
    sudo apt-get update
    sudo apt-get install -y git=$GIT_VERSION
  else
    echo "Git version $GIT_VERSION is already installed."
  fi
fi
