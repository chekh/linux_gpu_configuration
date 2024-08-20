#!/bin/bash

# Load environment variables from the local configuration file
set -a
source ./config.env
set +a

# Run all scripts in this stage
./install_git.sh
./install_jupyter.sh
./install_docker.sh
./install_ray.sh
