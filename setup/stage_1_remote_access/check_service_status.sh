#!/bin/bash

# Function to check the status of a service
check_service_status() {
    local service_name=$1
    echo "Checking status of $service_name..."
    sudo systemctl status $service_name --no-pager
}

echo "Checking the status of key services..."

# Check status of RDP services
check_service_status "xrdp"
check_service_status "xrdp-sesman"

# Check status of VNC service, if VNC is enabled
if [ "$VNC_ENABLE" == "true" ]; then
    check_service_status "vncserver@1.service"
fi

echo "Service status check completed."
