#!/bin/bash

# Load environment variables from the configuration file
set -a
source ./config.env
set +a

# Install CUDA if specified in the config
if [ "$CUDA_INSTALL" == "true" ]; then
  echo "Installing CUDA $CUDA_VERSION on Ubuntu $TARGET_VERSION..."

  # Download the CUDA keyring package
  wget https://developer.download.nvidia.com/compute/cuda/repos/$DISTRO/$TARGET_ARCH/cuda-keyring_1.1-1_all.deb

  # Install the keyring package
  sudo dpkg -i cuda-keyring_1.1-1_all.deb

  # Update the package list
  sudo apt-get update

  # Install the CUDA toolkit
  sudo apt-get install cuda-toolkit

  sudo apt-get install nvidia-gds

  # Adding CUDA to PATH
  if ! grep -q "/usr/local/cuda-$CUDA_VERSION/bin" ~/.bashrc; then
    echo "export PATH=/usr/local/cuda-12.6/bin${PATH:+:${PATH}}" >> ~/.bashrc
  fi
  if ! grep -q "/usr/local/cuda-$CUDA_VERSION/lib64" ~/.bashrc; then
    echo "export LD_LIBRARY_PATH=/usr/local/cuda-12.6/lib64\
                         ${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}" >> ~/.bashrc
  fi

  # Reload .bashrc
  source ~/.bashrc

  # Verify the installation
  echo "Verifying CUDA installation..."
  nvcc --version

  if [ $? -eq 0 ]; then
    echo "CUDA installation successful!"
  else
    echo "CUDA installation failed. Please check the installation steps."
  fi
fi
