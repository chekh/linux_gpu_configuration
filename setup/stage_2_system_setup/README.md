# Stage 2 Setup Scripts

This directory contains scripts for setting up, managing, and uninstalling GPU drivers and related packages on your Linux machine, including NVIDIA drivers, CUDA, cuDNN, and Python.

## Table of Contents

- [Overview](#overview)
- [Installation](#installation)
- [Uninstallation](#uninstallation)
- [Service Management](#service-management)
- [Service Status Check](#service-status-check)
- [Configuration](#configuration)

## Overview

These scripts allow you to install, configure, manage, and remove GPU-related components as part of `stage_2`:

- **NVIDIA Drivers:** Install the specified version of the NVIDIA driver.
- **CUDA:** Install the specified version of the CUDA toolkit.
- **cuDNN:** Install the cuDNN library for deep learning.
- **Python:** Install and configure the specified version of Python globally, ensuring it is set as the default version on the system.

## Installation

### 1. Configure the environment

Before running any scripts, ensure that `config.env` is properly configured. For example:

```ini
# Enable/Disable NVIDIA driver installation
NVIDIA_DRIVER_ENABLE=true
NVIDIA_DRIVER_VERSION=525

# Enable/Disable CUDA installation
CUDA_ENABLE=true
CUDA_VERSION=12-6
CUDA_DISTRIBUTION=ubuntu2404
CUDA_ARCH=x86_64

# Enable/Disable cuDNN installation
CUDNN_ENABLE=true

# Python Configuration
PYTHON_ENABLE=true
PYTHON_VERSION=3.11.9
```

### 2. Run the installation scripts

Each component has its own installation script. To install the components, you can run the individual scripts or use the `run_stage.sh` script to run them in sequence.

#### a. Install Python

To install the specified version of Python globally and set it as the default version:

```bash
./install_python.sh
```

#### b. Install NVIDIA drivers, CUDA, and cuDNN

If you wish to install these components as well:

```bash
./install_stage_2.sh
```

This script will install the NVIDIA drivers, CUDA toolkit, and cuDNN library based on the configuration in `config.env`.

### 3. Check service status

After installation, check the status of the services by running:

```bash
./check_service_status.sh
```

This will also verify the installed Python version.

## Uninstallation

To remove the GPU-related components and Python installed in `stage_2`, run:

```bash
./uninstall_stage_2.sh
```

This script will safely remove the components and their configurations.

## Service Management

If necessary, you can manage related services (such as the NVIDIA persistence daemon) using the `manage_services_stage_2.sh` script.

To manage services, run:

```bash
./manage_services_stage_2.sh
```

## Service Status Check

To check the status of the services and verify the installed Python version, run:

```bash
./check_service_status.sh
```

## Configuration

The behavior of the scripts is controlled by the `config.env` file. Modify this file to customize which components are enabled or disabled.

### Example Configuration

```ini
# Enable/Disable NVIDIA driver installation
NVIDIA_DRIVER_ENABLE=true
NVIDIA_DRIVER_VERSION=525

# Enable/Disable CUDA installation
CUDA_ENABLE=true
CUDA_VERSION=12-6
CUDA_DISTRIBUTION=ubuntu2404
CUDA_ARCH=x86_64

# Enable/Disable cuDNN installation
CUDNN_ENABLE=true

# Python Configuration
PYTHON_ENABLE=true
PYTHON_VERSION=3.11.9
```

Ensure this file is configured correctly before running the installation or management scripts.

## Conclusion

These scripts provide a comprehensive solution for managing GPU-related components and Python in `stage_2` of your Linux environment. Adjust the `config.env` file according to your requirements before executing the scripts.