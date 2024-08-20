#!/bin/bash

echo "Starting Stage 3 setup..."

# Load environment variables from the configuration file
set -a
source ./config.env
set +a

# Run the installation script
echo "Running installation script for Stage 3..."
./install_stage_3.sh

# Manage services as configured in config.env
echo "Managing services for Stage 3..."
./manage_services_stage_3.sh

# Check the status of the services after installation and management
echo "Checking service statuses..."
./check_service_status.sh

echo "Stage 3 setup completed."
