#!/bin/bash

DIR=$(readlink -f $(dirname $0))
. $DIR/../env.sh

# install ranger
case "$PM" in
    apt)
        ! which pip3 && $ROOT/python/install.sh
        sudo pip3 install ranger-fm ueberzug
        ;;
    pacman)
        sudo pacman -S --needed ranger ueberzug
        ;;
esac

lnsf $DIR/config ~/.config/ranger
