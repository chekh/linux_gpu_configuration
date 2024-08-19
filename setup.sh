#!/bin/bash

# Load environment variables from the configuration file
set -a
source config.env
set +a

# Upgrade pip to the latest version
echo "Upgrading pip..."
python3 -m pip install --upgrade pip

# Install global Python packages: virtualenv, wheel, setuptools, pipenv, twine
echo "Installing global Python packages: virtualenv, wheel, setuptools, pipenv, twine..."
pip3 install virtualenv wheel setuptools pipenv twine

# Update NVIDIA drivers
echo "Updating NVIDIA drivers..."
sudo apt-get install -y nvidia-driver-525

# Install CUDA if specified in the config
if [ "$CUDA_INSTALL" == "true" ]; then
  echo "Installing CUDA..."

  CUDA_URL="https://developer.download.nvidia.com/compute/cuda/repos/${DISTRIBUTION}${TARGET_VERSION}/${TARGET_ARCH}/cuda-${DISTRIBUTION}${TARGET_VERSION}_${TARGET_TYPE}_amd64.deb"

  echo "Downloading CUDA from: $CUDA_URL"

  wget $CUDA_URL -O cuda-repo.deb
  sudo dpkg -i cuda-repo.deb
  sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/${DISTRIBUTION}${TARGET_VERSION}/${TARGET_ARCH}/3bf863cc.pub
  sudo apt-get update
  sudo apt-get install -y cuda
fi

# Install cuDNN if specified in the config
if [ "$CUDNN_INSTALL" == "true" ]; then
  echo "Installing cuDNN..."

  CUDNN_URL="https://developer.download.nvidia.com/compute/machine-learning/repos/${DISTRIBUTION}${TARGET_VERSION}/${TARGET_ARCH}/libcudnn8_${TARGET_TYPE}_amd64.deb"

  echo "Downloading cuDNN from: $CUDNN_URL"

  wget $CUDNN_URL -O cudnn-repo.deb
  sudo dpkg -i cudnn-repo.deb
  sudo apt-get update
  sudo apt-get install -y libcudnn8
  sudo apt-get install -y libcudnn8-dev
fi

# Check and install Python if a specific version is specified in the config
if [ "$PYTHON_INSTALL" == "true" ]; then
  echo "Checking Python version..."
  INSTALLED_PYTHON_VERSION=$(python3 --version | awk '{print $2}')
  if [ "$INSTALLED_PYTHON_VERSION" != "$PYTHON_VERSION" ]; then
    echo "Installing Python version $PYTHON_VERSION..."
    sudo apt-get install -y python$PYTHON_VERSION python$PYTHON_VERSION-dev python$PYTHON_VERSION-venv
    sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python$PYTHON_VERSION 1
  else
    echo "Python version $PYTHON_VERSION is already installed."
  fi
  echo "Upgrading pip..."
  python3 -m pip install --upgrade pip
fi

# Install Jupyter Notebook if specified in the config
if [ "$JUPYTER_INSTALL" == "true" ]; then
  echo "Installing Jupyter Notebook..."
  pip3 install jupyter
  jupyter notebook --no-browser --port=$JUPYTER_PORT &
fi

# Set up Samba file sharing if specified in the config
if [ "$SAMBA_ENABLE" == "true" ]; then
  echo "Setting up Samba..."
  sudo apt-get install -y samba
  sudo tee -a /etc/samba/smb.conf > /dev/null <<EOL

[$SAMBA_SHARE_NAME]
   path = $SAMBA_DIRECTORY
   writable = $SAMBA_WRITABLE
   guest ok = $SAMBA_GUEST_OK
   force user = $(whoami)

EOL
  sudo systemctl restart smbd
fi

# Set up SSH and SFTP if specified in the config
if [ "$SSH_ENABLE" == "true" ]; then
  echo "Setting up SSH..."
  sudo apt-get install -y openssh-server
  sudo sed -i "s/#Port 22/Port $SSH_PORT/g" /etc/ssh/sshd_config
  sudo systemctl enable ssh
  sudo systemctl start ssh

  # Configure SFTP if enabled in the config
  if [ "$SFTP_ENABLE" == "true" ]; then
    echo "Configuring SFTP..."
    # Additional SFTP setup can be done here if needed
  fi
fi

# Set up VNC if specified in the config
if [ "$VNC_ENABLE" == "true" ]; then
  echo "Setting up VNC..."
  sudo apt-get install -y xfce4 xfce4-goodies tightvncserver
  vncserver
  # Stop the server to modify the configuration
  vncserver -kill :1
  mv ~/.vnc/xstartup ~/.vnc/xstartup.bak
  echo "#!/bin/bash
xrdb $HOME/.Xresources
startxfce4 &" > ~/.vnc/xstartup
  chmod +x ~/.vnc/xstartup
  vncserver
  # Open the port for VNC if firewall is enabled
  if [ "$FIREWALL_ENABLE" == "true" ]; then
    sudo ufw allow $VNC_PORT/tcp
  fi
fi

# Set up RDP if specified in the config
if [ "$RDP_ENABLE" == "true" ]; then
  echo "Setting up RDP..."
  sudo apt-get install -y xfce4 xrdp
  sudo systemctl enable xrdp
  sudo systemctl start xrdp

  # Configure xrdp to use XFCE
  echo "Configuring xrdp to use XFCE..."
  sudo bash -c 'echo "xfce4-session" > /etc/skel/.xsession'
  sudo bash -c 'echo "xfce4-session" > ~/.xsession'

  # Open the port for RDP if firewall is enabled
  if [ "$FIREWALL_ENABLE" == "true" ]; then
    sudo ufw allow $RDP_PORT/tcp
  fi
fi

# Configure the firewall if enabled in the config
if [ "$FIREWALL_ENABLE" == "true" ]; then
  echo "Setting up firewall..."
  sudo ufw enable
  sudo ufw allow $SSH_PORT/tcp
  sudo ufw allow $JUPYTER_PORT/tcp
  if [ "$VNC_ENABLE" == "true" ]; then
    sudo ufw allow $VNC_PORT/tcp
  fi
  if [ "$RDP_ENABLE" == "true" ]; then
    sudo ufw allow $RDP_PORT/tcp
  fi
fi

# Check and install or update Git if specified in the config
if [ "$GIT_INSTALL" == "true" ]; then
  echo "Checking Git installation..."
  INSTALLED_GIT_VERSION=$(git --version | awk '{print $3}')
  if [ "$GIT_VERSION" == "latest" ]; then
    echo "Installing or upgrading Git to the latest version..."
    sudo apt-get install -y git
  elif [ "$INSTALLED_GIT_VERSION" != "$GIT_VERSION" ]; then
    echo "Installing Git version $GIT_VERSION..."
    sudo add-apt-repository ppa:git-core/ppa -y
    sudo apt-get update
    sudo apt-get install -y git=$GIT_VERSION
  else
    echo "Git version $GIT_VERSION is already installed."
  fi
fi

# Install Docker if specified in the config
if [ "$DOCKER_INSTALL" == "true" ]; then
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
  echo "Docker installation completed."
fi

# Install Ray if specified in the config
if [ "$RAY_INSTALL" == "true" ]; then
  echo "Installing Ray..."
  pip3 install ray
fi

echo "Setup completed!"
