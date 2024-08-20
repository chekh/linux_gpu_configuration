#!/bin/bash

# Load environment variables from the configuration file
set -a
source ./config.env
set +a

# Install cuDNN if specified in the config
if [ "$CUDNN_INSTALL" == "true" ]; then
  echo "Installing cuDNN on Ubuntu $TARGET_VERSION..."

  # Download the CUDA keyring package
  wget https://developer.download.nvidia.com/compute/cuda/repos/$DISTRO/$TARGET_ARCH/cuda-keyring_1.1-1_all.deb

  # Install the keyring package
  sudo dpkg -i cuda-keyring_1.1-1_all.deb

  # Update the package list
  sudo apt-get update

  # Install cuDNN
  sudo apt-get -y install cudnn

  # Verify the installation
  echo "Verifying cuDNN installation..."
  dpkg -l | grep cudnn
fi
