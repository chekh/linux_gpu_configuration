#!/bin/bash

# Load environment variables from the configuration file
set -a
source ./config.env
set +a

# Function to check if a package is installed
function is_installed() {
  dpkg -l | grep -qw "$1"
}

# Remove the previous window manager if specified in the config
if [ "$CLEAR_PREVIOUS_WM" == "true" ]; then
  echo "Clearing previous window manager..."

  # Identify and remove the previous window manager
  case "$WINDOW_MANAGER" in
    xfce)
      if is_installed "gnome-shell"; then
        sudo apt-get remove --purge -y ubuntu-desktop gnome-shell
      elif is_installed "kde-plasma-desktop"; then
        sudo apt-get remove --purge -y kde-plasma-desktop
      elif is_installed "cinnamon-desktop-environment"; then
        sudo apt-get remove --purge -y cinnamon-desktop-environment
      elif is_installed "mate-desktop-environment"; then
        sudo apt-get remove --purge -y mate-desktop-environment
      elif is_installed "mint-meta-cinnamon"; then
        sudo apt-get remove --purge -y mint-meta-cinnamon
      fi
      ;;
    gnome)
      if is_installed "xfce4"; then
        sudo apt-get remove --purge -y xfce4 xfce4-goodies
      elif is_installed "kde-plasma-desktop"; then
        sudo apt-get remove --purge -y kde-plasma-desktop
      elif is_installed "cinnamon-desktop-environment"; then
        sudo apt-get remove --purge -y cinnamon-desktop-environment
      elif is_installed "mate-desktop-environment"; then
        sudo apt-get remove --purge -y mate-desktop-environment
      elif is_installed "mint-meta-cinnamon"; then
        sudo apt-get remove --purge -y mint-meta-cinnamon
      fi
      ;;
    kde)
      if is_installed "xfce4"; then
        sudo apt-get remove --purge -y xfce4 xfce4-goodies
      elif is_installed "ubuntu-desktop"; then
        sudo apt-get remove --purge -y ubuntu-desktop gnome-shell
      elif is_installed "cinnamon-desktop-environment"; then
        sudo apt-get remove --purge -y cinnamon-desktop-environment
      elif is_installed "mate-desktop-environment"; then
        sudo apt-get remove --purge -y mate-desktop-environment
      elif is_installed "mint-meta-cinnamon"; then
        sudo apt-get remove --purge -y mint-meta-cinnamon
      fi
      ;;
    cinnamon)
      if is_installed "xfce4"; then
        sudo apt-get remove --purge -y xfce4 xfce4-goodies
      elif is_installed "ubuntu-desktop"; then
        sudo apt-get remove --purge -y ubuntu-desktop gnome-shell
      elif is_installed "kde-plasma-desktop"; then
        sudo apt-get remove --purge -y kde-plasma-desktop
      elif is_installed "mate-desktop-environment"; then
        sudo apt-get remove --purge -y mate-desktop-environment
      elif is_installed "mint-meta-cinnamon"; then
        sudo apt-get remove --purge -y mint-meta-cinnamon
      fi
      ;;
    mate)
      if is_installed "xfce4"; then
        sudo apt-get remove --purge -y xfce4 xfce4-goodies
      elif is_installed "ubuntu-desktop"; then
        sudo apt-get remove --purge -y ubuntu-desktop gnome-shell
      elif is_installed "kde-plasma-desktop"; then
        sudo apt-get remove --purge -y kde-plasma-desktop
      elif is_installed "cinnamon-desktop-environment"; then
        sudo apt-get remove --purge -y cinnamon-desktop-environment
      elif is_installed "mint-meta-cinnamon"; then
        sudo apt-get remove --purge -y mint-meta-cinnamon
      fi
      ;;
    mint)
      if is_installed "xfce4"; then
        sudo apt-get remove --purge -y xfce4 xfce4-goodies
      elif is_installed "ubuntu-desktop"; then
        sudo apt-get remove --purge -y ubuntu-desktop gnome-shell
      elif is_installed "kde-plasma-desktop"; then
        sudo apt-get remove --purge -y kde-plasma-desktop
      elif is_installed "cinnamon-desktop-environment"; then
        sudo apt-get remove --purge -y cinnamon-desktop-environment
      elif is_installed "mate-desktop-environment"; then
        sudo apt-get remove --purge -y mate-desktop-environment
      fi
      ;;
  esac

  echo "Previous window manager cleared."
fi
