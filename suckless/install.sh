#!/bin/bash

DIR=$(readlink -f $(dirname $0))
. $DIR/../env.sh

$ROOT/fish/install.sh
$ROOT/gui/install.sh
$ROOT/picom/install.sh
$ROOT/dunst/install.sh

# install dependencies
case "$PM" in
    apt)
        sudo apt install \
            xorg libx11-dev libxft-dev libxinerama-dev \
            libxrandr-dev arandr autorandr \
            ibus ibus-table ibus-table-wubi \
            pavucontrol \
            gnome-keyring \
            xss-lock \
            nitrogen \
            lm-sensors \
            trayer
        sudo apt remove gdm3
        ;;
    pacman)
        sudo pacman -S --needed \
            xorg-server xorg-xinit xorg-xrandr xorg-xev xorg-xprop \
            alsa-firmware alsa-utils alsa-plugins pulseaudio-alsa pulseaudio pavucontrol  \
            arandr autorandr \
            ibus ibus-table ibus-table-chinese \
            gnome-keyring \
            xss-lock \
            nitrogen \
            i2c-tools \
            trayer
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
rm ~/.xinitrc
cat <<EOT > ~/.xinitrc
export QT_QPA_PLATFORMTHEME="qt5ct"
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

export XMODIFIERS="@im=ibus"
export QT_IM_MODULE=xim
export GTK_IM_MODULE=xim


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


# config dwm
[[ -L $XDG_CONFIG_HOME/dwm/autostart ]] && rm $XDG_CONFIG_HOME/dwm/autostart
mkdir -p $DIR/config/dwm
cp $DIR/config/dwm/autostart $XDG_CONFIG_HOME/dwm/autostart
lnsf $DIR/config/dwm/dwmbar $XDG_CONFIG_HOME/dwm/dwmbar
lnsf $DIR/config/autorandr/postswitch $XDG_CONFIG_HOME/autorandr/postswitch
