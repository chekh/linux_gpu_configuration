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

echo "Checking the status of services for stage_3..."

# Check Docker service status
check_service_status "docker"

# Note: Jupyter and Ray typically do not run as systemd services, so they are not checked here

echo "Service status check for stage_3 completed."
