#!/bin/bash

DIR=$(readlink -f $(dirname $0))
. $DIR/../env.sh

# for better looking
case "$PM" in
    apt)
        sudo apt install -y \
            lxappearance arc-theme qt5ct qt5-style-plugins
        ;;
    pacman)
        sudo pacman -S --needed \
            lxappearance arc-gtk-theme arc-icon-theme qt5ct qt5-styleplugins
        ;;
esac

# configuration
lnsf $DIR/config/gtk-3.0/settings.ini ~/.config/gtk-3.0/settings.ini
lnsf $DIR/config/qt5ct/qt5ct.conf ~/.config/qt5ct/qt5ct.conf
