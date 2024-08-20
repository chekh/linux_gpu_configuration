#!/bin/bash

# Load environment variables from the configuration file
set -a
source ./config.env
set +a

# Function to install Python globally
install_python() {
    echo "Installing Python $PYTHON_VERSION globally..."
    sudo apt-get update

    sudo apt-get install -y \
        wget \
        build-essential \
        zlib1g-dev \
        libncurses5-dev \
        libgdbm-dev \
        libnss3-dev \
        libssl-dev \
        libreadline-dev \
        libffi-dev \
        libbz2-dev \
        liblzma-dev \
        libsqlite3-dev \
        libzlib-dev \
        libgdbm-compat-dev

    # Download and extract Python source code
    wget https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz
    tar -xf Python-$PYTHON_VERSION.tgz

    # Build and install Python globally
    cd Python-$PYTHON_VERSION
    ./configure --enable-optimizations --enable-shared --with-lzma --with-bz2 --with-zlib --prefix=/usr/local
    make -j $(nproc)
    sudo make altinstall

    # Clean up build artifacts and source files
    cd ..
    sudo rm -rf .*
    sudo rm Python-$PYTHON_VERSION.tgz
    sudo rm -rf Python-$PYTHON_VERSION

    # Update alternatives to set this version as the default python3 and python
    sudo update-alternatives --install /usr/bin/python python /usr/local/bin/python${PYTHON_VERSION%.*} 1
    sudo update-alternatives --install /usr/bin/python3 python3 /usr/local/bin/python${PYTHON_VERSION%.*} 1

    # Explicitly set the newly installed Python version as the default
    sudo update-alternatives --set python /usr/local/bin/python${PYTHON_VERSION%.*}
    sudo update-alternatives --set python3 /usr/local/bin/python${PYTHON_VERSION%.*}

    # Ensure pip is up-to-date
    sudo /usr/local/bin/python${PYTHON_VERSION%.*} -m ensurepip --upgrade
    sudo /usr/local/bin/python${PYTHON_VERSION%.*} -m pip install --upgrade pip

    # Verify the installation
    python --version
    python3 --version
}

# Check if Python installation is enabled in the config
if [ "$PYTHON_ENABLE" == "true" ]; then
    install_python
else
    echo "Python installation is disabled in the configuration."
fi
