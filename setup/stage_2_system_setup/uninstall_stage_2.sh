#!/bin/bash

# Load environment variables from the configuration file
set -a
source ./config.env
set +a

# Function to remove packages
remove_package() {
    local package_name=$1
    echo "Removing $package_name..."
    sudo apt-get remove --purge -y $package_name
}

# Uninstall NVIDIA drivers
if [ "$NVIDIA_DRIVER_ENABLE" == "true" ]; then
    remove_package "nvidia-driver-$NVIDIA_DRIVER_VERSION"
fi

# Uninstall CUDA
if [ "$CUDA_ENABLE" == "true" ]; then
    remove_package "cuda-toolkit-$CUDA_VERSION"
    sudo rm /etc/apt/sources.list.d/cuda.list
    sudo rm /etc/apt/keyrings/cuda-keyring_1.1-1_all.deb
fi

# Uninstall cuDNN
if [ "$CUDNN_ENABLE" == "true" ]; then
    remove_package "libcudnn8 libcudnn8-dev"
fi

# Uninstall Python
if [ "$PYTHON_ENABLE" == "true" ]; then
    echo "Uninstalling Python $PYTHON_VERSION..."
    sudo rm /usr/local/bin/python$PYTHON_VERSION
    sudo update-alternatives --remove python /usr/local/bin/python$PYTHON_VERSION
    sudo update-alternatives --remove python3 /usr/local/bin/python$PYTHON_VERSION
fi

# Clean up unused packages
echo "Cleaning up..."
sudo apt-get autoremove -y
sudo apt-get clean

echo "Uninstallation for stage_2 completed."
