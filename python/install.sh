#!/bin/bash

DIR=$(readlink -f $(dirname $0))
. $DIR/../env.sh

# install python3
case "$PM" in
    apt)
        sudo apt install python3 python3-pip
        fish-is-default-shell && sudo pip3 install virtualfish
        ;;
    pacman)
        sudo pacman -S python python-pip
        fish-is-default-shell && sudo pip install virtualfish
        ;;
esac

# enable auto_activation plugin for virtualfish
fish-is-default-shell && fish -c "vf addplugins auto_activation"


# config pip mirror for CHINA
if in-china; then
    mkdir -p ~/.pip
    ln -sf $DIR/pip.conf ~/.pip/pip.conf
fi
