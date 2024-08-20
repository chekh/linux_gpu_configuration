#!/bin/bash

# Load environment variables from the configuration file
set -a
source ./config.env
set +a

# Function to start a service
start_service() {
    local service_name=$1
    echo "Starting $service_name..."
    sudo systemctl start $service_name
    sudo systemctl enable $service_name
}

# Function to stop a service
stop_service() {
    local service_name=$1
    echo "Stopping $service_name..."
    sudo systemctl stop $service_name
    sudo systemctl disable $service_name
}

# Function to restart a service
restart_service() {
    local service_name=$1
    echo "Restarting $service_name..."
    sudo systemctl restart $service_name
}

# Manage NVIDIA persistence daemon if enabled
if [ "$NVIDIA_DRIVER_ENABLE" == "true" ]; then
    restart_service "nvidia-persistenced"
fi

echo "Service management for stage_2 completed."
