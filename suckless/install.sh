#!/bin/bash

DIR=$(readlink -f $(dirname $0))
. $DIR/../env.sh

$ROOT/fonts/install.sh

# install dependencies
case "$PM" in
    apt)
        sudo apt install \
            build-essential \
            unzip \
            xorg \
            libx11-dev \
            libxft-dev \
            libxinerama-dev \
            libxrandr-dev \
            arandr \
            autorandr \
            libxrandr-dev \
            ibus ibus-table ibus-table-wubi \
            gnome-keyring \
            trayer
        sudo apt remove gdm3
        ;;
    pacman)
        echo TO DO
        exit -1
        ;;
esac




# clone / compile utilities and dwm itself

mkdir -p ~/Projects/suckless

[! -d ~/Projects/suckless/st] && git clone https://gitee.com/klesh/st.git ~/Projects/suckless/st
cd ~/Projects/suckless/st && sudo rm -f config.h && sudo make clean install

[! -d ~/Projects/suckless/dmenu] &&git clone https://gitee.com/klesh/dmenu.git ~/Projects/suckless/dmenu
cd ~/Projects/suckless/dmenu && sudo rm -f config.h && sudo make clean install

[! -d ~/Projects/suckless/slock] &&git clone https://gitee.com/klesh/slock.git ~/Projects/suckless/slock
cd ~/Projects/suckless/slock && sudo rm -f config.h && sudo make clean install

[! -d ~/Projects/suckless/dwm] &&git clone https://gitee.com/klesh/dwm.git ~/Projects/suckless/dwm
cd ~/Projects/suckless/dwm && sudo rm -f config.h && sudo make clean install

# config xinit to start for dwm

cat <<EOT > ~/.xinitrc
export QT_QPA_PLATFORMTHEME="qt5ct"
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

export XMODIFIERS="@im=ibus"
export QT_IM_MODULE=ibus
export GTK_IM_MODULE=ibus


# xrandr --setprovideroutputsource modesetting NVIDIA-0
# xrandr --auto


xrdb ~/.Xresources

# auto lock after 300 seconds
xset s 300
systemd-lock-handler /usr/local/bin/slock

#xsetroot -cursor_name left_ptr

dbus-update-activation-environment --systemd DISPLAY
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK

autorandr --change --force
while :; do
	ssh-agent dwm 2>/tmp/dwm.log || break
done
EOT