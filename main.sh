#!/bin/bash

# Load environment variables from the configuration file
set -a
source ./config.env
set +a

# Install python3-pip
echo "Installing python3-pip..."
sudo apt-get update
sudo apt-get install -y python3-pip

# Upgrade pip
echo "Upgrading pip..."
python3 -m pip install --upgrade pip

# Run individual setup scripts
./install_python.sh
./install_cuda.sh
./install_cudnn.sh
./install_jupyter.sh
./install_samba.sh
./install_ssh.sh
./install_vnc.sh
./install_rdp.sh
./install_git.sh
./install_docker.sh
./install_ray.sh

echo "Setup completed!"
