# Linux GPU Configuration Project

This project automates the setup and configuration of a Linux machine for GPU-intensive tasks, including remote access, GPU drivers, and software installations for development tools.

## Table of Contents

- [Overview](#overview)
- [Project Structure](#project-structure)
- [Configuration](#configuration)
- [Stages Overview](#stages-overview)
  - [Stage 1: Remote Access Configuration](#stage-1-remote-access-configuration)
  - [Stage 2: System Setup](#stage-2-system-setup)
  - [Stage 3: Development Tools Setup](#stage-3-development-tools-setup)
- [How to Use](#how-to-use)
  - [Running a Specific Stage](#running-a-specific-stage)
  - [Checking Service Status](#checking-service-status)
- [Uninstallation](#uninstallation)
- [Service Management](#service-management)
- [Reboot Management](#reboot-management)
- [Conclusion](#conclusion)

## Overview

This project is designed to automate the configuration of various system components essential for GPU-based computing on a Linux machine. The project is organized into three main stages, each addressing a specific aspect of system configuration. There is also a utilities section for handling reboots and other maintenance tasks.

## Project Structure

```
/setup/
│
├── stage_1_remote_access/
│   ├── check_service_status.sh
│   ├── clear_windows_manager.sh
│   ├── config.env
│   ├── install_firewall.sh
│   ├── install_rdp.sh
│   ├── install_samba.sh
│   ├── install_ssh.sh
│   ├── install_vnc.sh
│   ├── manage_services.sh
│   ├── README.md
│   ├── run_stage.sh
│   ├── setup_vnc_password.sh
│   ├── setup_vnc_service.sh
│   ├── uninstall_stage_1.sh
│
├── stage_2_system_setup/
│   ├── check_service_status.sh
│   ├── config.env
│   ├── install_cuda.sh
│   ├── install_cudnn.sh
│   ├── install_python.sh
│   ├── install_stage_2.sh
│   ├── manage_services_stage_2.sh
│   ├── README.md
│   ├── run_stage.sh
│   ├── uninstall_stage_2.sh
│
├── stage_3_dev_tools/
│   ├── check_service_status.sh
│   ├── config.env
│   ├── install_docker.sh
│   ├── install_git.sh
│   ├── install_jupyter.sh
│   ├── install_ray.sh
│   ├── install_stage_3.sh
│   ├── manage_services_stage_3.sh
│   ├── README.md
│   ├── run_stage.sh
│   ├── uninstall_stage_3.sh
│
└── utils/
    ├── reboot_if_needed.sh
    └── main.sh
```

## Configuration

Each stage has a `config.env` file that controls the behavior of the scripts. Make sure to configure these files according to your system requirements before running the scripts.

### Example Configuration for `config.env`

```ini
# Stage 1: Remote Access Configuration
RDP_ENABLE=true
VNC_ENABLE=false
WINDOW_MANAGER="xfce"

# Stage 2: System Setup
NVIDIA_DRIVER_ENABLE=true
NVIDIA_DRIVER_VERSION=525
CUDA_ENABLE=true
CUDA_VERSION=12-6
CUDA_DISTRIBUTION=ubuntu2404
CUDA_ARCH=x86_64
CUDNN_ENABLE=true
PYTHON_ENABLE=true
PYTHON_VERSION=3.11.9

# Stage 3: Development Tools Setup
GIT_ENABLE=true
DOCKER_ENABLE=true
JUPYTER_ENABLE=true
JUPYTER_PORT=8888
RAY_ENABLE=true
```

## Stages Overview

### Stage 1: Remote Access Configuration

This stage sets up remote access to the Linux machine, including RDP and VNC services. It allows you to configure different desktop environments and manage remote access services.

- **Key Features:**
  - Install and configure RDP (`xrdp`) with various desktop environments.
  - Install and configure VNC (`tightvncserver`).
  - Set up a firewall for secure access.
  - Manage remote access services and check their status.

[Readme](./README_STAGE_1.md)

### Stage 2: System Setup

This stage focuses on setting up GPU drivers, CUDA, cuDNN, and Python. It ensures that the machine is ready for GPU-accelerated tasks.

- **Key Features:**
  - Install NVIDIA GPU drivers.
  - Install CUDA toolkit and ensure `nvcc` is available.
  - Install cuDNN library for deep learning.
  - Install a specified version of Python globally and set it as the default interpreter.

[Readme](./README_STAGE_2.md)


### Stage 3: Development Tools Setup

This stage sets up various development tools and environments necessary for machine learning and data science workflows, including Git, Docker, Jupyter, and Ray.

- **Key Features:**
  - Install and configure Git for version control.
  - Install Docker and configure it for containerized workflows.
  - Install Jupyter Notebook/Lab and configure it to run on a specific port.
  - Install Ray for distributed computing.

[Readme](./README_STAGE_3.md)


## How to Use

### Running a Specific Stage

Each stage has a `run_stage.sh` script that executes the installation and configuration steps for that stage.

1. **Make the Script Executable:**

   ```bash
   chmod +x run_stage.sh
   ```

2. **Run the Script:**

   ```bash
   ./run_stage.sh
   ```

This will execute all the necessary steps to set up the components for that stage based on the `config.env` configuration.

### Checking Service Status

After running the installation scripts, you can check the status of installed services by running the `check_service_status.sh` script in each stage's directory:

```bash
./check_service_status.sh
```

This script provides feedback on the status of key services and verifies the installed versions of critical components like Python and CUDA.

## Uninstallation

To remove the installed components, each stage provides an `uninstall_stage.sh` script. Running this script will safely remove the components installed during that stage.

```bash
./uninstall_stage.sh
```

## Service Management

Service management scripts allow you to start, stop, and restart services related to each stage. These scripts ensure that your system's services are running as expected after configuration.

- **Manage services for Stage 1:**

  ```bash
  ./manage_services.sh
  ```

- **Manage services for Stage 2:**

  ```bash
  ./manage_services_stage_2.sh
  ```

- **Manage services for Stage 3:**

  ```bash
  ./manage_services_stage_3.sh
  ```

## Reboot Management

The `utils/` folder contains a script for managing reboots if needed.

- **Reboot the system if needed:**

  ```bash
  ./utils/reboot_if_needed.sh
  ```

## Conclusion

This project provides a structured and automated approach to setting up a Linux machine for GPU-intensive tasks. By breaking down the configuration into stages, it offers flexibility and modularity, allowing you to configure only the components you need. Ensure that you configure each `config.env` file according to your requirements before running the scripts.
