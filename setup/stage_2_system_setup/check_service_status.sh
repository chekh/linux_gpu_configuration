#!/bin/bash

# Load environment variables from the configuration file
set -a
source ./config.env
set +a

# Function to check the status of a service
check_service_status() {
    local service_name=$1
    echo "Checking status of $service_name..."
    sudo systemctl status $service_name --no-pager
}

# Check the status of installed services
echo "Checking the status of services for stage_2..."

# Check NVIDIA persistence daemon status if NVIDIA drivers were installed
if [ "$NVIDIA_DRIVER_ENABLE" == "true" ]; then
    check_service_status "nvidia-persistenced"
fi

# Check CUDA installation by verifying nvcc version
if [ "$CUDA_ENABLE" == "true" ]; then
    if command -v nvcc &> /dev/null; then
        echo "CUDA is installed. nvcc version:"
        nvcc --version
    else
        echo "CUDA installation not found or nvcc is not available."
    fi
fi

# Check Python version if Python was installed
if [ "$PYTHON_ENABLE" == "true" ]; then
    if command -v python &> /dev/null; then
        echo "Python is installed. Python version:"
        python --version
    else
        echo "Python installation not found."
    fi

    if command -v python3 &> /dev/null; then
        echo "Python 3 is installed. Python 3 version:"
        python3 --version
    else
        echo "Python 3 installation not found."
    fi
fi

echo "Service status check for stage_2 completed."
