#!/bin/bash

# Install CUDA if specified in the config
if [ "$CUDA_INSTALL" == "true" ]; then
  echo "Installing CUDA $CUDA_VERSION..."

  # Add NVIDIA package repositories
  sudo apt-get install -y gnupg
  sudo mkdir -p /etc/apt/keyrings
  wget https://developer.download.nvidia.com/compute/cuda/repos/${DISTRIBUTION}${TARGET_VERSION}/${TARGET_ARCH}/cuda-keyring.gpg
  sudo mv cuda-keyring.gpg /etc/apt/keyrings/cuda-archive-keyring.gpg
  echo "deb [signed-by=/etc/apt/keyrings/cuda-archive-keyring.gpg] https://developer.download.nvidia.com/compute/cuda/repos/${DISTRIBUTION}${TARGET_VERSION}/${TARGET_ARCH}/ /" | sudo tee /etc/apt/sources.list.d/cuda.list

  # Update the package lists
  sudo apt-get update

  # Install CUDA
  sudo apt-get install -y cuda-${CUDA_VERSION}
fi
