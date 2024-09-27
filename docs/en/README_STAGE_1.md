# Remote Access Setup Scripts

This section of the repository contains scripts designed to set up and manage remote access to a Linux machine using RDP (via `xrdp`) and VNC. The scripts allow you to install, configure, and manage these services, as well as clean up and remove them if necessary. 

## Table of Contents

- [Overview](#overview)
- [Installation](#installation)
- [Uninstallation](#uninstallation)
- [Service Management](#service-management)
- [Service Status Check](#service-status-check)
- [Configuration](#configuration)

## Overview

The scripts in this directory are intended for setting up RDP and VNC services on a Linux machine. They support the following features:

- **RDP Setup:** Install and configure `xrdp` with a specified desktop environment.
- **VNC Setup:** Install and configure `tightvncserver` with a specified desktop environment.
- **Service Management:** Enable, disable, start, stop, and restart services based on the configuration.
- **Environment Cleanup:** Safely remove installed services and associated configurations without disrupting the default desktop environment.

## Installation

### 1. Configure the environment

Before running any installation scripts, ensure you have set up the configuration file `config.env`. This file defines which services to install and which desktop environment to use. Below is an example configuration:

```ini
# config.env

# VNC Configuration
VNC_ENABLE=false
VNC_PORT=5901
VNC_PASSWORD="your_secure_password"

# RDP Configuration
RDP_ENABLE=true
RDP_PORT=3389

# Window Manager Configuration
WINDOW_MANAGER="xfce"  # Supported: xfce, gnome, kde, cinnamon, mate, mint

# Clear previous window manager before installing a new one
CLEAR_PREVIOUS_WM=true
```

### 2. Run the installation scripts

To install and configure RDP:

```bash
./install_rdp.sh
```

To install and configure VNC:

```bash
./install_vnc.sh
```

Both scripts will automatically configure the services based on the `config.env` settings. They also prevent the removal of the default desktop environment when `CLEAR_PREVIOUS_WM` is set to `true`.

### 3. Check service status

After installation, you can check the status of the services using:

```bash
./check_service_status.sh
```

This script will display the status of `xrdp`, `xrdp-sesman`, and `vncserver` (if enabled).

## Uninstallation

To remove all installed components and clean up configurations, run the uninstallation script:

```bash
./uninstall_stage_1.sh
```

This script will safely remove all installed services and their configurations, ensuring that the default desktop environment remains intact.

## Service Management

You can manage the RDP and VNC services using the `manage_services.sh` script. This script allows you to start, stop, restart, or disable services based on the current configuration in `config.env`.

To manage services, run:

```bash
./manage_services.sh
```

The script will automatically handle the services according to the `RDP_ENABLE` and `VNC_ENABLE` settings in `config.env`.

## Service Status Check

To check the status of all key services, run the following script:

```bash
./check_service_status.sh
```

This will output the current status of `xrdp`, `xrdp-sesman`, and `vncserver` (if enabled).

## Configuration

The behavior of the scripts is controlled by the `config.env` file. Modify this file to customize which services are enabled, which desktop environment is used, and whether previous desktop environments should be cleared.

### Example Configuration

```ini
# Enable RDP and disable VNC
RDP_ENABLE=true
VNC_ENABLE=false

# Use XFCE as the desktop environment
WINDOW_MANAGER="xfce"

# Clear previous window manager settings
CLEAR_PREVIOUS_WM=true
```

Modify this file as needed before running the installation or management scripts.

## Conclusion

These scripts provide a comprehensive solution for managing remote access to your Linux machine via RDP and VNC. Ensure you have configured `config.env` according to your requirements before executing the scripts.

For any issues or further customization, please refer to the script comments or seek assistance from the community.

---