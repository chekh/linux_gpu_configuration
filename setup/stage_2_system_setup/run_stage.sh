#!/bin/bash

echo "Starting Stage 2 setup..."

# Load environment variables from the configuration file
set -a
source ./config.env
set +a

# Step 1: Run the installation script for Stage 2
echo "Running installation script for Stage 2..."
./install_stage_2.sh

# Step 2: Manage services as configured in config.env
echo "Managing services for Stage 2..."
./manage_services_stage_2.sh

# Step 3: Check the status of the services after installation and management
echo "Checking service statuses..."
./check_service_status.sh

echo "Stage 2 setup completed."
