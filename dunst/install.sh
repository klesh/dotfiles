#!/bin/bash

DIR=$(readlink -f $(dirname $0))
. $DIR/../env.sh

# check dependencies
! which yarnpkg && $ROOT/nodejs/install.sh

# install nvim
case "$PM" in
    apt)
        sudo apt install -y dunst
        ;;
    pacman)
        sudo pacman -S dunst
        ;;
esac

# symlink configuration
lnsf $DIR/config ~/.config/dunst
