#!/bin/bash
set -e


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
echo "Your device will restart after the script is installed. Be sure to save any work you have open."
echo "You need to be in plasma-mobile for the autostart to work."
read -n 1 -s -r -p "Press any key to continue, or CTRL+C to quit"
echo

CURRENT_DIR=$(pwd)
CONFIG_DIR="$HOME/.config/gamescope-plasma-thor/"
INPL_DIR="$HOME/inputplumber/"
INSTALL_DIR="$CONFIG_DIR/tmp/install/thor-gamescope-kde-main"
SUDOERS_DIR="$INSTALL_DIR/etc/sudoers.d"
SUDOERS_SYSTEM="/etc/sudoers.d/"

# folder init
if [ ! -d "$CONFIG_DIR" ] || [ ! -d "$CONFIG_DIR/tmp/install/" ]; then
		mkdir -p "$CONFIG_DIR/tmp/install"
fi

if [ ! -d "$INPL_DIR/profiles/" ]; then
		mkdir -p "$INPL_DIR/profiles/"
fi

if [ ! -d "$HOME/.local/bin/" ]; then
		mkdir -p "$HOME/.local/bin/"
fi

if [ ! -d "$HOME/.local/share/applications" ]; then
		mkdir -p "$HOME/.local/share/applications/"
fi

if [ ! -d "$HOME/.config/systemd/" ] || [ ! -d "$HOME/.config/systemd/user/" ]; then
		mkdir -p "$HOME/.config/systemd/user"
fi

if [ ! -d "$HOME/.config/inputplumber/" ] || [ ! -d "$HOME/.config/inputplumber/profiles/" ]; then
		mkdir -p "$HOME/.config/inputplumber/profiles/"
fi

copy_loop () {
	DIR=$1
	DEST=$2
	LIST=$(ls $DIR)
	for file in $LIST; do {
		cp "$DIR/$file" "$DEST/$file" -r
	}
	done
}

plusx_loop () {
	DIR=$1
	LIST=$(ls $DIR)
	for file in $LIST; do {
		chmod +x "$DIR/$file"
	}
	done
}

# download source
cd "$CONFIG_DIR/tmp/install/"
curl -L "https://github.com/winghugs/thor-gamescope-kde/archive/refs/heads/master.zip" -o "./install.zip"
unzip "install.zip" -d .
rm "$CONFIG_DIR/tmp/install/install.zip"

# everything that needs root
SUDOERS_FILES=$(ls $SUDOERS_DIR)

for file in $SUDOERS_FILES; do {
		sudo cp "$SUDOERS_DIR/$file" "$SUDOERS_SYSTEM/$file"
		sudo chmod 0440 "$SUDOERS_SYSTEM/$file"
}
done

# the default capability map for the AYN Button has it set to quickaccess instead of quickaccess2.
# this change is permanant, but shouldn't effect base user experience.
sudo mkdir -p "/etc/inputplumber/capability_maps.d/"
sudo cp "$INSTALL_DIR/etc/inputplumber/capability_maps.d/"* "/etc/inputplumber/capability_maps.d/"



# no more root needed
plusx_loop "$INSTALL_DIR/local/bin/"
copy_loop "$INSTALL_DIR/local/bin" "$HOME/.local/bin"
copy_loop "$INSTALL_DIR/local/share/applications" "$HOME/.local/share/applications"
copy_loop "$INSTALL_DIR/config/inputplumber/profiles/" "$HOME/.config/inputplumber/profiles/"
copy_loop "$INSTALL_DIR/config/plasma-gamescope-thor/" "$HOME/.config/plasma-gamescope-thor/"
copy_loop "$INSTALL_DIR/config/systemd/user/" "$HOME/.config/systemd/user/"

cd "$CURRENT_DIR"
rm -r "$CONFIG_DIR/tmp/install"
echo
echo
echo
echo
echo "All done! Rebooting in 5..."
sleep 1
echo "4..."
sleep 1
echo "3..."
sleep 1
echo "2..."
sleep 1
echo "1..."
sleep 1
systemctl reboot
