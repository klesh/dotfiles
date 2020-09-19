#!/bin/bash

DIR=$(readlink -f $(dirname $0))
. $DIR/../env.sh

PICOM_VER=v8.1


# install ranger
case "$PM" in
    apt)
        # install build tools
        ! which pip3 && $ROOT/python/install.sh
        sudo pip3 install meson
        # install dependencies
        sudo apt install -y ninja-build libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-randr0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libxcb-glx0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev  libpcre3-dev  libevdev-dev uthash-dev libev-dev libx11-xcb-dev
        ;;
    pacman)
        sudo pacman -S --needed uthash ninja meson
        ;;
esac

# build and install picom-next
curl 'https://github.com/yshui/picom/archive/next.zip' -sLo /tmp/picom-next.zip
unzip /tmp/picom-next.zip -d /tmp
pushd /tmp/picom-next
meson --buildtype=release . build
sudo ninja -C build install
popd
sudo rm -rf /tmp/picom*

# configuration
lnsf $DIR/config ~/.config/picom
