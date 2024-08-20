#!/bin/bash

# Run Stage 1: Remote Access Setup
echo "Starting Stage 1: Remote Access Setup..."
cd stage_1_remote_access
./run_stage.sh
cd ..

# Reboot if required by any of the scripts
./utils/reboot_if_needed.sh

# Run Stage 2: System Setup
echo "Starting Stage 2: System Setup..."
cd stage_2_system_setup
./run_stage.sh
cd ..

# Run Stage 3: Development Tools Setup
echo "Starting Stage 3: Development Tools Setup..."
cd stage_3_dev_tools
./run_stage.sh
cd ..

echo "Setup completed!"
