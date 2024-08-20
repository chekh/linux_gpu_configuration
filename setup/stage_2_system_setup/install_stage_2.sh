#!/bin/bash

# Load environment variables from the configuration file
set -a
source ./config.env
set +a

# Function to install NVIDIA drivers
install_nvidia_drivers() {
    echo "Installing NVIDIA drivers..."
    sudo apt-get update
    sudo apt-get install -y nvidia-driver-$NVIDIA_DRIVER_VERSION
}

# Function to install CUDA
install_cuda() {
    echo "Installing CUDA..."
    wget https://developer.download.nvidia.com/compute/cuda/repos/$CUDA_DISTRIBUTION/$CUDA_ARCH/cuda-keyring_1.1-1_all.deb
    sudo dpkg -i cuda-keyring_1.1-1_all.deb
    sudo apt-get update
    sudo apt-get install -y cuda-toolkit-$CUDA_VERSION
}

# Function to install cuDNN
install_cudnn() {
    echo "Installing cuDNN..."
    sudo apt-get install -y libcudnn8 libcudnn8-dev
}

# Function to install Python globally
install_python() {
    echo "Installing Python $PYTHON_VERSION globally..."
    sudo apt-get update
    sudo apt-get install -y wget build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev

    # Download and extract Python source code
    wget https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz
    tar -xf Python-$PYTHON_VERSION.tgz

    # Build and install Python globally
    cd Python-$PYTHON_VERSION
    ./configure --enable-optimizations --prefix=/usr/local
    make -j$(nproc)
    sudo make altinstall

    # Clean up build artifacts and source files
    cd ..
    rm -rf Python-$PYTHON_VERSION Python-$PYTHON_VERSION.tgz

    # Update alternatives to set this version as the default python3 and python
    sudo update-alternatives --install /usr/bin/python python /usr/local/bin/python$PYTHON_VERSION 1
    sudo update-alternatives --install /usr/bin/python3 python3 /usr/local/bin/python$PYTHON_VERSION 1

    # Ensure pip is up-to-date
    sudo /usr/local/bin/python$PYTHON_VERSION -m ensurepip --upgrade
    sudo /usr/local/bin/python$PYTHON_VERSION -m pip install --upgrade pip

    # Verify the installation
    python --version
    python3 --version
}

# Install NVIDIA drivers
if [ "$NVIDIA_DRIVER_ENABLE" == "true" ]; then
    install_nvidia_drivers
fi

# Install CUDA
if [ "$CUDA_ENABLE" == "true" ]; then
    install_cuda

    # Ensure nvcc is available
    if ! command -v nvcc &> /dev/null; then
        echo "nvcc not found. Installing additional CUDA tools..."
        sudo apt-get install -y nvidia-cuda-toolkit
    fi
fi

# Install cuDNN
if [ "$CUDNN_ENABLE" == "true" ]; then
    install_cudnn
fi

# Install Python
if [ "$PYTHON_ENABLE" == "true" ]; then
    install_python
fi

echo "Installation for stage_2 completed."

# Call the service status check script at the end
./check_service_status.sh
