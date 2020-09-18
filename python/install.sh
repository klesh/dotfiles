#!/bin/bash

DIR=$(readlink -f $(dirname $0))
. $DIR/../env.sh

# config pip mirror for CHINA
if in-china; then
    lnsf $DIR/pip.conf ~/.pip/pip.conf
    if sudo [ ! -f /root/.pip/pip.conf ]; then
        sudo mkdir -p /root/.pip
        sudo cp $DIR/pip.conf /root/.pip/pip.conf
    fi
fi

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
fish-is-default-shell && fish -c "yes | vf install && vf addplugins auto_activation"


