#!/bin/sh

set -e
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

log 'Setting up theme'

case "$PM" in
    apt)
        sudo apt install -y \
            lxappearance arc-theme qt5ct qt5-style-plugins
        # install arc-icon-theme
        intorepo https://github.com/horst3180/arc-icon-theme /tmp/arc-icon-theme
        ./autogen.sh --prefix=/usr
        sudo make install
        rm -rf /tmp/arc-icon-theme
        exitrepo
        ;;
    pacman)
        sudo pacman -S --noconfirm --needed \
            lxappearance arc-gtk-theme arc-icon-theme qt5ct qt5-styleplugins
        ;;
esac

