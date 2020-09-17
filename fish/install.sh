#!/bin/bash

DIR=$(readlink -f $(dirname $0))
. $DIR/../env.sh

# install fish shell
case "$PM" in
    apt)
        sudo add-apt-repository ppa:fish-shell/release-3 -y
        sudo apt update
        sudo apt install fish libnotify-bin xdotool -y
        ;;
    pacman)
        sudo pacman -S fish xdotool
        ;;
esac

# set fish as default shell
DEFAULT_SHELL=$(getent passwd $USER | cut -d: -f7)
FISH_SHELL=$(which fish)
if [ "$DEFAULT_SHELL" != "$FISH_SHELL" ]; then
    chsh -s $FISH_SHELL
fi

# symlink config
lnsf $DIR/config ~/.config/fish
