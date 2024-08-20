#!/bin/bash

# Load environment variables from the configuration file
set -a
source ./config.env
set +a

# Function to install packages
install_package() {
    local package_name=$1
    echo "Installing $package_name..."
    sudo apt-get install -y $package_name
}

# Install Git
if [ "$GIT_ENABLE" == "true" ]; then
    install_package "git"
fi

# Install Docker
if [ "$DOCKER_ENABLE" == "true" ]; then
    echo "Installing Docker..."
    sudo apt-get remove -y docker docker-engine docker.io containerd runc
    sudo apt-get update
    sudo apt-get install -y ca-certificates curl gnupg lsb-release
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
    sudo usermod -aG docker $USER
fi

# Install Jupyter Notebook
if [ "$JUPYTER_ENABLE" == "true" ]; then
    echo "Installing Jupyter Notebook..."
    sudo apt-get install -y python3-pip
    pip3 install jupyterlab
fi

# Install Ray
if [ "$RAY_ENABLE" == "true" ]; then
    echo "Installing Ray..."
    pip3 install ray[default]
fi

echo "Installation for stage_3 completed."

# Call the service status check script at the end
./check_service_status.sh
