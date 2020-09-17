#!/bin/bash

DIR=$(readlink -f $(dirname $0))
. $DIR/../env.sh

# install python3
case "$PM" in
    apt)
        sudo apt install python3 python3-pip
        ;;
    pacman)
        sudo pacman -S python
        ;;
esac

# config pip mirror for CHINA
if in-china; then
    mkdir -p ~/.pip
    ln -sf $DIR/pip.conf ~/.pip/pip.conf
fi
