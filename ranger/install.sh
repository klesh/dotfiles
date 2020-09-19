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
        sudo pip install ranger-fm ueberzug
        ;;
esac

lnsf $DIR/config $XDG_CONFIG_HOME/ranger
