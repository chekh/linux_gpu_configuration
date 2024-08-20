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

# Manage RDP services
if [ "$RDP_ENABLE" == "true" ]; then
    echo "Managing RDP services..."
    restart_service "xrdp"
    restart_service "xrdp-sesman"
else
    echo "RDP is disabled in the configuration."
    stop_service "xrdp"
    stop_service "xrdp-sesman"
fi

# Manage VNC services
if [ "$VNC_ENABLE" == "true" ]; then
    echo "Managing VNC services..."
    restart_service "vncserver@1.service"
else
    echo "VNC is disabled in the configuration."
    stop_service "vncserver@1.service"
fi

echo "Service management completed."
