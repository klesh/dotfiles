#!/bin/bash

DIR=$(readlink -f $(dirname $0))
. $DIR/../env.sh

# install nvim
case "$PM" in
    apt)
        sudo apt install -y dunst
        ;;
    pacman)
        sudo pacman -S --needed dunst
        ;;
esac

# symlink configuration
lnsf $DIR/config/dunstrc $XDG_CONFIG_HOME/dunst/dunstrc
lnsf $DIR/config/launch.sh $XDG_CONFIG_HOME/dunst/launch.sh
