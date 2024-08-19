# System Setup Automation Script

This repository contains a bash script for automating the setup of a Linux-based system with various tools and services, including Python, Docker, Ray, CUDA, cuDNN, Jupyter, Samba, SSH, VNC, RDP, and more. The configuration is controlled via a `.env` file.

## Prerequisites

- Ubuntu 20.04 or later
- Basic knowledge of Linux command line
- sudo privileges

## Installation and Setup

### 1. Clone the repository:

```bash
git clone https://github.com/your-repo-name/system-setup.git
cd system-setup
```

### 2. Update the configuration file:

Edit the `config.env` file to match your system's requirements. Set `true` or `false` to enable or disable certain installations. For example:

```ini
PYTHON_INSTALL=true
PYTHON_VERSION="3.11.9"
DOCKER_INSTALL=true
RAY_INSTALL=true
```

### 3. Run the setup script:

```bash
chmod +x setup.sh
./setup.sh
```

The script will automatically install and configure the specified software and services according to the settings in the `config.env` file.

## Features

- **Python Setup**: Installs a specific version of Python globally.
- **CUDA and cuDNN**: Installs NVIDIA CUDA Toolkit and cuDNN libraries.
- **Jupyter Notebook**: Installs and configures Jupyter Notebook.
- **Samba**: Sets up file sharing using Samba.
- **SSH and SFTP**: Installs and configures SSH and optional SFTP.
- **VNC and RDP**: Sets up remote desktop access via VNC and RDP.
- **Docker**: Installs Docker and Docker Compose.
- **Ray**: Installs Ray for parallel and distributed computing.
- **Firewall**: Configures UFW to allow specified ports.

## Customization

You can customize the installation by editing the `config.env` file. Here is a brief overview of the options:

- `PYTHON_INSTALL`: Set to `true` to install Python globally.
- `CUDA_INSTALL`: Set to `true` to install CUDA.
- `DOCKER_INSTALL`: Set to `true` to install Docker.
- `RAY_INSTALL`: Set to `true` to install Ray.
- And many more...

Refer to the comments in the `config.env` file for detailed explanations of each option.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contributing

Feel free to submit issues and pull requests. Contributions are welcome!