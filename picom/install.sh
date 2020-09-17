#!/bin/bash

DIR=$(readlink -f $(dirname $0))
. $DIR/../env.sh

$PICOM_VER=v8.1


# install ranger
case "$PM" in
    apt)
        # install build tools
        ! which pip3 && $ROOT/python/install.sh
        sudo pip install ninja-build meson
        # install dependencies
        sudo apt install libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-randr0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libxcb-glx0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev  libpcre2-dev  libevdev-dev uthash-dev libev-dev libx11-xcb-dev
        # download picom source
        [ ! -f /tmp/picom.tar.gz ] && \
            curl -L https://github.com/yshui/picom/archive/v8.1.tar.gz --output /tmp/picom.tar.gz
        # build and install
        mkdir -p /tmp/picom
        tar zxvf /tmp/picom.tar.gz --strip 1 -C /tmp/picom
        pushd /tmp/picom
        git submodule update --init --recursive
        meson --buildtype=release . build
        ninja -C build install
        ;;
    pacman)
        sudo pacman -S picom
        ;;
esac

# symlink configuration
lnsf $DIR/config ~/.config/picom