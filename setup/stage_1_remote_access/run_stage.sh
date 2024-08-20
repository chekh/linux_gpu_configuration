#!/bin/bash

# Load environment variables from the local configuration file
set -a
source ./config.env
set +a

# Run all scripts in this stage
./install_ssh.sh
./install_vnc.sh
./install_rdp.sh
./install_samba.sh
./install_firewall.sh

