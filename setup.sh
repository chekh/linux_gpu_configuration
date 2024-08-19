#!/bin/bash

# Загружаем переменные из конфигурационного файла
set -a
source config.env
set +a

# Обновление pip
echo "Upgrading pip..."
python3 -m pip install --upgrade pip

# Установка глобальных пакетов
echo "Installing global Python packages: virtualenv, wheel, setuptools, pipenv, twine..."
pip3 install virtualenv wheel setuptools pipenv twine

# Обновление драйверов NVIDIA
echo "Updating NVIDIA drivers..."
sudo apt-get install -y nvidia-driver-525

# Установка CUDA
if [ "$CUDA_INSTALL" == "true" ]; then
  echo "Installing CUDA version $CUDA_VERSION..."
  wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-repo-ubuntu2204_${CUDA_VERSION}.2-1_amd64.deb
  sudo dpkg -i cuda-repo-ubuntu2204_${CUDA_VERSION}.2-1_amd64.deb
  sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/3bf863cc.pub
  sudo apt-get update
  sudo apt-get install -y cuda
fi

# Установка cuDNN
if [ "$CUDNN_INSTALL" == "true" ]; then
  echo "Installing cuDNN version $CUDNN_VERSION..."
  CUDNN_URL="https://developer.nvidia.com/rdp/cudnn-archive"
  wget ${CUDNN_URL}/v${CUDA_VERSION}/cudnn-linux-x86_64-${CUDNN_VERSION}.tgz
  tar -xzvf cudnn-linux-x86_64-${CUDNN_VERSION}.tgz
  sudo cp cuda/include/cudnn*.h /usr/local/cuda/include
  sudo cp -P cuda/lib64/libcudnn* /usr/local/cuda/lib64/
  sudo chmod a+r /usr/local/cuda/include/cudnn*.h /usr/local/cuda/lib64/libcudnn*
fi

# Проверка и установка Python
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

# Установка Jupyter Notebook
if [ "$JUPYTER_INSTALL" == "true" ]; then
  echo "Installing Jupyter Notebook..."
  pip3 install jupyter
  jupyter notebook --no-browser --port=$JUPYTER_PORT &
fi

# Настройка Samba
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

# Настройка SSH и SFTP
if [ "$SSH_ENABLE" == "true" ]; then
  echo "Setting up SSH..."
  sudo apt-get install -y openssh-server
  sudo sed -i "s/#Port 22/Port $SSH_PORT/g" /etc/ssh/sshd_config
  sudo systemctl enable ssh
  sudo systemctl start ssh

  if [ "$SFTP_ENABLE" == "true" ]; then
    echo "Configuring SFTP..."
    # Настройка SFTP в SSH, если требуется
    # Дополнительные настройки можно добавить здесь
  fi
fi

# Настройка VNC
if [ "$VNC_ENABLE" == "true" ]; then
  echo "Setting up VNC..."
  sudo apt-get install -y xfce4 xfce4-goodies tightvncserver
  vncserver
  # Остановите сервер, чтобы изменить конфигурацию
  vncserver -kill :1
  mv ~/.vnc/xstartup ~/.vnc/xstartup.bak
  echo "#!/bin/bash
xrdb $HOME/.Xresources
startxfce4 &" > ~/.vnc/xstartup
  chmod +x ~/.vnc/xstartup
  vncserver
  # Открываем порт для VNC
  if [ "$FIREWALL_ENABLE" == "true" ]; then
    sudo ufw allow $VNC_PORT/tcp
  fi
fi

# Настройка RDP
if [ "$RDP_ENABLE" == "true" ]; then
  echo "Setting up RDP..."
  sudo apt-get install -y xrdp
  sudo systemctl enable xrdp
  sudo systemctl start xrdp
  # Открываем порт для RDP
  if [ "$FIREWALL_ENABLE" == "true" ]; then
    sudo ufw allow $RDP_PORT/tcp
  fi
fi

# Настройка firewall
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

# Проверка и установка или обновление Git
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

# Установка Docker
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

# Установка Ray
if [ "$RAY_INSTALL" == "true" ]; then
  echo "Installing Ray..."
  pip3 install ray
fi

echo "Setup completed!"
