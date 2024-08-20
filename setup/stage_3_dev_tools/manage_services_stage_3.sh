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

# Manage Docker service
if [ "$DOCKER_ENABLE" == "true" ]; then
    restart_service "docker"
else
    stop_service "docker"
fi

# Manage Jupyter Notebook service (if you configure it as a service)
if [ "$JUPYTER_ENABLE" == "true" ]; then
    echo "Jupyter Notebook should be started manually or configured as a service if needed."
fi

# Ray does not have a service to manage by default, it's typically used within your Python scripts

echo "Service management for stage_3 completed."
