#!/bin/bash

# Function to run a stage
run_stage() {
    local stage_dir=$1
    local stage_name=$2

    echo "Starting ${stage_name}..."

    if cd "$stage_dir"; then
        ./run_stage.sh
        if [ $? -ne 0 ]; then
            echo "Error: ${stage_name} failed. Exiting."
            exit 1
        fi
        cd ..
    else
        echo "Error: Could not change to directory ${stage_dir}. Exiting."
        exit 1
    fi
}

# Run Stage 1: Remote Access Setup
run_stage "stage_1_remote_access" "Stage 1: Remote Access Setup"

# Reboot if required by any of the scripts
echo "Checking if a reboot is needed..."
./utils/reboot_if_needed.sh
if [ $? -eq 1 ]; then
    echo "Rebooting system as required..."
    sudo reboot
    exit 0
fi

# Run Stage 2: System Setup
run_stage "stage_2_system_setup" "Stage 2: System Setup"

# Run Stage 3: Development Tools Setup
run_stage "stage_3_dev_tools" "Stage 3: Development Tools Setup"

echo "Setup completed successfully!"
