#!/bin/bash

# root check
if [ $(id -u) -eq 0 ]
  then echo "Please do not run this script as root, try again without sudo."
  exit
fi

echo "Plasma Mobile - Steam Environment Installer"
echo "------"
echo "This is only intended to be installed on the AYN Thor, and was tested on pocknix."
echo "Do not install this on any other device"
echo "You will be asked for your sudo password, be prepared for that."
read -n 1 -s -r -p "Press any key to continue, or CTRL+C to quit"
echo

CONFIG_DIR="$HOME/.config/gamescope-plasma-thor/"
INPL_DIR="$HOME/inputplumber/"

if [ ! -d "$CONFIG_DIR/tmp/install"]; then
		mkdir -p "$CONFIG_DIR/tmp/install"
fi



cd "$CONFIG_DIR/tmp/install/"


curl -L "https://github.com/winghugs/thor-gamescope-kde/archive/refs/heads/master.zip" -o "install.zip"
unzip -j "install.zip" -d .
rm "install.zip"

# root stuff

sudo chmod 0440 /etc/sudoers.d/11-ds-backlight
