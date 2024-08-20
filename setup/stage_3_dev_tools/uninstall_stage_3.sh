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

# Uninstall Git
if [ "$GIT_ENABLE" == "true" ]; then
    remove_package "git"
fi

# Uninstall Docker
if [ "$DOCKER_ENABLE" == "true" ]; then
    echo "Uninstalling Docker..."
    sudo apt-get remove --purge -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
    sudo rm -rf /var/lib/docker
    sudo rm -rf /etc/docker
fi

# Uninstall Jupyter Notebook
if [ "$JUPYTER_ENABLE" == "true" ]; then
    echo "Uninstalling Jupyter Notebook..."
    pip3 uninstall -y jupyterlab
fi

# Uninstall Ray
if [ "$RAY_ENABLE" == "true" ]; then
    echo "Uninstalling Ray..."
    pip3 uninstall -y ray
fi

# Clean up unused packages
echo "Cleaning up..."
sudo apt-get autoremove -y
sudo apt-get clean

echo "Uninstallation for stage_3 completed."
