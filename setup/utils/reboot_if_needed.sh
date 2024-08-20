#!/bin/bash

# Check if the system needs a reboot
if [ -f /var/run/reboot-required ]; then
    echo "System reboot is required. Rebooting now..."
    sudo reboot
else
    echo "No reboot required. Continuing setup..."
fi
