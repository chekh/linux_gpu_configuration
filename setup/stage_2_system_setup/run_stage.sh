#!/bin/bash

# Load environment variables from the local configuration file
set -a
source ./config.env
set +a

# Run all scripts in this stage
./install_python.sh
./install_cuda.sh
./install_cudnn.sh
