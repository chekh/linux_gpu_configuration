#!/bin/bash

# Install cuDNN if specified in the config
if [ "$CUDNN_INSTALL" == "true" ]; then
  echo "Installing cuDNN $CUDNN_VERSION..."

  # Add NVIDIA cuDNN repositories
  wget https://developer.download.nvidia.com/compute/machine-learning/repos/${DISTRIBUTION}${TARGET_VERSION}/${TARGET_ARCH}/cudnn-keyring.gpg
  sudo mv cudnn-keyring.gpg /etc/apt/keyrings/cudnn-archive-keyring.gpg
  echo "deb [signed-by=/etc/apt/keyrings/cudnn-archive-keyring.gpg] https://developer.download.nvidia.com/compute/machine-learning/repos/${DISTRIBUTION}${TARGET_VERSION}/${TARGET_ARCH}/ /" | sudo tee /etc/apt/sources.list.d/cudnn.list

  # Update the package lists
  sudo apt-get update

  # Install cuDNN
  sudo apt-get install -y libcudnn8=${CUDNN_VERSION}
  sudo apt-get install -y libcudnn8-dev=${CUDNN_VERSION}
fi
