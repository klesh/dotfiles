#!/bin/bash

DIR=$(readlink -f $(dirname $0))
. $DIR/../env.sh

# for better looking
case "$PM" in
    apt)
        sudo apt install -y \
            lxappearance arc-theme qt5ct qt5-style-plugins
        # install arc-icon-theme
        git clone https://github.com/horst3180/arc-icon-theme --depth 1  /tmp/arc-icon-theme && cd /tmp/arc-icon-theme
        ./autogen.sh --prefix=/usr
        sudo make install
        rm -rf /tmp/arc-icon-theme
        cd -
        ;;
    pacman)
        sudo pacman -S --needed \
            lxappearance arc-gtk-theme arc-icon-theme qt5ct qt5-styleplugins
        ;;
esac

