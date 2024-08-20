### 1. `install_stage_3.sh`

This script installs `git`, `jupyter`, `docker`, and `ray` based on the configuration.

```bash
#!/bin/bash

# Load environment variables from the configuration file
set -a
source ./config.env
set +a

# Function to install packages
install_package() {
    local package_name=$1
    echo "Installing $package_name..."
    sudo apt-get install -y $package_name
}

# Install Git
if [ "$GIT_ENABLE" == "true" ]; then
    install_package "git"
fi

# Install Docker
if [ "$DOCKER_ENABLE" == "true" ]; then
    echo "Installing Docker..."
    sudo apt-get remove -y docker docker-engine docker.io containerd runc
    sudo apt-get update
    sudo apt-get install -y ca-certificates curl gnupg lsb-release
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
    sudo usermod -aG docker $USER
fi

# Install Jupyter Notebook
if [ "$JUPYTER_ENABLE" == "true" ]; then
    echo "Installing Jupyter Notebook..."
    sudo apt-get install -y python3-pip
    pip3 install jupyterlab
fi

# Install Ray
if [ "$RAY_ENABLE" == "true" ]; then
    echo "Installing Ray..."
    pip3 install ray[default]
fi

echo "Installation for stage_3 completed."

# Call the service status check script at the end
./check_service_status.sh
```

### 2. `uninstall_stage_3.sh`

This script uninstalls `git`, `jupyter`, `docker`, and `ray` based on the configuration.

```bash
#!/bin/bash

# Load environment variables from the configuration file
set -a
source ./config.env
set +a

# Function to remove packages
remove_package() {
    local package_name=$1
    echo "Removing $package_name..."
    sudo apt-get remove --purge -y $package_name
}

# Uninstall Git
if [ "$GIT_ENABLE" == "true" ]; then
    remove_package "git"
fi

# Uninstall Docker
if [ "$DOCKER_ENABLE" == "true" ]; then
    echo "Uninstalling Docker..."
    sudo apt-get remove --purge -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
    sudo rm -rf /var/lib/docker
    sudo rm -rf /etc/docker
fi

# Uninstall Jupyter Notebook
if [ "$JUPYTER_ENABLE" == "true" ]; then
    echo "Uninstalling Jupyter Notebook..."
    pip3 uninstall -y jupyterlab
fi

# Uninstall Ray
if [ "$RAY_ENABLE" == "true" ]; then
    echo "Uninstalling Ray..."
    pip3 uninstall -y ray
fi

# Clean up unused packages
echo "Cleaning up..."
sudo apt-get autoremove -y
sudo apt-get clean

echo "Uninstallation for stage_3 completed."
```

### 3. `manage_services_stage_3.sh`

This script manages (starts, stops, or restarts) the services associated with `stage_3`.

```bash
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
```

### 4. `check_service_status.sh`

This script checks the status of services associated with `stage_3`.

```bash
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
```

### 5. Example `config.env` for `stage_3`

Below is an example configuration file for controlling the installation and management of `git`, `jupyter`, `docker`, and `ray`.

```ini
# Configuration for stage_3

# Enable/Disable services
GIT_ENABLE=true
DOCKER_ENABLE=true
JUPYTER_ENABLE=true
RAY_ENABLE=true
```

### README.md for `stage_3`

Here's a `README.md` file that provides instructions on how to use the scripts in `stage_3`:

```markdown
# Stage 3 Setup Scripts

This directory contains scripts for setting up, managing, and uninstalling services related to `stage_3` on your Linux machine. The services include Git, Jupyter, Docker, and Ray.

## Table of Contents

- [Overview](#overview)
- [Installation](#installation)
- [Uninstallation](#uninstallation)
- [Service Management](#service-management)
- [Service Status Check](#service-status-check)
- [Configuration](#configuration)

## Overview

These scripts allow you to install, configure, manage, and remove the following services as part of `stage_3`:

- **Git:** Version control system.
- **Docker:** Containerization platform.
- **Jupyter:** Jupyter Notebook for interactive computing.
- **Ray:** A distributed computing framework.

## Installation

### 1. Configure the environment

Before running any scripts, ensure that `config.env` is properly configured. For example:

```ini
# Enable/Disable services
GIT_ENABLE=true
DOCKER_ENABLE=true
JUPYTER_ENABLE=true
RAY_ENABLE=true
```

### 2. Run the installation script

To install the services for `stage_3`, run:

```bash
./install_stage_3.sh
```

The script will install the services based on the configuration in `config.env`.

### 3. Check service status

After installation, check the status of the services by running:

```bash
./check_service_status.sh
```

## Uninstallation

To remove the services installed in `stage_3`, run:

```bash
./uninstall_stage_3.sh
```

This script will safely remove the services and their configurations.

## Service Management

You can start, stop, or restart the services using the `manage_services_stage_3.sh` script. This script will manage the services based on the settings in `config.env`.

To manage services, run:

```bash
./manage_services_stage_3.sh
```

## Service Status Check

To check the status of the services, run:

```bash
./check_service_status.sh
```

## Configuration

The behavior of the scripts is controlled by the `config.env` file. Modify this file to customize which services are enabled or disabled.

### Example Configuration

```ini
# Enable/Disable services
GIT_ENABLE=true
DOCKER_ENABLE=true
JUPYTER_ENABLE=true
RAY_ENABLE=true
```

Ensure this file is configured correctly before running the installation or management scripts.

## Conclusion

These scripts provide a comprehensive solution for managing services in `stage_3` of your Linux environment. Adjust the `config.env` file according to your requirements before executing the scripts.
```

---
